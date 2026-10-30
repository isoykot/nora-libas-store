-- Run this once in the EXISTING Nora Libas D1 database.
CREATE TABLE IF NOT EXISTS orders (id TEXT PRIMARY KEY, product_id TEXT, product_name TEXT NOT NULL, color TEXT NOT NULL DEFAULT '', size TEXT NOT NULL DEFAULT '', quantity INTEGER NOT NULL, unit_price INTEGER NOT NULL, delivery_fee INTEGER NOT NULL, total INTEGER NOT NULL, customer_name TEXT NOT NULL, customer_phone TEXT NOT NULL, delivery_area TEXT NOT NULL, address TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'new', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS site_settings (key TEXT PRIMARY KEY, value TEXT NOT NULL DEFAULT '');
INSERT OR IGNORE INTO site_settings(key,value) VALUES ('store_name','Nora Libas'),('tagline','YOUR STYLE, OUR PASSION'),('announcement','সারা বাংলাদেশে Cash on Delivery'),('hero_title','Elegance in Every Thread'),('hero_text','আপনার পছন্দের পোশাক, এখন আরও সহজে অর্ডার করুন।'),('whatsapp',''),('dhaka_delivery','120'),('outside_delivery','150');

-- Point existing product image records to the new compressed WebP files.
UPDATE products SET images_json = REPLACE(images_json, '.png', '.webp') WHERE images_json LIKE '%.png%';

-- Role approval workflow: Admin staff creation requests require Owner approval.
CREATE TABLE IF NOT EXISTS staff_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  requested_by TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- Promote the initial account created by the old setup flow to Owner.
UPDATE users SET role='owner' WHERE role='admin' AND id=(SELECT MIN(id) FROM users);
