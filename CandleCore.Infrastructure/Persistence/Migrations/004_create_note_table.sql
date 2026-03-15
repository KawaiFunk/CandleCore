CREATE SCHEMA IF NOT EXISTS notes;

CREATE TABLE IF NOT EXISTS notes.note
(
    id             SERIAL      NOT NULL,
    user_id        INTEGER     NOT NULL REFERENCES users."user"(id) ON DELETE CASCADE,
    asset_id       INTEGER              REFERENCES assets.asset(id) ON DELETE SET NULL,
    title          VARCHAR(200) NOT NULL,
    body           VARCHAR(4000) NOT NULL,
    created_at_utc TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at_utc TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_note PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_note_user_id  ON notes.note(user_id);
CREATE INDEX IF NOT EXISTS idx_note_asset_id ON notes.note(asset_id);
