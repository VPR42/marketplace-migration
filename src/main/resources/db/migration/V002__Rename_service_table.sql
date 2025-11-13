-- V2__rename_services_to_jobs.sql
-- Миграция старой схемы (services) в новую (jobs)

BEGIN;

ALTER TABLE services
    RENAME TO jobs;

-- Переименовываем services_tags -> job_tags
ALTER TABLE services_tags
    RENAME TO job_tags;

-- Переименовываем колонку service_id -> job_id в job_tags
ALTER TABLE job_tags
    RENAME COLUMN service_id TO job_id;

-- Переименовываем колонку service_id -> job_id в favourites
ALTER TABLE favourites
    RENAME COLUMN service_id TO job_id;

-- Переименовываем колонку service_id -> job_id в orders
ALTER TABLE orders
    RENAME COLUMN service_id TO job_id;

ALTER TABLE job_tags
    RENAME CONSTRAINT services_tags_pkey TO job_tags_pkey;

COMMIT;
