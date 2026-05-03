# -*- coding: utf-8 -*-

name = "postgresql"
version = "999.0"
description = "PostgreSQL server/client (self-contained payload)"
authors = ["PostgreSQL Global Development Group", "Lugwit Team"]

build_command = False
cachable = True
relocatable = True

# wuwo auto_fetch 载荷完整性（相对本版本目录，仅 is_file）
_REZ_WUWO_PAYLOAD_RELATIVE_PATHS = [
    "pgsql/bin/postgres.exe",
]


def commands():
    import platform

    if platform.system() == "Windows":
        env.POSTGRESQL_ROOT = "{root}"
        env.PGROOT = "{root}\\pgsql"
        env.PATH.prepend("{root}\\pgsql\\bin")

        alias("postgres", "{root}\\pgsql\\bin\\postgres.exe")
        alias("pg_ctl", "{root}\\pgsql\\bin\\pg_ctl.exe")
        alias("initdb", "{root}\\pgsql\\bin\\initdb.exe")
        alias("psql", "{root}\\pgsql\\bin\\psql.exe")

        alias("postgres_init", 'cmd /c "{root}/src/postgresql/bat/postgres_init.bat"')
        alias("postgres_start", 'cmd /c "{root}/src/postgresql/bat/postgres_start.bat"')
        alias("postgres_stop", 'cmd /c "{root}/src/postgresql/bat/postgres_stop.bat"')
        alias("postgres_status", 'cmd /c "{root}/src/postgresql/bat/postgres_status.bat"')
        alias("postgres_psql", 'cmd /c "{root}/src/postgresql/bat/postgres_psql.bat"')
    else:
        env.POSTGRESQL_ROOT = "{root}"
        env.PGROOT = "{root}/pgsql"
        env.PATH.prepend("{root}/pgsql/bin")

        alias("postgres", "{root}/pgsql/bin/postgres")
        alias("pg_ctl", "{root}/pgsql/bin/pg_ctl")
        alias("initdb", "{root}/pgsql/bin/initdb")
        alias("psql", "{root}/pgsql/bin/psql")
