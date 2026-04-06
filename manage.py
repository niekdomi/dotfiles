#!/usr/bin/env python3
"""Dotfiles manager — deploy and sync dotfiles to/from the system."""

import argparse
import shutil
import sys
from datetime import datetime
from pathlib import Path
from typing import Final

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

DOTFILES_DIR: Final[Path] = Path(__file__).parent.resolve()
CONFIG_DIR: Final[Path] = Path.home() / ".config"
HOME_DIR: Final[Path] = Path.home()

# Items that live directly under ~/.config/
CONFIG_ITEMS: Final[list[str]] = [
    "Code",
    "btop",
    "clangd",
    "fastfetch",
    "fish",
    "ghostty",
    "lazygit",
    "nvim",
    "nvim_minimal",
    "tealdeer",
    "yazi",
    "zathura",
    "zed",
]

# Files/dirs that need a fully-replaced sync (no filtering)
FULL_SYNC_FOLDERS: Final[list[str]] = [
    "ghostty",
    "fastfetch",
    "lazygit",
    "tealdeer",
    "zathura",
]

ZED_FILES: Final[list[str]] = [
    "keymap.json",
    "run_or_compile.sh",
    "settings.json",
    "tasks.json",
]

# ------------------------------------------------------------------------------
# Logging helpers
# ------------------------------------------------------------------------------

RESET: Final[str] = "\033[0m"
BLUE: Final[str] = "\033[34m"
GREEN: Final[str] = "\033[32m"
YELLOW: Final[str] = "\033[33m"
RED: Final[str] = "\033[31m"
BOLD: Final[str] = "\033[1m"


def _msg(color: str, tag: str, text: str, *, err: bool = False) -> None:
    line = f"{BOLD}{color}[{tag}]{RESET} {text}"
    print(line, file=sys.stderr if err else sys.stdout)


def info(msg: str) -> None:
    _msg(BLUE, "INFO", msg)


def success(msg: str) -> None:
    _msg(GREEN, "SUCCESS", msg)


def warning(msg: str) -> None:
    _msg(YELLOW, "WARNING", msg)


def error(msg: str) -> None:
    _msg(RED, "ERROR", msg, err=True)


# ------------------------------------------------------------------------------
# Core helpers
# ------------------------------------------------------------------------------


def backup_if_exists(target: Path) -> None:
    """Move `target` aside with a timestamped suffix if it already exists."""
    if not target.exists():
        return
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup = target.parent / f"{target.name}.backup.{stamp}"
    shutil.move(str(target), str(backup))
    warning(f"Backed up: {target} → {backup.name}")


def smart_copy(
    src: Path,
    dest: Path,
    *,
    ignore_patterns: list[str] | None = None,
) -> None:
    """Copy `src` (file or directory) to `dest`, with optional exclusions."""
    if not src.exists():
        error(f"Source does not exist: {src}")
        return

    dest.parent.mkdir(parents=True, exist_ok=True)

    if src.is_dir():
        kwargs: dict = {"dirs_exist_ok": True}
        if ignore_patterns:
            kwargs["ignore"] = shutil.ignore_patterns(*ignore_patterns)
        shutil.copytree(src, dest, **kwargs)
    else:
        shutil.copy2(src, dest)


def replace_dir(
    src: Path, dest: Path, *, ignore_patterns: list[str] | None = None
) -> None:
    """Remove *dest* entirely, then copy *src* in its place."""
    if dest.exists():
        shutil.rmtree(dest)
    smart_copy(src, dest, ignore_patterns=ignore_patterns)


# ------------------------------------------------------------------------------
# Commands
# ------------------------------------------------------------------------------


