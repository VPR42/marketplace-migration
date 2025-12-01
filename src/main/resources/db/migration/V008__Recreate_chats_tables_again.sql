-- 1. Удаляем messages, чтобы не мешали внешние ключи
DROP TABLE IF EXISTS messages;

-- 2. Удаляем старую таблицу chats
DROP TABLE IF EXISTS chats;

-- 3. Создаём новую таблицу chats с PK = job_id и без status
CREATE TABLE chats
(
    job_id      UUID PRIMARY KEY REFERENCES jobs (id) ON DELETE CASCADE,
    master_id   UUID NOT NULL REFERENCES users (id),
    customer_id UUID NOT NULL REFERENCES users (id)
);

-- 4. Создаём таблицу messages, ссылающуюся на chats(job_id)
CREATE TABLE messages
(
    id      UUID PRIMARY KEY,
    chat_id UUID                     NOT NULL REFERENCES chats (job_id) ON DELETE CASCADE,
    sender  UUID                     NOT NULL REFERENCES users (id),
    content TEXT                     NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- 5. Восстанавливаем индексы для чатов

-- чаты, где пользователь мастер
CREATE INDEX idx_chats_master_status
    ON chats (master_id);

-- чаты, где пользователь кастомер
CREATE INDEX idx_chats_customer_status
    ON chats (customer_id);

-- чаты по челиксам (мастер + кастомер уникальны)
CREATE UNIQUE INDEX uq_chats_master_customer
    ON chats (master_id, customer_id);

-- 6. Восстанавливаем индекс для сообщений
-- сообщения по чату с сортировкой времени по убыванию
CREATE INDEX idx_messages_chat_sent_at
    ON messages (chat_id, sent_at DESC);
