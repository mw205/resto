# Resto Core Package (`resto_core`)

The shared domain, design system, mock API, and utility layer used across all applications in the **Resto (ريستو)** ecosystem.

---

## Package Architecture

1. **`models/` (Data Models):**
   - `UserModel`: User entities with defined roles (`UserRole.customer`, `UserRole.driver`, `UserRole.admin`).
   - `OrderModel`: Order lifecycle, statuses (`received`, `preparing`, `onTheWay`, `delivered`, `cancelled`), items, delivery fees, and addresses.
   - `ProductModel` & `CategoryModel`: Egyptian gastronomy items (grilled meats, tagines, stuffed pigeon, desserts) and categories.
   - `CouponModel`: Discount promotions (e.g. `RESTO20` for 20% off).
   - `ComplaintModel` & `FeedbackModel`: Customer ratings and complaints.

2. **`constants/` (Design Tokens):**
   - `AppColors`: Culinary Heritage palette featuring Deep Charcoal (`#262626`), Terracotta (`#D95D39`), Warm Cream (`#FBF9F8`), and semantic feedback colors.
   - `AppDimensions`: Standardized corner radii, paddings, and layout metrics.
   - `AppAssets`: Asset paths for images and translations.

3. **`network/` (Mock API):**
   - `MockRestoApi`: In-memory single source of truth simulating order placement, status advancement, stock availability toggles, and user authentication.

4. **`utils/` (TOTP 2FA Engine):**
   - `TotpAuthenticator`: RFC 6238 compliant Time-based One-Time Password generator and validator. Compatible with Google Authenticator, Microsoft Authenticator, and Authy ($0 SMS/email costs).

5. **`widgets/` (Reusable UI Components):**
   - `RestoLogoWidget`: Official Resto brand mark and logotype.
   - `RestoButton`: Accessible buttons supporting loading states and Lucide Icons.
   - `StatusChip`: Multi-state status chips for order tracking.

---

## Running Unit Tests

```bash
cd packages/resto_core
flutter test
```
