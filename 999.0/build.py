#!/usr/bin/env python
# -*- coding: utf-8 -*-

import shutil
import sys
from pathlib import Path


def _rmtree(path: Path):
    if path.exists():
        shutil.rmtree(str(path))


def _copytree(src: Path, dst: Path):
    _rmtree(dst)
    shutil.copytree(str(src), str(dst))


def _copyfile(src: Path, dst: Path):
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(str(src), str(dst))


def _verify_payload(source_path: Path):
    payload_exe = source_path / "pgsql" / "bin" / "postgres.exe"
    if not payload_exe.exists():
        raise SystemExit(
            f"[ERROR] Missing payload: {payload_exe}\n"
            "Please ensure PostgreSQL binaries are extracted into ./pgsql first."
        )


def _load_pkg_info(source_path: Path):
    pkg_file = source_path / "package.py"
    data = {}
    code = pkg_file.read_text(encoding="utf-8")
    exec(compile(code, str(pkg_file), "exec"), data, data)
    name = data.get("name")
    version = data.get("version")
    if not name or not version:
        raise SystemExit("[ERROR] Failed to read name/version from package.py")
    return str(name), str(version)


def install(source_path: Path, install_path: Path):
    """
    Called by wuwo's rez wrapper:
      python build.py <source_path> <install_path>
    """
    _verify_payload(source_path)

    pkg_name, pkg_version = _load_pkg_info(source_path)

    # install_path might be a package repository root; install into name/version.
    target = install_path
    if target.name != pkg_version or target.parent.name != pkg_name:
        target = install_path / pkg_name / pkg_version

    target.mkdir(parents=True, exist_ok=True)

    _copytree(source_path / "pgsql", target / "pgsql")
    _copytree(source_path / "src", target / "src")
    _copyfile(source_path / "package.py", target / "package.py")
    if (source_path / "README.md").exists():
        _copyfile(source_path / "README.md", target / "README.md")


def main(argv):
    if len(argv) != 3:
        raise SystemExit(
            "Usage:\n"
            "  python build.py <source_path> <install_path>\n"
        )

    source_path = Path(argv[1]).resolve()
    install_path = Path(argv[2]).resolve()
    install_path.mkdir(parents=True, exist_ok=True)
    install(source_path, install_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

