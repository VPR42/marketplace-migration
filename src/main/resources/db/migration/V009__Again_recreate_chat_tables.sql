-- 1. Удаляем messages, чтобы не мешали внешние ключи
DROP TABLE IF EXISTS messages;

-- 2. Удаляем старую таблицу chats
DROP TABLE IF EXISTS chats;

-- 3. Создаём новую таблицу chats
--    - свой UUID PK
--    - ссылка на job
CREATE TABLE chats
(
    id          UUID PRIMARY KEY,
    job_id      UUID NOT NULL REFERENCES jobs (id) ON DELETE CASCADE,
    master_id   UUID NOT NULL REFERENCES users (id),
    customer_id UUID NOT NULL REFERENCES users (id)
);

-- 4. Создаём таблицу messages, ссылающуюся на chats(id)
CREATE TABLE messages
(
    id      UUID PRIMARY KEY,
    chat_id UUID                     NOT NULL REFERENCES chats (id) ON DELETE CASCADE,
    sender  UUID                     NOT NULL REFERENCES users (id),
    content TEXT                     NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- 5. Индексы для чатов

-- выборка чатов, где пользователь мастер
CREATE INDEX idx_chats_master
    ON chats (master_id);

-- выборка чатов, где пользователь кастомер
CREATE INDEX idx_chats_customer
    ON chats (customer_id);

-- уникальность чата по услуге и кастомеру:
-- один пользователь не может создать два чата по одной и той же услуге
CREATE UNIQUE INDEX uq_chats_job_customer
    ON chats (job_id, customer_id);

-- 6. Индекс для сообщений
-- сообщения по чату с сортировкой времени по убыванию
CREATE INDEX idx_messages_chat_sent_at
    ON messages (chat_id, sent_at DESC);
