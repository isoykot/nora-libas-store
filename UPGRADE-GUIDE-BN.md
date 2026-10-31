# Nora Libas — Owner Security & Cart Upgrade (বাংলা)

এই আপডেটে Owner-only account management, login rate limiting, Homepage Editor, Marketing controls, Shopping Cart এবং multi-item Checkout যোগ হয়েছে।

## Deploy করার আগে D1 Migration

**আগে D1 database backup/export করে রাখুন।** তারপর Cloudflare Dashboard → Workers & Pages → D1 → `nora-libas-db` → Console খুলুন।

একই database-এ এই ক্রমে SQL চালান:

1. GitHub-এর `migrations/0005_single_owner_security.sql` ফাইলের সম্পূর্ণ SQL কপি করে D1 Console-এ Run করুন।
2. তারপর `migrations/0006_cart_order_items.sql` ফাইলের সম্পূর্ণ SQL কপি করে Run করুন।

এই migration-গুলো existing products, orders, user password hashes বা settings মুছে ফেলে না। 0005 পুরোনো Owner account-কে `superuser` username-এ নিয়ে আসে এবং অতিরিক্ত Owner role থাকলে প্রথম Owner ছাড়া বাকিদের Admin করে। Database-এ একটির বেশি Owner আটকাতে unique index তৈরি হয়।

## Owner Login

- Owner username: `superuser`
- Existing store হলে migration-এর আগে যে Owner password ছিল সেটি দিয়ে প্রথমবার login করুন।
- প্রথম login-এ Owner-কে নতুন কমপক্ষে ১২ অক্ষরের password সেট করতেই হবে। এই one-time password change-এর পর এই screen দিয়ে আর পরিবর্তন করা যাবে না।
- Fresh installation হলে প্রথম Owner Setup-এ username অবশ্যই `superuser` দিন এবং নিজের শক্তিশালী password বেছে নিন। Public/default password `superuser` ব্যবহার করবেন না।

Owner ছাড়া কেউ Admin account তৈরি করতে পারবে না। Admin কেবল Staff approval request পাঠাতে পারবে। Owner User ID ও Role দেখতে, username পরিবর্তন করতে, অন্য account-এর password reset করতে এবং non-owner account delete করতে পারবে।

**নিরাপত্তা:** কোনো account-এর আসল password Admin Panel-এ দেখানো হয় না; password salted hash আকারে সংরক্ষিত থাকে। Owner password-ও reveal করা যায় না—শুধু একবার পরিবর্তন করা যায়।

## Cloudflare Secrets

Worker-এর Variables and Secrets-এ `SESSION_SECRET` অন্তত ৩২ অক্ষরের random secret হিসেবে থাকতে হবে। প্রথম Owner Setup ব্যবহারের জন্য `SETUP_SECRET`-ও সেট থাকতে হবে। এগুলো কখনো public repository, source code বা chat-এ লিখবেন না।

## নতুন Storefront Flow

- Product details থেকে Add to Cart
- Cart থেকে quantity পরিবর্তন / remove
- একবারে customer details দিয়ে multi-item Checkout
- সব cart item-এর জন্য একটি Order ID
- Owner/Admin Order Confirm করলে প্রতিটি line item অনুযায়ী stock deduct
- Confirmed/Processing/Shipped order cancel করলে stock ফেরত

Marketing promotion bar ও social links website-এ দেখানো হয়। Coupon code এই আপডেটে শুধু promotion label হিসেবে দেখায়; checkout-এ discount হিসাব করে না।

## Deploy

D1 migration দুটো সফল হওয়ার পর feature branch-এর Pull Request merge করুন। Cloudflare Git integration `main` থেকে deploy করলে নতুন build প্রকাশ হবে। Deploy শেষে `/api/health`, `/admin.html`, homepage, product page ও `/cart.html` পরীক্ষা করুন।
