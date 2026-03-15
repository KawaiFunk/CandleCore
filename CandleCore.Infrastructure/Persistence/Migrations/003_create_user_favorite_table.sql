CREATE SCHEMA IF NOT EXISTS favorites;

CREATE TABLE IF NOT EXISTS favorites.user_favorite (
    user_id  INTEGER NOT NULL REFERENCES users."user"(id)  ON DELETE CASCADE,
    asset_id INTEGER NOT NULL REFERENCES assets.asset(id) ON DELETE CASCADE,
    CONSTRAINT pk_user_favorite PRIMARY KEY (user_id, asset_id)
);

CREATE INDEX IF NOT EXISTS idx_user_favorite_user_id ON favorites.user_favorite(user_id);
