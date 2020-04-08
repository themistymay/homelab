#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER prometheus WITH SUPERUSER PASSWORD 'prometheus';
    CREATE DATABASE prometheus;
    GRANT ALL PRIVILEGES ON DATABASE prometheus TO prometheus;
EOSQL