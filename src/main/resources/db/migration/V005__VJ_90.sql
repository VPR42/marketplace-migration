BEGIN;

----------------------------------------------------------------------
-- 1. Переименование колонок участников чата на master и customer
--    messages.first_user  -> master_id
--    messages.second_user -> customer_id
----------------------------------------------------------------------

ALTER TABLE messages
    RENAME COLUMN first_user TO master_id;

ALTER TABLE messages
    RENAME COLUMN second_user TO customer_id;

----------------------------------------------------------------------
-- 2. Добавить колонку about в masters_info
----------------------------------------------------------------------

ALTER TABLE masters_info
    ADD COLUMN about TEXT NULL;

----------------------------------------------------------------------
-- 3. Заменить типы колонок с ссылками на изображение на TEXT
----------------------------------------------------------------------

ALTER TABLE jobs
    ALTER COLUMN cover_url TYPE TEXT;

----------------------------------------------------------------------
-- 4. Добавить колонку status_changed_at в orders
--    проинициализированы текущие записи ordered_at
----------------------------------------------------------------------

ALTER TABLE orders
    ADD COLUMN status_changed_at TIMESTAMP WITH TIME ZONE;

UPDATE orders
SET status_changed_at = ordered_at
WHERE status_changed_at IS NULL;

----------------------------------------------------------------------
-- 5. Заменить working_hours на 3 колонки:
--    days_of_week INT[],
--    start_time   VARCHAR(5),
--    end_time     VARCHAR(5)
----------------------------------------------------------------------

ALTER TABLE masters_info
    ADD COLUMN days_of_week INT[]      NULL,
    ADD COLUMN start_time   VARCHAR(5) NULL,
    ADD COLUMN end_time     VARCHAR(5) NULL;

ALTER TABLE masters_info
    DROP COLUMN working_hours;

COMMIT;
