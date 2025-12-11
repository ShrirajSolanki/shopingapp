import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import for the Banner Carousel
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  
  late Future<List<String>> _categoriesFuture;
  late Future<List<Product>> _featuredProductsFuture;
  
  static const Color primaryColor = Color(0xFFFF9800);

  // Placeholder list for the carousel banner images
  final List<String> bannerImages = [
    'https://via.placeholder.com/350x150/FFD700/000000?text=Super+Sale+Discount+1',
    'https://via.placeholder.com/350x150/FF8C00/FFFFFF?text=Mega+Deals+Up+to+60%',
    'https://via.placeholder.com/350x150/FF4500/FFFFFF?text=Limited+Time+Offer',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch categories and products
    _categoriesFuture = _apiService.getCategories();
    _featuredProductsFuture = _apiService.getAllProducts(); 
  }

  // Helper function for category icons
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.all_inclusive;
      case 'electronics':
        return Icons.watch_outlined; // Using watch for a standard e-commerce look
      case 'jewelery':
        return Icons.headphones_outlined; // Using headphones for a standard e-commerce look
      case "men's clothing":
        return Icons.dry_cleaning_outlined;
      case "women's clothing":
        return Icons.woman_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), 
        automaticallyImplyLeading: false,
        actions: [
          // Right-aligned icons for notification and cart
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
          children: [
            // 1. Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20),

            // 2. Banner Carousel Slider
            _buildBannerCarousel(),
            const SizedBox(height: 20),

            // 3. Horizontal Category Scroller
            _buildCategoryScroller(),
            const SizedBox(height: 20),

            // 4. "Special For You" Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Special For You',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProductListScreen(category: 'all'),
                      ));
                    },
                    child: const Text('See all', style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 5. Products Grid
            _buildProductsGrid(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: const Icon(Icons.tune, color: primaryColor), // Filter icon from image
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
  
  Widget _buildBannerCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9, // Show a fraction of the next banner
        aspectRatio: 2.0,
        autoPlayInterval: const Duration(seconds: 4),
      ),
      items: bannerImages.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.brown.shade700,
                image: DecorationImage(
                  image: NetworkImage(i),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Super Sale Discount',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Up to 50%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryScroller() {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink(); 
        }

        // Add 'All' category at the start of the list
        final categoriesWithAll = ['All', ...snapshot.data!];

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesWithAll.length,
            itemBuilder: (context, index) {
              final category = categoriesWithAll[index];
              return _buildCategoryIcon(context, category);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(BuildContext context, String category) {
    final IconData icon = _getCategoryIcon(category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          // 'All' should lead to a list of all products
          final targetCategory = category == 'All' ? 'all' : category;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductListScreen(category: targetCategory),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: category == 'All' ? primaryColor : primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: category == 'All' ? Colors.white : primaryColor, size: 30),
            ),
            const SizedBox(height: 5),
            Text(
              // Handle 'All' and truncate other names
              category == 'All' ? 'All' : category.split(' ').first, 
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return FutureBuilder<List<Product>>(
      future: _featuredProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No featured products found.'));
        }

        final displayProducts = snapshot.data!.take(6).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7, 
            ),
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              return _buildProductCard(context, product);
            },
          ),
        );
      },
    );
  }
  
  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  product.image,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Shopping cart icon at the bottom right
                const Icon(Icons.shopping_cart_outlined, color: primaryColor, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}