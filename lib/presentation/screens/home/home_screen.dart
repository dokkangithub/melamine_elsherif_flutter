import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/presentation/widgets/product/product_card.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/presentation/screens/cart/cart_screen.dart';
import 'package:melamine_elsherif/presentation/screens/wishlist/wishlist_screen.dart';
import 'package:melamine_elsherif/presentation/screens/profile/profile_screen.dart';
import 'package:melamine_elsherif/presentation/screens/product/product_list_screen.dart';
import 'package:melamine_elsherif/core/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      productViewModel.getBestsellers(),
      productViewModel.getNewArrivals(),
      productViewModel.getCollections(),
      productViewModel.getTodaysBestDeals(),
    ]);
    widget.onDataLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 32),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                      onPressed: () {
                        (context.findAncestorStateOfType<_HomeScreenState>())?._pageController.jumpToPage(2);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {
                        (context.findAncestorStateOfType<_HomeScreenState>())?._pageController.jumpToPage(3);
                      },
                    ),
                  ],
                ),
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Section
                    //_buildBannerSection(),
                    const SizedBox(height: 16),
                    // Categories Section
                    _buildCategoriesSection(productViewModel, context),
                    const SizedBox(height: 16),
                    // Promo Card: Plates 50% OFF
                    _buildPromoCard(),
                    const SizedBox(height: 16),
                    // New Arrivals
                    _buildProductSection(
                      title: 'New Arrivals',
                      products: productViewModel.newArrivals,
                      isLoading: productViewModel.isLoadingNewArrivals,
                      error: productViewModel.newArrivalsError,
                      context: context,
                    ),
                    const SizedBox(height: 16),
                    // Promo Banner
                    _buildPromotionBanner(),
                    const SizedBox(height: 16),
                    // Best Sellers
                    _buildProductSection(
                      title: 'Best Sellers',
                      products: productViewModel.featuredProducts,
                      isLoading: productViewModel.isLoadingFeatured,
                      error: productViewModel.featuredError,
                      context: context,
                    ),
                    const SizedBox(height: 16),
                    // Promo Cards Row
                    _buildPromoCardsRow(),
                    const SizedBox(height: 16),
                    // Today's Best Deals
                    _buildProductSection(
                      title: "Today's Best Deals",
                      products: productViewModel.featuredProducts,
                      isLoading: productViewModel.isLoadingFeatured,
                      error: productViewModel.featuredError,
                      context: context,
                      showSeeAll: true,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBannerSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/banner.jpg',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 24,
          top: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transform Your Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBD5D5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Shop Now'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(ProductViewModel productViewModel, BuildContext context) {
    final categories = productViewModel.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.allProducts);
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFFBD5D5D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFFAF0F0),
                    child: Icon(Icons.category, color: const Color(0xFFBD5D5D), size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBD5D5D),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/plates_promo.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.darken,
          ),
        ),
      ),
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'PLATES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '50% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/plate_thumb.png', height: 60),
        ],
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF0F0),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/smart_appliances.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transform Your Home With Smart Appliances',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBD5D5D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCardsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFBD5D5D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Summer Sale', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Up to 40% off', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFB6B68F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('New Arrivals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Shop now', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<Product> products,
    required bool isLoading,
    required String? error,
    required BuildContext context,
    bool showSeeAll = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Navigator.pushNamed(context, Routes.allProducts);
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFFBD5D5D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(child: Text(error!))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    ),
        ),
      ],
    );
  }
} 