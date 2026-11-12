NORA LIBAS MOBILE FAST V2 + ROLE WORKFLOW + POS RECEIPT

This package is an update for the existing Nora Libas Cloudflare Workers + D1 project.
Keep your existing Cloudflare D1 database. Do NOT create a new database and do NOT delete old products/users.

FILES
- public/index.html: customer storefront
- public/admin.html: private Owner/Admin/Staff panel
- src/index.js: Worker API and access control
- migration-v2.sql: initial V2 database changes (orders/settings + image path update)
- migration-v3.sql: Owner/Admin/Staff approval workflow
- schema.sql: complete fresh-install schema reference only
- public/product-images/: compressed WebP product photos

ROLES
OWNER (full access):
- All settings and homepage/store details
- Add/edit/delete products and manage stock
- View, download/print receipts, and update all order statuses
- Create/manage Admin and Staff accounts
- Approve/reject Admin-created Staff ID requests

ADMIN (limited access):
- Add products
- Add stock quantity (cannot edit/delete products or reduce/change existing stock)
- View customer orders and accept new orders only
- Submit Staff ID creation requests to Owner
- A requested Staff ID cannot log in until Owner approves it
- Cannot access Owner settings, user list, full order status controls, or product edit/delete

STAFF (existing role retained):
- Inventory view and product image downloads only
- Cannot change products or stock

ORDERS & RECEIPTS
- Website orders are saved in the existing D1 orders table and reduce stock.
- Owner and Admin can view orders in the private panel.
- Owner/Admin can print a POS-style 80mm receipt or choose Save as PDF in the browser print dialog.
- Receipt includes order ID/date, customer name, phone, address, area, product, color, size, quantity, item price, delivery fee and total.
- WhatsApp order option remains available on the storefront (set the store WhatsApp number in Owner settings).

MIGRATION STEPS (CURRENT VERSION)
1. Back up the existing Cloudflare D1 database and GitHub repository.
2. For an existing V2 database, follow UPGRADE-GUIDE-BN.md and run migrations/0005_single_owner_security.sql, then migrations/0006_cart_order_items.sql, once each in the SAME existing D1 database.
3. Do not create a new database or run schema.sql on an existing store. schema.sql is only a fresh-install reference.
4. Deploy the main branch through the connected Cloudflare Worker.
5. Test /api/health, /admin.html, the storefront, product details, /cart.html, a test order, order confirmation, and receipt printing.

PRIVATE PANEL URL
https://YOUR-DOMAIN/admin.html
The storefront has no visible Admin link. The URL is unlisted, not a substitute for authentication; all private APIs still require a valid login and role permission.

SECRETS
Keep SESSION_SECRET and SETUP_SECRET as Cloudflare Worker secrets. Never put these values in GitHub or share them in chat. Do not run first-time setup again if an account already exists.

IMPORTANT NOTES
- Receipt PDF: click “Receipt PDF / Print”, then choose the printer or “Save as PDF” in the browser print dialog. The layout is optimized for 80mm thermal POS receipt paper.
- Confirm the shop WhatsApp number and delivery fees in Owner settings.
- Cloudflare Free usage is subject to plan limits; free hosting is not unlimited.
- Test a small dummy order and receipt before taking live customer orders.


UPDATE NOTES (V2.1)
- Owner: full access; only Owner can permanently delete products.
- Admin: can add and edit products, add stock, accept orders, and submit Staff ID requests. Admin cannot delete products or change stock through product editing.
- Staff: existing inventory-only permissions remain.
- Delivery Area is blank by default and required. Customer must select Dhaka (delivery fee configured, default BDT 120) or Outside Dhaka (default BDT 150). API also rejects orders without a valid area.
- Receipt has no tax line. Delivery charge and final total are printed.
- Product deletion removes the product row immediately from the D1 products table and therefore from storefront/admin product lists. Historical order snapshots remain in Orders for accounting and receipt reprints.


V2 UPDATE NOTES (Delivery / Product Delete permissions)
- Owner: full access, including permanent Product deletion.
- Admin: can add and edit Products, add stock, and accept new Orders; cannot delete Products.
- Staff: inventory view and image downloads only.
- Owner-only DELETE API removes the Product row from the existing D1 database; the storefront and inventory stop showing it immediately after refresh/reload. Historical Orders keep their saved product name/price/details for receipt and audit history.
- Delivery Area starts unselected and is required. Customer must choose Inside Dhaka or Outside Dhaka; only the selected fee is added (defaults: ৳120 / ৳150, editable in Owner settings). No tax is charged or shown on the receipt.
- Existing Orders are not deleted when a Product is deleted.


PRODUCT IMAGE & VIDEO FOLDERS (V4)
- Images: main/public/product-images/ ; Admin path: /product-images/filename.webp
- Videos: main/public/product-video/ ; Admin path: /product-video/filename.mp4
- Run migration-v4.sql ONCE on the existing D1 database before deploying this version.
- Videos are served as static files from the public folder. Keep MP4 files compressed for mobile speed.
