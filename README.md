complete Flutter application for Android and iOS with the following specifications and resources:

📦 Project Resources
Figma/Motiff Design: Pixel-perfect UI implementation required based on this shared design. Extract all visual components, layouts, and assets as accurately as possible.

API Collection: Use the provided Medusa Store API (https://docs.medusajs.com/api/store) to power the app’s functionality.

🧱 Architecture & Structure
Implement Clean Architecture using the MVVM (Model-View-ViewModel) pattern.

Strictly follow all SOLID principles.

Use Provider for state management.

Use Dependency Injection (e.g., via get_it or similar) for modularity and testability.

Project layers:

presentation/ → UI, screens, widgets

domain/ → entities, use cases, business logic

data/ → repositories, API, local data sources

🎨 UI/UX Implementation
Precisely replicate the UI/UX from the Figma design:

Use accurate colors, spacings, paddings, fonts, shadows, and borders.

Implement responsive layouts (support phones and tablets).

Create reusable components/widgets across the app.

Implement smooth page transitions and micro animations as seen in the design.

Implement accessibility best practices (semantic labels, tappable sizes, screen reader support).

Use a unified theme (AppTheme) for fonts, colors, dimensions, etc.

🖼️ Asset Management
Automatically detect and list all image/icon/font assets from Figma.

Export them into a /assets/ directory.

Create a static Dart class (AppAssets) to manage all asset references (e.g., AppAssets.logo, AppAssets.bannerHome1, etc.).

Generate a README.md file that lists:

All assets required to be added (with path & usage reference).

Exact folder structure under /assets/ for organization.

Notes for replacing temporary placeholders with final assets (if needed).

🔗 API Integration
Use Dio for API handling.

Structure the API using:

API client

Interceptors (auth, logging)

Models for all responses

Error handling with retry logic

Handle all requests/responses with proper error states.

Authenticate and handle token management if required.

Log all API traffic (Dev mode only).

🛒 Functional Features (Based on Figma)
Include and implement all the following screens/features exactly as designed:

General Screens
SplashScreen

OnBoarding

HomePage

ProductPage

CategoriesPage

CartPage

CheckoutPage

ThankyouPage

WishlistPage

SearchPage

ProfilePage

OrderDetails

SignIn

SignUp

AddressesPage

AddAddress

AllProducts

EditProfile

OrdersList


💾 Caching Strategy
Use ObjectBox to cache:

Products

Categories

Brands

Implement a cache-then-network pattern.

Invalidate cached data every 2 days.

Show cache loading indicators and fallback data if offline.

🚀 Performance Optimization
Use cached_network_image for product images

Use const constructors where possible

Use ListView.builder, SliverList, etc. for lazy lists

Efficient widget rebuilds (e.g., Selector, Consumer)

Memoization of expensive computations

🔐 Security Measures
Use flutter_secure_storage for secure token storage

Implement certificate pinning

Enable code obfuscation for release builds

Block screenshots for sensitive screens

Sanitize all inputs & handle exceptions gracefully

📱 Responsiveness
All layouts should work across various screen sizes (phones and tablets).

Use LayoutBuilder, MediaQuery, and breakpoints for adaptability.

🧪 Testing & Stability
Add unit tests for domain logic

Add widget tests for UI

Add integration tests for navigation and flow

Proper error handling with graceful fallbacks

📊 Additional Features
Deep linking

App lifecycle awareness

Firebase (for analytics or push notifications if required)

Offline-first support where relevant

Full localization (e.g., Arabic & English with RTL support)

✅ Output Requirements
Complete Flutter codebase in lib/ with best practices.

All assets in /assets/ with structured folders.

Static asset reference class AppAssets.

README with setup instructions and full asset list.

Clear documentation and comments throughout the code.

Folder structure must match Clean Architecture with MVVM.

