# Resto Mobile Application (`resto_app`)

The unified cross-platform mobile application for **Resto (ريستو)**, serving both **Customers** and **Delivery Drivers** with strict role-based route isolation.

---

## How to Run the App

```bash
cd packages/resto_app

# Run on an active simulator or connected device
flutter run

# Run specifically on Android
flutter run -d android

# Run specifically on iOS
flutter run -d ios

# Build release APK
flutter build apk --release
```

---

## Login Credentials & Role Testing

The app uses `GoRouter` with role guards to route users immediately upon login. There is no backdoor role-switcher button in the UI:

### 1. Customer Login (عميل):
* **Email:** `mohamed@resto.eg` (or any generic email such as `user@resto.eg`)
* **Password:** Any password (e.g. `123456`)
* **Redirect Route:** `/customer/home`
* **Features:**
  - Browse authentic Egyptian dishes (Kebab, Kofta, Okra Lamb Tagine, Mahshi, Pigeon).
  - Add items to cart with special instructions and customization options.
  - Choose between **Home Delivery** and **Branch Takeaway**.
  - Apply promotional coupons (e.g. `RESTO20` for 20% discount).
  - Live 5-stage order tracker (Received → Preparing in Kitchen → On the Way with Captain → Delivered).
  - Order rating and complaint submission.

---

### 2. Delivery Driver Login (كابتن التوصيل):
* **Email:** `driver@resto.eg`
* **Password:** Any password (e.g. `123456`)
* **Redirect Route:** Automatically redirected to `/driver/orders` (Driver Portal)
* **Features:**
  - Isolated portal showing only orders assigned to this driver.
  - Customer address and contact phone number.
  - Action buttons: "Pickup from Kitchen", "Start Journey", "Delivered & Cash Collected".
  - Earnings summary and customer feedback score.

---

## Brand Assets & Icons
- The app uses the **Culinary Heritage** design tokens from `resto_core`.
- Brand launcher icons are bundled inside `android/app/src/main/res/mipmap-*` folders.
- The Splash screen and Login screen feature the custom generated Resto logo.
- All icons use `lucide_icons_flutter` (no emojis in text or UI).
