#!/usr/bin/env python3
"""Install a pinned prebuilt RGBDS release into the repository.

This avoids building RGBDS from its Git/source snapshot and therefore avoids
requiring Bison merely to assemble Game Boy Wars 3.
"""
from __future__ import annotations

import argparse
import os
import platform
import shutil
import stat
import sys
import tarfile
import tempfile
import urllib.error
import urllib.request
import zipfile
from pathlib import Path

DEFAULT_VERSION = "1.0.3"
BASE_URL = "https://github.com/gbdev/rgbds/releases/download/v{version}/{asset}"
TOOLS = ("rgbasm", "rgblink", "rgbfix")


def platform_asset() -> tuple[str, str]:
    system = platform.system().lower()
    machine = platform.machine().lower()
    is_64 = machine in {"x86_64", "amd64", "x64"}
    if system == "windows":
        return ("rgbds-win64.zip" if is_64 else "rgbds-win32.zip", ".exe")
    if system == "linux" and is_64:
        return ("rgbds-linux-x86_64.tar.xz", "")
    if system == "darwin":
        return ("rgbds-macos.zip", "")
    raise RuntimeError(
        f"No official prebuilt RGBDS asset is configured for {platform.system()} "
        f"{platform.machine()}. Install RGBDS {DEFAULT_VERSION} separately and "
        "override RGBASM/RGBLINK/RGBFIX when invoking make."
    )


def safe_extract_zip(archive: Path, dest: Path) -> None:
    root = dest.resolve()
    with zipfile.ZipFile(archive) as zf:
        for info in zf.infolist():
            target = (dest / info.filename).resolve()
            if target != root and root not in target.parents:
                raise RuntimeError(f"Unsafe path in archive: {info.filename}")
        zf.extractall(dest)


def safe_extract_tar(archive: Path, dest: Path) -> None:
    root = dest.resolve()
    with tarfile.open(archive, "r:xz") as tf:
        for member in tf.getmembers():
            target = (dest / member.name).resolve()
            if target != root and root not in target.parents:
                raise RuntimeError(f"Unsafe path in archive: {member.name}")
        try:
            tf.extractall(dest, filter="data")
        except TypeError:  # Python versions before extraction filters
            tf.extractall(dest)


def find_tool(root: Path, name: str, suffix: str) -> Path:
    wanted = name + suffix
    matches = [p for p in root.rglob(wanted) if p.is_file()]
    if not matches:
        raise RuntimeError(f"The release archive did not contain {wanted}")
    # Prefer a conventional bin directory, then the shortest path.
    matches.sort(key=lambda p: (p.parent.name.lower() != "bin", len(p.parts), str(p)))
    return matches[0]


def install(version: str, dest: Path, archive_override: Path | None = None) -> None:
    asset, suffix = platform_asset()
    url = BASE_URL.format(version=version, asset=asset)
    dest.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="gbwars3-rgbds-") as td:
        temp = Path(td)
        archive = temp / asset
        if archive_override is not None:
            shutil.copy2(archive_override, archive)
        else:
            print(f"Downloading RGBDS {version}: {url}")
            request = urllib.request.Request(url, headers={"User-Agent": "GBWars3-build-bootstrap/1"})
            try:
                with urllib.request.urlopen(request, timeout=60) as src, archive.open("wb") as out:
                    shutil.copyfileobj(src, out)
            except (urllib.error.URLError, TimeoutError, OSError) as exc:
                raise RuntimeError(
                    "Could not download the RGBDS prebuilt release. Check the network, "
                    f"or install RGBDS {version} separately and override "
                    "RGBASM/RGBLINK/RGBFIX."
                ) from exc

        extracted = temp / "extract"
        extracted.mkdir()
        if asset.endswith(".zip"):
            safe_extract_zip(archive, extracted)
        elif asset.endswith(".tar.xz"):
            safe_extract_tar(archive, extracted)
        else:
            raise RuntimeError(f"Unsupported RGBDS release archive: {asset}")

        tool_sources = {}
        for tool in TOOLS:
            source = find_tool(extracted, tool, suffix)
            tool_sources[tool] = source
            target = dest / (tool + suffix)
            shutil.copy2(source, target)
            if os.name != "nt":
                target.chmod(target.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

        # Windows release builds may ship runtime DLLs next to the executables.
        if suffix == ".exe":
            seen = set()
            for source in tool_sources.values():
                for dll in source.parent.glob("*.dll"):
                    key = dll.name.lower()
                    if key not in seen:
                        shutil.copy2(dll, dest / dll.name)
                        seen.add(key)

    (dest / "VERSION").write_text(version + "\n", encoding="ascii")
    print(f"RGBDS {version} installed in {dest}")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--version", default=DEFAULT_VERSION)
    p.add_argument("--dest", type=Path, default=Path("tools/rgbds/bin"))
    p.add_argument("--archive", type=Path, help="use a local release archive instead of downloading")
    p.add_argument("--print-url", action="store_true", help="print the release asset URL and exit")
    return p.parse_args()


def main() -> int:
    args = parse_args()
    try:
        asset, _ = platform_asset()
        url = BASE_URL.format(version=args.version, asset=asset)
        if args.print_url:
            print(url)
            return 0
        install(args.version, args.dest, args.archive)
        return 0
    except Exception as exc:
        print(f"RGBDS bootstrap failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
