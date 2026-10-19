# Resto Ecosystem Interactive Demo Guide
## Step-by-Step: Experience the Complete Order Lifecycle as a Customer, Delivery Driver, and Operations Manager

---

### 🔑 Preconfigured Demo Accounts for Testing:

| Role | Email | Password | Access Method / Interface |
| :--- | :--- | :--- | :--- |
| **Customer** | `mohamed@resto.eg` | Any password (e.g. `123456`) | Customer Mobile App (`resto_app`) |
| **Delivery Driver** | `driver@resto.eg` | Any password (e.g. `123456`) | Driver Portal (`resto_app`) |
| **Operations Manager (Admin)** | `admin@resto.eg` | Any password + displayed 6-digit TOTP code | Web Operations Dashboard (`resto_admin_web`) |

---

### 🚀 Recommended Demo Journey (15 Sequential Steps):

#### 📱 Phase 1: Customer Experience (Customer Mobile App)
1. **Launch App & Sign In:** Log in with `mohamed@resto.eg` and explore the personalized welcome greeting and weekly promotional hero banner.
2. **Browse Menu & Categories:** Explore food categories (Grills, Clay Pots, Stuffed Delights, Sandwiches), noting calorie counts, prep times, and high-resolution visuals.
3. **Add an Item to Cart:** Tap (+ Add) on any dish, adjust quantity, and watch the floating cart counter update in real time.
4. **Apply Promo Discount:** Open the cart and enter promo code `RESTO20` in the coupon field to see an instant 20% discount applied to the subtotal.
5. **Confirm Order & Choose Cash on Delivery:** Select (Home Delivery), review detailed address information, add a special chef note, and choose Cash on Delivery (COD).
6. **Track Real-Time Order Status:** Observe the order placed with an auto-generated order number, activating Stage 1 on the 4-phase timeline: "Order Received & Confirmed".

#### 💻 Phase 2: Kitchen & Operations Management (Admin Web Dashboard)
7. **Access Admin Web Portal:** Open the web dashboard in your browser and sign in with `admin@resto.eg` using the 6-digit TOTP security code.
8. **Review New Order in the Kitchen Queue:** Navigate to (Orders Management) to see the customer's fresh order appear instantly with line items and contact details.
9. **Dispatch to Delivery Driver:** Select an available driver (e.g., Captain Hany Saeed) and click the status action to begin food preparation and dispatch.
*(Pro Tip: Check out the "Live Metrics" screen to monitor revenue curves and peak-hour heatmaps, and toggle menu availability on the "Menu" screen with a single click).*

#### 🛵 Phase 3: Delivery, Fulfillment & Customer Loyalty (Driver App & Customer Reorder)
10. **Open Driver App:** Sign in with `driver@resto.eg` to access the driver portal and view assigned active deliveries prioritized by delivery time.
11. **Initiate Delivery:** Tap the assigned order and press the start delivery button, instantly advancing the customer's order tracker to "Out for Delivery".
12. **Complete Delivery & Collect Cash:** Verify the cash amount due and tap "Delivered to Customer".
13. **Return to Customer App:** Check the customer order tracking screen and observe it transition automatically to "Delivered Successfully".
14. **Rate Experience & Leave Feedback:** Submit a star rating or visit the (Feedback & Complaints Center) to test direct communication with restaurant management.
15. **1-Click Quick Reorder:** Navigate to (Order History ➔ Past Orders) and tap "Reorder" to instantly refill the shopping cart with the exact same meal in one second.

---

### 💡 Key Architectural Highlights to Notice:
* **Real-Time Synchronization:** Built on reactive live sync; state changes across customer app, driver app, and admin dashboard reflect instantaneously without manual refreshing.
* **Transparent 4-Stage Tracking:** Clean, battery-efficient milestone tracking focused on prep and dispatch without battery-draining GPS overhead.
* **Complete Digital Ownership:** 100% direct customer data ownership with 0% third-party aggregator commissions.

### 🔗 Live System Links:
* **Mobile Apps (Customer & Driver Android APK / iOS):** [Drive Link](https://drive.google.com/drive/folders/1FY4WpzYWaPibN1hgsEeguVwnmO0GabH5?usp=sharing)
* **Customer Landing Page:** [resto-landing-zeta.vercel.app](https://resto-landing-zeta.vercel.app/)
* **Operations Admin Dashboard:** [resto-admin](https://resto-admin-f8712mdj5-mw205s-projects.vercel.app/)
