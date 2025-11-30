CREATE TYPE chat_status AS ENUM ('OPEN', 'CLOSED');

DROP TABLE IF EXISTS "messages";

CREATE TABLE IF NOT EXISTS "chats"
(
    "order_id"    UUID PRIMARY KEY REFERENCES "orders" ("id") ON DELETE CASCADE,
    "master_id"   UUID        NOT NULL REFERENCES "users" ("id"),
    "customer_id" UUID        NOT NULL REFERENCES "users" ("id"),
    "status"      chat_status NOT NULL DEFAULT 'OPEN'
);

CREATE TABLE IF NOT EXISTS "messages"
(
    "id"      UUID PRIMARY KEY,
    "chat_id" UUID                     NOT NULL REFERENCES "chats" ("order_id") ON DELETE CASCADE,
    "sender"  UUID                     NOT NULL REFERENCES "users" ("id"),
    "content" TEXT                     NOT NULL,
    "sent_at" TIMESTAMP WITH TIME ZONE NOT NULL
);

-- чаты, где пользователь мастер
CREATE INDEX IF NOT EXISTS idx_chats_master_status
    ON "chats" ("master_id", "status");

-- чаты, где пользователь кастомер
CREATE INDEX IF NOT EXISTS idx_chats_customer_status
    ON "chats" ("customer_id", "status");

-- сообщения по чату с сортировкой времени по убыванию
CREATE INDEX IF NOT EXISTS idx_messages_chat_sent_at
    ON "messages" ("chat_id", "sent_at" DESC);
