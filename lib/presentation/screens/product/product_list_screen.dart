import 'package:flutter/material.dart';
import 'package:melamine_elsherif/data/datasources/local/app_preferences.dart';
import 'package:melamine_elsherif/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/presentation/widgets/product/product_card.dart';

import '../../../injection_container.dart';


class ProductListScreen extends StatefulWidget {
  final String? title;
  final String? categoryId;
  final String? collectionId;
  final String? searchQuery;
  final ProductRepository? productRepository;

  const ProductListScreen({
    Key? key,
    this.title,
    this.categoryId,
    this.collectionId,
    this.searchQuery,
    this.productRepository,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  
  // Pagination parameters
  int _offset = 0;
  final int _limit = 12;
  bool _hasMoreProducts = true;

  late AppPreferences _appPreferences;

  @override
  void initState() {
    super.initState();
    _appPreferences = serviceLocator<AppPreferences>();
    
    // Initialize view model with repository
    final repository = widget.productRepository ?? sl<ProductRepository>();
    _viewModel = ProductViewModel(productRepository: repository);
    
    // Initialize scroll controller for pagination
    _scrollController.addListener(_scrollListener);
    
    // Load initial products
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener for lazy loading more products
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  // Initial load of products
  Future<void> _loadProducts() async {
    if (widget.categoryId != null) {
      await _viewModel.getProductsByCategory(widget.categoryId!);
    } else if (widget.collectionId != null) {
      await _viewModel.getProductsByCollection(widget.collectionId!);
    } else if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      await _viewModel.searchProducts(widget.searchQuery!);
    } else {
      await _viewModel.getProducts(
        offset: _offset,
        limit: _limit,
      );
    }
  }

  // Load more products for pagination
  Future<void> _loadMoreProducts() async {
    if (!_isLoadingMore && _hasMoreProducts && !_viewModel.isLoadingProducts) {
      setState(() {
        _isLoadingMore = true;
      });

      _offset += _limit;
      
      if (widget.categoryId != null) {
        await _viewModel.getProductsByCategory(widget.categoryId!);
      } else if (widget.collectionId != null) {
        await _viewModel.getProductsByCollection(widget.collectionId!);
      } else if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        await _viewModel.searchProducts(widget.searchQuery!);
      } else {
        await _viewModel.getProducts(
          offset: _offset,
          limit: _limit,
        );
      }

      // Check if we've reached the end of the products
      if (_viewModel.products.length < _offset + _limit) {
        _hasMoreProducts = false;
      }

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search screen
              // Navigator.of(context).pushNamed('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoadingProducts && viewModel.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.productsError != null && viewModel.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${viewModel.productsError}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadProducts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.products.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _offset = 0;
                _hasMoreProducts = true;
                await _loadProducts();
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: viewModel.products.length + (_hasMoreProducts ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == viewModel.products.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final product = viewModel.products[index];
                  return _buildProductCard(product);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return ProductCard(
      product: product,
      onTap: () {
        // Navigate to product details screen
        // Navigator.of(context).pushNamed(
        //   '/product/details',
        //   arguments: product.id,
        // );
      },
      onAddToCart: () {
        // Add to cart logic
        _showAddToCartSnackBar(context, product);
      },
      onToggleFavorite: () {
        // Toggle favorite logic
        _showToggleFavoriteSnackBar(context, product);
      },
    );
  }

  void _showAddToCartSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            // Navigate to cart screen
            // Navigator.of(context).pushNamed('/cart');
          },
        ),
      ),
    );
  }

  void _showToggleFavoriteSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to wishlist'),
        action: SnackBarAction(
          label: 'VIEW WISHLIST',
          onPressed: () {
            // Navigate to wishlist screen
            // Navigator.of(context).pushNamed('/wishlist');
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by Price: Low to High'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement sorting logic
                  _viewModel.getProducts(
                    sortBy: 'price',
                    sortDesc: false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('Sort by Price: High to Low'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement sorting logic
                  _viewModel.getProducts(
                    sortBy: 'price',
                    sortDesc: true,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Sort by Newest'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement sorting logic
                  _viewModel.getProducts(
                    sortBy: 'created_at',
                    sortDesc: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 