def cmd_load(_args: argparse.Namespace) -> None:
    """Deploy dotfiles from the repo to the live system."""
    info("Loading dotfiles to system…")

    # ~/.config/* items
    for item in CONFIG_ITEMS:
        src = DOTFILES_DIR / item
        if not src.exists():
            continue

        if item == "Code":
            code_dest = CONFIG_DIR / "Code"
            oss_dest = CONFIG_DIR / "Code - OSS"

            if not code_dest.exists() and not oss_dest.exists():
                backup_if_exists(code_dest)
                smart_copy(src, code_dest)
                success("Loaded: Code → ~/.config/Code/")
            else:
                if code_dest.exists():
                    backup_if_exists(code_dest)
                    smart_copy(src, code_dest)
                    success("Loaded: Code → ~/.config/Code/")
                if oss_dest.exists():
                    backup_if_exists(oss_dest)
                    smart_copy(src, oss_dest)
                    success("Loaded: Code → ~/.config/Code - OSS/")
        else:
            dest = CONFIG_DIR / item
            backup_if_exists(dest)
            smart_copy(src, dest)
            success(f"Loaded: {item} → ~/.config/")

    # Home-directory / mixed-location files
    home_map: dict[str, Path] = {
        ".ideavimrc": HOME_DIR / ".ideavimrc",
        ".clang-format": HOME_DIR / ".clang-format",
        "starship.toml": CONFIG_DIR / "starship.toml",
    }
    for name, dest_path in home_map.items():
        src_path = DOTFILES_DIR / name
        if not src_path.exists():
            continue
        backup_if_exists(dest_path)
        smart_copy(src_path, dest_path)
        success(f"Loaded: {name}")

    success("Dotfiles loaded successfully!")


def cmd_update(_args: argparse.Namespace) -> None:
    """Sync files from the live system back into the dotfiles repo."""
    info("Updating dotfiles from system…")

    # Full folder replacements
    for folder in FULL_SYNC_FOLDERS:
        src = CONFIG_DIR / folder
        if not src.exists():
            continue
        replace_dir(src, DOTFILES_DIR / folder)
        success(f"Updated: {folder}/ (full)")

    # VS Code — prefer whichever variant is installed
    for variant in ("Code", "Code - OSS"):
        src_user = CONFIG_DIR / variant / "User"
        if not src_user.exists():
            continue
        dest_user = DOTFILES_DIR / "Code" / "User"
        dest_user.mkdir(parents=True, exist_ok=True)
        for fname in ("settings.json", "keybindings.json"):
            src_file = src_user / fname
            if src_file.exists():
                shutil.copy2(src_file, dest_user / fname)
        success(f"Updated: Code/ from {variant}")
        break

    # Neovim
    nvim_src = CONFIG_DIR / "nvim"
    if nvim_src.exists():
        replace_dir(nvim_src, DOTFILES_DIR / "nvim")
        success("Updated: nvim/")

    # Yazi (skip generated plugin/flavor caches)
    yazi_src = CONFIG_DIR / "yazi"
    if yazi_src.exists():
        replace_dir(
            yazi_src, DOTFILES_DIR / "yazi", ignore_patterns=["flavors", "plugins"]
        )
        success("Updated: yazi/ (filtered)")

    # Zed (individual files only)
    zed_src = CONFIG_DIR / "zed"
    if zed_src.exists():
        zed_dest = DOTFILES_DIR / "zed"
        zed_dest.mkdir(parents=True, exist_ok=True)
        for fname in ZED_FILES:
            src_file = zed_src / fname
            if src_file.exists():
                shutil.copy2(src_file, zed_dest / fname)
                success(f"Updated: zed/{fname}")

    # Miscellaneous home-dir files
    home_files: list[tuple[str, Path]] = [
        (".ideavimrc", HOME_DIR / ".ideavimrc"),
        ("starship.toml", CONFIG_DIR / "starship.toml"),
    ]
    for name, src_path in home_files:
        if src_path.exists():
            shutil.copy2(src_path, DOTFILES_DIR / name)
            success(f"Updated: {name}")

    success("Dotfiles updated successfully!")


# ------------------------------------------------------------------------------
# CLI entry-point
# ------------------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="dotfiles",
        description="Manage dotfiles — deploy to or sync from the live system.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "  dotfiles load    # deploy repo → ~/.config & ~/\n"
            "  dotfiles update  # sync system → repo\n"
        ),
    )
    sub = parser.add_subparsers(dest="command", metavar="<command>")
    sub.required = True

    sub.add_parser(
        "load",
        help="Deploy dotfiles from the repo to the system.",
    ).set_defaults(func=cmd_load)

    sub.add_parser(
        "update",
        help="Sync dotfiles from the system back to the repo.",
    ).set_defaults(func=cmd_update)

    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
