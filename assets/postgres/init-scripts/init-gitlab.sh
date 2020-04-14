#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER gitlab WITH SUPERUSER PASSWORD 'gitlab';
    CREATE DATABASE gitlabhq_production;
    GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production TO gitlab;
EOSQL