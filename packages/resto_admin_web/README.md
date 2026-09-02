# Resto Operations Dashboard (`resto_admin_web`)

A dedicated, web-first operations and restaurant management dashboard for **Resto (ريستو)**, based on the Stitch Operations Dashboard design and secured with **TOTP 2-Factor Authentication**.

---

## How to Run the Web Dashboard

```bash
cd packages/resto_admin_web

# Launch in Chrome
flutter run -d chrome
```

---

## Admin Authentication with TOTP (Two-Factor Auth)

To ensure maximum security for restaurant revenue, kitchen queues, and driver data with zero SMS/telecom costs ($0 cost), the admin portal uses an **RFC 6238 TOTP** verification flow:

### Step 1: Admin Credentials
* **Email:** `admin@resto.eg`
* **Password:** Any password (e.g. `123456`)
* *Note: Non-admin emails (like customer or driver accounts) will be rejected here with an unauthorized message.*

### Step 2: TOTP Code Verification
* The system prompts for a **6-digit security code**.
* **Live Code Helper (Demo):** A live counter on screen displays the exact current 6-digit code with a countdown timer (30s interval) and a one-click copy button for rapid testing.
* **Authenticator App Integration:** You can also add the secret key `JBSWY3DPEHPK3PXP` to **Google Authenticator**, **Microsoft Authenticator**, or **Authy** on your phone to generate valid real-time codes.
* Once verified, the dashboard unlocks and redirects to `/admin/dashboard`.

---

## Dashboard Features

1. **Operations Overview (لوحة المؤشرات):**
   - Real-time KPIs: Today's Revenue (in EGP), Total Orders, In-Kitchen Queue, and Active Drivers on the road.
   - Live incoming orders stream with instant status advance actions.
   - Popular Egyptian dishes spotlight with quick availability switches.

2. **Order Management (إدارة الطلبات):**
   - Complete data table of all orders with filters: `All`, `Active`, and `Completed`.
   - Actions to advance order stages: `Send to Kitchen` → `Handover to Driver` → `Mark as Delivered`.

3. **Menu & Inventory Management (قائمة المأكولات والمخزون):**
   - Grid view of all menu items, prices, and preparation times.
   - Live **In Stock / Out of Stock** toggle switches that immediately update the kitchen status and prevent customers from ordering unavailable dishes.

4. **Delivery Staff & Fleet (كباتن التوصيل):**
   - Live monitoring of captains, vehicle models, assigned orders, phone numbers, and performance ratings.

---

## Running Tests

```bash
cd packages/resto_admin_web
flutter test
```
