-- Nora Libas single-owner and account-security migration.
-- Run once in Cloudflare D1 Console for the EXISTING nora-libas-db.
-- This preserves products, orders, passwords (hashes), and user accounts.

CREATE TABLE IF NOT EXISTS site_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

-- Keep only the earliest existing Owner as the single Super User.
UPDATE users
SET role='admin'
WHERE role='owner'
  AND id<>(SELECT MIN(id) FROM users WHERE role='owner');

-- Reserve the Super User username for the original Owner.
-- This statement only renames the existing earliest Owner when the name is free.
UPDATE users
SET username='superuser'
WHERE id=(SELECT MIN(id) FROM users WHERE role='owner')
  AND NOT EXISTS (SELECT 1 FROM users WHERE username='superuser');

-- Ensure only one row can ever have the owner role.
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_single_owner
ON users(role) WHERE role='owner';

-- Existing Owner gets one chance to set a new private password after migration.
INSERT OR IGNORE INTO site_settings(key,value)
VALUES ('owner_password_change_used','0');

-- Login brute-force protection. Only keyed hashes of the client IP are stored.
CREATE TABLE IF NOT EXISTS login_rate_limits (
  ip_hash TEXT PRIMARY KEY,
  window_start INTEGER NOT NULL,
  failures INTEGER NOT NULL DEFAULT 0,
  locked_until INTEGER NOT NULL DEFAULT 0
);
