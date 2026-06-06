// lib/screens/catalog_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../data/product_data.dart';
import '../utils/theme.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> _allProducts = [];
  List<Product> _filtered = [];
  bool _isLoading = true;
  String _selectedCategory = 'Semua';
  final Cart _cart = Cart();
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _categories = ['Semua', 'Chicken', 'Beef', 'Seafood', 'Vegetable'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await ProductService.fetchProducts();
    setState(() {
      _allProducts = products;
      _filtered = products;
      _isLoading = false;
    });
  }

  void _filterCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      _applyFilter();
    });
  }

  void _applyFilter() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _allProducts.where((p) {
        final matchCat = _selectedCategory == 'Semua' || p.category == _selectedCategory;
        final matchSearch = p.name.toLowerCase().contains(query);
        return matchCat && matchSearch;
      }).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() => _cart.addItem(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} berhasil ditambahkan! 🛒'),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Teppanku di AppBar
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 36, height: 36, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(width: 36, height: 36),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('TEPPANKU', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
                Text('Home Service Teppanyaki', style: TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(cart: _cart)));
                  setState(() {});
                },
              ),
              if (_cart.itemCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                    child: Text('${_cart.itemCount}',
                        style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPromoBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  hintText: 'Cari paket atau layanan...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                ),
              ),
            ),
            _buildCategoryFilter(),
            Expanded(
              child: _isLoading
                  ? const Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 16),
                        Text('Memuat katalog paket...', style: TextStyle(color: AppTheme.textGrey)),
                      ],
                    ))
                  : RefreshIndicator(
                      onRefresh: _loadProducts,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _filtered.length,
                        itemBuilder: (ctx, i) => ProductCard(
                          product: _filtered[i],
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DetailScreen(product: _filtered[i], cart: _cart),
                            ));
                            setState(() {});
                          },
                          onAddToCart: () => _addToCart(_filtered[i]),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Paket'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library_outlined), label: 'Galeri'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
        onTap: (i) {
          if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(cart: _cart)));
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Foto makanan di background kanan
            Positioned(
              right: -10, bottom: -10,
              child: Opacity(
                opacity: 0.35,
                child: Image.asset('assets/images/tenderloin.png',
                    width: 170, height: 170, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox()),
              ),
            ),
            // Konten teks
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('P R O M O  S P E S I A L',
                      style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  const Text('Live Cooking\nDi Rumahmu!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  const Text('Mulai Rp. 1.500.000 / 20 pax - Nett',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Pesan Sekarang',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => _filterCategory(cat),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
              ),
              child: Text(cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  )),
            ),
          );
        },
      ),
    );
  }
}
