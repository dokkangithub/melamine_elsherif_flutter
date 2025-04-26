complete Flutter application for Android and iOS with the following specifications and resources:

📦 Project Resources
Figma/Motiff Design: Pixel-perfect UI implementation required based on this shared design. Extract all visual components, layouts, and assets as accurately as possible.

API Collection: Use the provided Medusa Store API (https://docs.medusajs.com/api/store) to power the app's functionality.

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

## UI Implementation with Data Layer Integration

### Presentation Layer Structure

The presentation layer follows MVVM pattern and is organized as follows:

```
lib/presentation/
├── screens/           # Full screens (pages) of the application
│   ├── auth/          # Authentication screens (login, signup)
│   ├── home/          # Home screen and related screens
│   ├── product/       # Product screens (details, listing)
│   ├── cart/          # Shopping cart screens
│   ├── checkout/      # Checkout flow screens
│   ├── profile/       # User profile screens
│   ├── search/        # Search related screens
│   └── order/         # Order tracking and history
├── viewmodels/        # ViewModels that connect UI to domain layer
│   ├── auth/          # Authentication viewmodels
│   ├── product/       # Product-related viewmodels
│   ├── cart/          # Cart-related viewmodels
│   └── ...            # Other viewmodels
├── widgets/           # Reusable UI components
│   ├── common/        # Common widgets used across the app
│   ├── product/       # Product-specific widgets
│   ├── cart/          # Cart-specific widgets
│   └── ...            # Other widgets
└── utils/             # UI-related utilities
    ├── theme/         # Theme data, colors, text styles
    ├── routes/        # App routes
    └── validators/    # Form input validators
```

### Connecting ViewModels to Domain Layer

ViewModels serve as the bridge between UI and domain layer. They:
1. Inject use cases from the domain layer
2. Transform domain entities to UI-friendly models
3. Handle UI state management (loading, error, success)
4. Execute business logic by calling use cases

Example ViewModel:

```dart
class ProductViewModel extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;
  
  ProductViewModel({
    required GetProductsUseCase getProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductByIdUseCase = getProductByIdUseCase;
  
  List<ProductUIModel> _products = [];
  bool _isLoading = false;
  String? _error;
  
  List<ProductUIModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> getProducts({
    int? offset,
    int? limit,
    String? search,
    List<String>? categoryIds,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getProductsUseCase(
      offset: offset,
      limit: limit,
      search: search,
      categoryIds: categoryIds,
    );
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (products) {
        _products = products.map((p) => ProductUIModel.fromEntity(p)).toList();
        _isLoading = false;
      }
    );
    
    notifyListeners();
  }
  
  // Other methods for product operations...
}
```

### UI Models

Create UI-specific models that transform domain entities to UI-friendly objects:

```dart
class ProductUIModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final double price;
  final String currencyCode;
  
  ProductUIModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    required this.price,
    required this.currencyCode,
  });
  
  factory ProductUIModel.fromEntity(Product product) {
    return ProductUIModel(
      id: product.id,
      title: product.title ?? '',
      description: product.description,
      thumbnail: product.thumbnail,
      price: product.variants?.first.prices?.first.amount ?? 0,
      currencyCode: product.variants?.first.prices?.first.currencyCode ?? 'USD',
    );
  }
}
```

### Screen Implementation Strategy

For each screen in the app:

1. Create a corresponding ViewModel
2. Inject required use cases into the ViewModel
3. Create UI components that consume the ViewModel
4. Handle loading, error, and success states

Example screen implementation:

```dart
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = sl<ProductViewModel>();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    await _viewModel.getProducts(limit: 10);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${viewModel.error}'),
                    ElevatedButton(
                      onPressed: _loadProducts,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                return ProductCard(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}
```

### Key UI Components to Implement

Based on the designs, implement these key reusable widgets:

1. **ProductCard** - Used in product listings, search results
2. **CategoryCard** - For category browsing 
3. **CartItem** - For displaying items in cart
4. **AddressCard** - For managing and selecting addresses
5. **OrderSummary** - For checkout and order details
6. **PasswordField** - For authentication screens
7. **QuantitySelector** - For product and cart screens
8. **RatingDisplay** - For displaying product ratings
9. **PriceDisplay** - For consistent price formatting
10. **ErrorView** - For error handling
11. **LoadingView** - For loading states
12. **EmptyStateView** - For empty lists

### Implementation Priority

Implement screens in this order to build the app incrementally:

1. **Authentication (Login/Signup)** - Entry point for users
2. **Home Screen** - Main navigation hub
3. **Product Listing & Detail** - Core shopping experience
4. **Search Functionality** - Product discovery
5. **Cart & Wishlist** - Shopping management
6. **Checkout Flow** - Purchase completion
7. **Profile & Orders** - Account management

### Theme Implementation

Create a centralized AppTheme class to ensure UI consistency:

```dart
class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xBD5D5D);
  static const Color secondaryColor = Color(0xF5F5F5);
  static const Color accentColor = Color(0xE57373);
  static const Color textColor = Color(0x333333);
  static const Color errorColor = Color(0xD32F2F);
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  // More text styles...
  
  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // More button styles...
  
  // Input Decoration
  static const InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: errorColor),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
  
  // Get ThemeData for MaterialApp
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        // More text themes...
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      // More theme configurations...
    );
  }
}
```

