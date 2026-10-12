-- Runs once, when the PostgreSQL container starts with an empty data volume.
-- recall_db is created automatically from POSTGRES_DB in docker-compose.yml.
-- notification-service needs its own separate database:
CREATE DATABASE notification_db;