-- Adds separate product video path storage. Run once on the existing Cloudflare D1 database.
ALTER TABLE products ADD COLUMN videos_json TEXT NOT NULL DEFAULT '[]';
