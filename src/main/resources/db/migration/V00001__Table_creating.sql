CREATE TABLE IF NOT EXISTS "users"
(
    "id"            uuid        NOT NULL UNIQUE,
    "lastname"      varchar     NOT NULL,
    "name"          varchar     NOT NULL,
    "patronymic"    varchar     NOT NULL,
    "email"         varchar     NOT NULL UNIQUE,
    "phone_number"  varchar     NOT NULL UNIQUE,
    "password"      text        NOT NULL,
    "birth_date"    date        NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "categories"
(
    "id"          uuid        NOT NULL UNIQUE,
    "name"        varchar(150) NOT NULL UNIQUE,
    "description" text,
    "icon"        varchar(255),
    "created_at"  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "skills"
(
    "id"          uuid         NOT NULL UNIQUE,
    "name"        varchar(200) NOT NULL UNIQUE,
    "description" text,
    "created_at"  timestamptz  NOT NULL DEFAULT now(),
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "master_profiles"
(
    "user_id"         uuid         NOT NULL UNIQUE,
    "category_id"     uuid,
    "hourly_rate"     numeric(10,2) CHECK ("hourly_rate" >= 0),
    "experience_years" smallint     CHECK ("experience_years" >= 0),
    "rating"          numeric(3,2)  CHECK ("rating" >= 0 AND "rating" <= 5),
    "reviews_count"   integer       NOT NULL DEFAULT 0 CHECK ("reviews_count" >= 0),
    "about"           text,
    "location"        varchar(255),
    "is_active"       boolean       NOT NULL DEFAULT true,
    "created_at"      timestamptz   NOT NULL DEFAULT now(),
    "updated_at"      timestamptz   NOT NULL DEFAULT now(),
    PRIMARY KEY ("user_id"),
    CONSTRAINT "master_profiles_fk_user"     FOREIGN KEY ("user_id")    REFERENCES "users" ("id")      ON DELETE CASCADE,
    CONSTRAINT "master_profiles_fk_category" FOREIGN KEY ("category_id") REFERENCES "categories" ("id") ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "master_skills"
(
    "master_id"   uuid NOT NULL,
    "skill_id"    uuid NOT NULL,
    "proficiency" smallint CHECK ("proficiency" >= 0 AND "proficiency" <= 100),
    "added_at"    timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("master_id", "skill_id"),
    CONSTRAINT "master_skills_fk_master" FOREIGN KEY ("master_id") REFERENCES "master_profiles" ("user_id") ON DELETE CASCADE,
    CONSTRAINT "master_skills_fk_skill"  FOREIGN KEY ("skill_id")  REFERENCES "skills" ("id")              ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "portfolio_items"
(
    "id"          uuid        NOT NULL UNIQUE,
    "master_id"   uuid        NOT NULL,
    "title"       varchar(255) NOT NULL,
    "image_url"   text,
    "description" text,
    "created_at"  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("id"),
    CONSTRAINT "portfolio_fk_master" FOREIGN KEY ("master_id") REFERENCES "master_profiles" ("user_id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "orders"
(
    "id"           uuid         NOT NULL UNIQUE,
    "client_id"    uuid         NOT NULL,
    "category_id"  uuid,
    "title"        varchar(200) NOT NULL,
    "description"  varchar(1000) NOT NULL,
    "budget"       integer      NOT NULL CHECK ("budget" >= 0),
    "location"     varchar(150) NOT NULL,
    "status"       varchar(20)  NOT NULL DEFAULT 'новый',
    PRIMARY KEY ("id"),
    CONSTRAINT "orders_fk_client"   FOREIGN KEY ("client_id")   REFERENCES "users" ("id")       ON DELETE CASCADE,
    CONSTRAINT "orders_fk_category" FOREIGN KEY ("category_id") REFERENCES "categories" ("id")  ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "history"
(
    "id"          bigserial    PRIMARY KEY,
    "order_id"    uuid         NOT NULL,
    "status"      varchar(20)  NOT NULL,
    "changed_by"  uuid         NOT NULL,
    "date"        timestamptz  NOT NULL DEFAULT now(),
    CONSTRAINT "history_fk_order" FOREIGN KEY ("order_id")   REFERENCES "orders" ("id") ON DELETE CASCADE,
    CONSTRAINT "history_fk_user"  FOREIGN KEY ("changed_by") REFERENCES "users" ("id")  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "reviews"
(
    "id"                 uuid        NOT NULL UNIQUE,
    "order_id"           uuid        NOT NULL,
    "master_id"          uuid        NOT NULL,
    "client_id"          uuid        NOT NULL,
    "rating"             smallint    NOT NULL CHECK ("rating" BETWEEN 1 AND 5),
    "comment"            text,
    "status"             varchar(20) NOT NULL DEFAULT 'pending',
    "moderation_reason"  text,
    "moderated_by"       uuid,
    "moderated_at"       timestamptz,
    "created_at"         timestamptz NOT NULL DEFAULT now(),
    "updated_at"         timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("id"),
    CONSTRAINT "uq_reviews_order_client" UNIQUE ("order_id", "client_id"),
    CONSTRAINT "reviews_fk_order"        FOREIGN KEY ("order_id")    REFERENCES "orders" ("id") ON DELETE CASCADE,
    CONSTRAINT "reviews_fk_master"       FOREIGN KEY ("master_id")   REFERENCES "users" ("id")  ON DELETE CASCADE,
    CONSTRAINT "reviews_fk_client"       FOREIGN KEY ("client_id")   REFERENCES "users" ("id")  ON DELETE CASCADE,
    CONSTRAINT "reviews_fk_moderator"    FOREIGN KEY ("moderated_by") REFERENCES "users" ("id") ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "review_responses"
(
    "id"             uuid        NOT NULL UNIQUE,
    "review_id"      uuid        NOT NULL,
    "master_id"      uuid        NOT NULL,
    "response_text"  text        NOT NULL,
    "created_at"     timestamptz NOT NULL,
    "updated_at"     timestamptz NOT NULL,
    PRIMARY KEY ("id"),
    CONSTRAINT "uq_response_per_review" UNIQUE ("review_id"),
    CONSTRAINT "responses_fk_review" FOREIGN KEY ("review_id") REFERENCES "reviews" ("id") ON DELETE CASCADE,
    CONSTRAINT "responses_fk_master" FOREIGN KEY ("master_id") REFERENCES "users" ("id")   ON DELETE CASCADE
);
