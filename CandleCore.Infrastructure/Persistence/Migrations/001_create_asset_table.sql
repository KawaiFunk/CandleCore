CREATE SCHEMA IF NOT EXISTS assets;

CREATE TABLE IF NOT EXISTS assets.asset (
    id SERIAL PRIMARY KEY,
    external_id       VARCHAR(128) NOT NULL,
    symbol            VARCHAR(32)  NOT NULL,
    name              VARCHAR(128) NOT NULL,
    rank              INT          NOT NULL,
    price_usd         NUMERIC(30,10) NOT NULL,
    percent_change_24h NUMERIC(10,5) NOT NULL,
    percent_change_1h  NUMERIC(10,5) NOT NULL,
    percent_change_7d  NUMERIC(10,5) NOT NULL,
    price_btc         NUMERIC(30,10) NOT NULL,
    market_cap_usd    NUMERIC(30,2) NOT NULL,
    volume_24a        NUMERIC(30,2) NOT NULL,
    created_at_utc    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at_utc    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT asset_external_id_unique UNIQUE (external_id)
);