CREATE SCHEMA IF NOT EXISTS triggers;

CREATE TABLE IF NOT EXISTS triggers.trigger
(
    id             SERIAL          NOT NULL,
    user_id        INTEGER         NOT NULL REFERENCES users."user"(id) ON DELETE CASCADE,
    asset_id       INTEGER         NOT NULL REFERENCES assets.asset(id) ON DELETE CASCADE,
    asset_name     VARCHAR(100)    NOT NULL,
    condition      INTEGER         NOT NULL,
    target_price   DECIMAL(18, 8)  NOT NULL,
    is_active      BOOLEAN         NOT NULL DEFAULT TRUE,
    triggered_at   TIMESTAMPTZ,
    created_at_utc TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at_utc TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_trigger PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_trigger_user_id  ON triggers.trigger(user_id);
CREATE INDEX IF NOT EXISTS idx_trigger_asset_id ON triggers.trigger(asset_id);
CREATE INDEX IF NOT EXISTS idx_trigger_is_active ON triggers.trigger(is_active);
