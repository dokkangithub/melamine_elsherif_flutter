# Assets Directory Structure

This directory contains all the assets required for the Melamine Elsherif app. Below is the structure and list of assets needed.

## Directory Structure

```
assets/
├── icons/        # SVG icons used throughout the app
├── images/       # PNG/JPG images used throughout the app 
└── fonts/        # Font files used in the app
```

## Required Assets

### Icons (SVG)

Place all SVG icons in the `assets/icons/` directory:

- `ic_home.svg` - Home icon for bottom navigation
- `ic_categories.svg` - Categories icon for bottom navigation
- `ic_cart.svg` - Cart icon for bottom navigation
- `ic_wishlist.svg` - Wishlist icon for bottom navigation
- `ic_profile.svg` - Profile icon for bottom navigation
- `ic_search.svg` - Search icon
- `ic_filter.svg` - Filter icon
- `ic_edit.svg` - Edit icon
- `ic_delete.svg` - Delete icon
- `ic_add.svg` - Add icon (plus sign)
- `ic_minus.svg` - Minus icon
- `ic_arrow_back.svg` - Back arrow
- `ic_arrow_forward.svg` - Forward arrow
- `ic_close.svg` - Close icon (X)
- `ic_check.svg` - Check mark icon
- `ic_secure.svg` - Secure payment icon
- `ic_shipping.svg` - Shipping icon
- `ic_return.svg` - Return policy icon
- `ic_payment.svg` - Payment icon
- `order_confirmed.svg` - Order confirmed status icon
- `order_shipped.svg` - Order shipped status icon
- `order_delivered.svg` - Order delivered status icon
- `google_logo.svg` - Google logo for sign-in
- `apple_logo.svg` - Apple logo for sign-in
- `facebook_logo.svg` - Facebook logo for sign-in

### Images (PNG/JPG)

Place all images in the `assets/images/` directory:

- `logo.png` - App logo
- `logo_with_text.png` - App logo with text
- `onboarding_1.png` - First onboarding screen image
- `onboarding_2.png` - Second onboarding screen image
- `onboarding_3.png` - Third onboarding screen image
- `home_banner_1.png` - First banner on home screen
- `home_banner_2.png` - Second banner on home screen
- `category_round.png` - Round category image
- `category_square.png` - Square category image
- `category_oval.png` - Oval category image
- `category_octagon.png` - Octagon category image
- `round_set.png` - Round dinnerware set image
- `square_set.png` - Square dinnerware set image
- `oval_set.png` - Oval dinnerware set image
- `octagon_set.png` - Octagon dinnerware set image
- `turkish_dinnerware_1.png` - Turkish dinnerware image 1
- `turkish_dinnerware_2.png` - Turkish dinnerware image 2
- `turkish_dinnerware_3.png` - Turkish dinnerware image 3
- `product_placeholder.png` - Placeholder for product images
- `user_placeholder.png` - Placeholder for user profile image
- `empty_cart.png` - Empty cart illustration
- `empty_wishlist.png` - Empty wishlist illustration
- `no_orders.png` - No orders illustration
- `no_results.png` - No search results illustration
- `sale.png` - Sale banner/image

### Fonts

Place all font files in the `assets/fonts/` directory:

- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`
- `Poppins-Light.ttf`

## Usage

All assets are referenced through the `AppAssets` class located at `lib/core/constants/app_assets.dart`. Always use these constants instead of hardcoding asset paths in your code.

Example usage:
```dart
Image.asset(AppAssets.logo)
```

## Placeholders

Until the final assets are available, use placeholder images for development. Replace them with the final assets when they become available.

## Adding New Assets

When adding new assets:
1. Place them in the appropriate directory
2. Add constant references in the `AppAssets` class
3. Update this README file if needed
4. Update the pubspec.yaml file to include the new assets 