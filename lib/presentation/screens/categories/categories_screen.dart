import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _tabLabels = ['All'];
  List<ProductCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    productViewModel.getCategories().then((_) {
      setState(() {
        _categories = productViewModel.categories;
        _tabLabels = ['All', ..._categories.take(4).map((c) => c.name.toUpperCase())];
        _tabController = TabController(length: _tabLabels.length, vsync: this);
      });
    });
    _tabController = TabController(length: 1, vsync: this); // Temporary until categories load
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productViewModel, _) {
        final categories = productViewModel.categories;
        final isLoading = productViewModel.isLoadingCategories;
        final error = productViewModel.categoriesError;
        final mainCategories = categories.take(4).toList();
        final popularCategories = categories.take(4).toList();
        final allCategories = categories;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFBD5D5D)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Categories', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFFBD5D5D)),
                onPressed: () {},
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(child: Text(error))
                  : DefaultTabController(
                      length: _tabLabels.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TabBar
                          Container(
                            color: Colors.white,
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              indicatorColor: const Color(0xFFBD5D5D),
                              labelColor: const Color(0xFFBD5D5D),
                              unselectedLabelColor: Colors.black54,
                              tabs: _tabLabels
                                  .map((label) => Tab(
                                        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Category Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: mainCategories.length,
                              itemBuilder: (context, index) {
                                final cat = mainCategories[index];
                                final imageAsset = _getCategoryImage(cat.name);
                                final List<double> itemCounts = [2.5, 1.8, 3.2, 1.5];
                                final itemCount = index < itemCounts.length ? itemCounts[index] : 1.0;
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imageAsset,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.black.withOpacity(0.15),
                                        colorBlendMode: BlendMode.darken,
                                      ),
                                    ),
                                    Positioned(
                                      left: 16,
                                      bottom: 24,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.name.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${itemCount.toStringAsFixed(1)}k items',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Popular Categories
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Popular Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: popularCategories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final cat = popularCategories[index];
                                final icon = _getCategoryIcon(cat.name);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAF0F0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(icon, color: const Color(0xFFBD5D5D)),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat.name.length > 6 ? cat.name.substring(0, 6).toUpperCase() + '...' : cat.name.toUpperCase(),
                                        style: const TextStyle(
                                          color: Color(0xFFBD5D5D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Category List
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: allCategories.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final cat = allCategories[index];
                                final icon = _getCategoryIcon(cat.name);
                                return ListTile(
                                  leading: Icon(icon, color: const Color(0xFFBD5D5D)),
                                  title: Text(cat.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500)),
                                  trailing: const Icon(Icons.chevron_right, color: Colors.black38),
                                  onTap: () {
                                    // Navigate to category products
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  String _getCategoryImage(String name) {
    switch (name.toLowerCase()) {
      case 'round set':
        return 'assets/images/category_round.png';
      case 'square set':
        return 'assets/images/category_square.png';
      case 'oval set':
        return 'assets/images/category_oval.png';
      case 'octagon set':
        return 'assets/images/category_octagon.png';
      default:
        return 'assets/images/category_round.png';
    }
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'round set':
        return Icons.phone_iphone;
      case 'square set':
        return Icons.desktop_windows;
      case 'oval set':
        return Icons.person;
      case 'octagon set':
        return Icons.person;
      case 'dishes':
        return Icons.home;
      case 'cups':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
} 