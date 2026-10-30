-- Run this once in the EXISTING Nora Libas Cloudflare D1 database AFTER migration-v2.sql.
-- It preserves products, orders, and current staff data.
CREATE TABLE IF NOT EXISTS staff_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  requested_by TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- The original setup flow created the first account as admin; promote that first account to Owner.
UPDATE users SET role='owner' WHERE id=(SELECT MIN(id) FROM users) AND role='admin';
