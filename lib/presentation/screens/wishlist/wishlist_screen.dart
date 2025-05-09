import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/wishlist_view_model.dart';
import 'package:melamine_elsherif/presentation/viewmodels/cart/cart_view_model.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<String> _filters = [
    'All', 'Clothing', 'Electronics', 'Books', 'Home'
  ];
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    await Provider.of<WishlistViewModel>(context, listen: false).getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFBD5D5D)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('My Wishlist', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFFBD5D5D)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Color(0xFFBD5D5D)),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<WishlistViewModel>(
        builder: (context, wishlistViewModel, _) {
          if (wishlistViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wishlistViewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${wishlistViewModel.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWishlist,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final wishlistItems = wishlistViewModel.wishlistItems;

          if (wishlistItems.isEmpty) {
            return _buildEmptyWishlist();
          }

          // Filter logic (for demo, just show all)
          final filteredItems = wishlistItems;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter chips
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = _selectedFilter == index;
                    return ChoiceChip(
                      label: Text(_filters[index], style: TextStyle(fontWeight: FontWeight.w500, color: selected ? Colors.white : const Color(0xFFBD5D5D))),
                      selected: selected,
                      selectedColor: const Color(0xFFBD5D5D),
                      backgroundColor: const Color(0xFFF5EAEA),
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildWishlistItem(filteredItems[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_wishlist.png',
            height: 150,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save items you like by clicking the heart icon',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Explore Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(Product product) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final wishlistViewModel = Provider.of<WishlistViewModel>(context, listen: false);
    final price = product.variants.isNotEmpty && product.variants.first.prices.isNotEmpty
        ? product.variants.first.prices.first.amount
        : 0.0;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.thumbnail ?? 'https://placehold.co/300x300',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ' 24${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFBD5D5D)),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFBD5D5D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                        onPressed: () {
                          // Add to cart
                          cartViewModel.addItem(product.variants.first.id);
                        },
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Heart icon
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                wishlistViewModel.removeFromWishlist(product.id!);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite, color: Color(0xFFBD5D5D), size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 