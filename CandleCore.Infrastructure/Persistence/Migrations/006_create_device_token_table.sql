CREATE TABLE IF NOT EXISTS users.device_token
(
    id             SERIAL        NOT NULL,
    user_id        INTEGER       NOT NULL REFERENCES users."user"(id) ON DELETE CASCADE,
    token          VARCHAR(512)  NOT NULL,
    created_at_utc TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at_utc TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_device_token PRIMARY KEY (id),
    CONSTRAINT uq_device_token_user_id UNIQUE (user_id)
);
