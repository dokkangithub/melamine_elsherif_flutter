import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/presentation/widgets/product/product_card.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/presentation/screens/cart/cart_screen.dart';
import 'package:melamine_elsherif/presentation/screens/wishlist/wishlist_screen.dart';
import 'package:melamine_elsherif/presentation/screens/profile/profile_screen.dart';
import 'package:melamine_elsherif/presentation/screens/product/product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Controllers to maintain state across rebuilds
  final PageController _pageController = PageController();
  
  // Keep track if data has been loaded for each tab to avoid redundant loading
  bool _homeDataLoaded = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          // Home Tab
          HomeContent(onDataLoaded: () => _homeDataLoaded = true),
          
          // Categories Tab
          const ProductListScreen(title: 'Categories'),
          
          // Cart Tab
          const CartScreen(),
          
          // Wishlist Tab
          const WishlistScreen(),
          
          // Profile Tab
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

// Separate HomeContent widget for the home tab
class HomeContent extends StatefulWidget {
  final VoidCallback onDataLoaded;
  
  const HomeContent({Key? key, required this.onDataLoaded}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    await Future.wait([
      productViewModel.getCategories(),
      productViewModel.getFeaturedProducts(),
      productViewModel.getNewArrivals(),
      productViewModel.getCollections(),
    ]);
    widget.onDataLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
              // Navigator.of(context).pushNamed('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart tab
              (context.findAncestorStateOfType<_HomeScreenState>())?._pageController.jumpToPage(2);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer<ProductViewModel>(
          builder: (context, productViewModel, _) {
            return ListView(
              children: [
                // Banner Section
                _buildBannerSection(),
                
                // Categories Section
                _buildCategoriesSection(productViewModel, context),
                
                // Featured Products Section
                _buildProductSection(
                  'New Arrivals',
                  productViewModel.newArrivals,
                  productViewModel.isLoadingNewArrivals,
                  productViewModel.newArrivalsError,
                  context,
                ),
                
                // Promotions Banner
                _buildPromotionBanner(),
                
                // Best Sellers Section
                _buildProductSection(
                  'Best Sellers',
                  productViewModel.featuredProducts,
                  productViewModel.isLoadingFeatured,
                  productViewModel.featuredError,
                  context,
                ),
                
                // Special Offers Section
                _buildPromotionCards(),
                
                // Today's Deals Section
                _buildProductSection(
                  'Today\'s Best Deals',
                  productViewModel.featuredProducts,
                  productViewModel.isLoadingFeatured,
                  productViewModel.featuredError,
                  context,
                  showSeeAll: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          // Banner image
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_banner.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          // Text overlay
          Positioned(
            left: 20,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transform Your Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Up to 30% off on selected premium appliances',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to products using parent's page controller
                    (context.findAncestorStateOfType<_HomeScreenState>())?._pageController.jumpToPage(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD5D5D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    minimumSize: const Size(100, 36),
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(ProductViewModel viewModel, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shop by Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to categories tab
                  (context.findAncestorStateOfType<_HomeScreenState>())?._pageController.jumpToPage(1);
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        if (viewModel.isLoadingCategories)
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (viewModel.categoriesError != null)
          SizedBox(
            height: 120,
            child: Center(
              child: Text('Error: ${viewModel.categoriesError}'),
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: viewModel.categories.length > 0 ? viewModel.categories.length : 4,
              itemBuilder: (context, index) {
                if (viewModel.categories.isEmpty) {
                  // Placeholder categories if none loaded
                  final placeholders = ['ROUND SET', 'SQUARE SET', 'OVAL SET', 'OCTA SET'];
                  final icons = [Icons.circle, Icons.square, Icons.crop_landscape, Icons.hexagon];
                  
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icons[index],
                            color: const Color(0xFFBD5D5D),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          placeholders[index],
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }
                
                final category = viewModel.categories[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to category products
                    // Navigator.of(context).pushNamed(
                    //   '/products',
                    //   arguments: {
                    //     'categoryId': category.id,
                    //     'title': category.name,
                    //   },
                    // );
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category,
                            color: const Color(0xFFBD5D5D),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductSection(
    String title,
    List<Product> products,
    bool isLoading,
    String? error,
    BuildContext context, {
    bool showSeeAll = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showSeeAll)
                TextButton(
                  onPressed: () {
                    // Navigate to all products
                    // Navigator.of(context).pushNamed('/products');
                  },
                  child: const Text('See All'),
                ),
            ],
          ),
        ),
        if (isLoading)
          const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (error != null)
          SizedBox(
            height: 220,
            child: Center(
              child: Text('Error: $error'),
            ),
          )
        else if (products.isEmpty)
          const SizedBox(
            height: 220,
            child: Center(
              child: Text('No products available'),
            ),
          )
        else
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 16),
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      // Navigate to product details
                      // Navigator.of(context).pushNamed(
                      //   '/product',
                      //   arguments: product.id,
                      // );
                    },
                    onAddToCart: () {
                      // Add to cart logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            onPressed: () {
                              // Navigate to cart
                              // Navigator.of(context).pushNamed('/cart');
                            },
                          ),
                        ),
                      );
                    },
                    onToggleFavorite: () {
                      // Toggle favorite logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to wishlist'),
                          action: SnackBarAction(
                            label: 'VIEW WISHLIST',
                            onPressed: () {
                              // Navigate to wishlist
                              // Navigator.of(context).pushNamed('/wishlist');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFBD5D5D),
      ),
      child: Stack(
        children: [
          // Background image or gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFBD5D5D),
                  const Color(0xFFBD5D5D).withAlpha(179),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Transform Your Home With Smart Appliances',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Discover our new collection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to collection
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFBD5D5D),
                  ),
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildPromotionCard(
              title: 'Summer Sale',
              subtitle: 'Up to 40% off',
              color: const Color(0xFFE57373),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPromotionCard(
              title: 'New Arrivals',
              subtitle: 'Shop now',
              color: const Color(0xFF81C784),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 