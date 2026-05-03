# postgresql rez 包（payload 内置方案 A）

## 目录约定

把 PostgreSQL 官方发行版（Windows zip 解压后的内容）放到本包的 `pgsql/` 下，最终需要存在：

- `pgsql/bin/postgres.exe`
- `pgsql/bin/pg_ctl.exe`
- `pgsql/bin/initdb.exe`
- `pgsql/bin/psql.exe`

本包的 `package.py` 会把 `pgsql/bin` 自动加入 `PATH`，并设置：

- `POSTGRESQL_ROOT`: rez 包根目录
- `PGROOT`: `%POSTGRESQL_ROOT%\pgsql`

## 常用命令（在 rez 环境中）

- 初始化数据目录：
  - `rez-env postgresql -- postgres_init`
- 启动：
  - `rez-env postgresql -- postgres_start`
- 查看状态：
  - `rez-env postgresql -- postgres_status`
- 停止：
  - `rez-env postgresql -- postgres_stop`
- 进入 psql：
  - `rez-env postgresql -- postgres_psql`

## 可覆盖的环境变量（可选）

这些变量都可以在运行前用 `set` 覆盖：

- `POSTGRES_DATA_DIR`：数据目录（默认 `%LOCALAPPDATA%\Lugwit\PostgreSQL\data`）
- `POSTGRES_LOG`：日志路径（默认 `%LOCALAPPDATA%\Lugwit\PostgreSQL\postgresql.log`）
- `POSTGRES_PORT`：端口（默认 `5432`）
- `POSTGRES_USER`：initdb/psql 用户（默认 `postgres`）
- `POSTGRES_DB`：psql 默认数据库（默认 `postgres`）

