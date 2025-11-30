CREATE UNIQUE INDEX IF NOT EXISTS uq_chats_master_customer
    ON chats (master_id, customer_id);
