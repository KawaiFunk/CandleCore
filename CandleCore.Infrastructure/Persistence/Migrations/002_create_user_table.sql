CREATE SCHEMA IF NOT EXISTS users;

CREATE TABLE IF NOT EXISTS users."user" (
    id             SERIAL PRIMARY KEY,
    username       VARCHAR(100) NOT NULL,
    email          VARCHAR(255) NOT NULL,
    password       VARCHAR(512) NOT NULL,
    created_at_utc TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at_utc TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT user_username_unique UNIQUE (username),
    CONSTRAINT user_email_unique    UNIQUE (email)
);
