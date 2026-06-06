// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../data/product_data.dart';
import '../utils/theme.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final Cart cart;
  const DetailScreen({super.key, required this.product, required this.cart});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _selectedSauce = 'Teriyaki';
  int _pax = 20;
  final List<AddOn> _addOns = [];
  final List<String> _sauces = ['Teriyaki', 'Yakiniku', 'Miso', 'Kalbi'];

  @override
  void initState() {
    super.initState();
    _addOns.addAll(ProductService.getAddOns());
  }

  double get _totalPrice {
    double base = widget.product.price * (_pax / 20);
    double addOnTotal = _addOns.where((a) => a.isSelected).fold(0, (sum, a) => sum + a.price);
    return base + addOnTotal;
  }

  void _addToCart() {
    widget.cart.addItem(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} ditambahkan ke keranjang! 🛒'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Lihat Keranjang',
          textColor: Colors.white,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => CartScreen(cart: widget.cart))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(p.name, style: const TextStyle(fontSize: 16))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto produk besar di atas
              SizedBox(
                width: double.infinity,
                height: 240,
                child: Image.asset(
                  p.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.primary.withOpacity(0.1),
                    child: const Icon(Icons.restaurant, size: 80, color: AppTheme.primary),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Row(
                      children: [
                        if (p.isBestSeller) _badge('Best Seller', AppTheme.accent, Colors.black87),
                        if (p.isPremium) ...[const SizedBox(width: 4), _badge('Premium', AppTheme.primary, Colors.white)],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.textDark)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.star, color: AppTheme.accent, size: 16),
                      const SizedBox(width: 4),
                      Text('${p.rating} (${p.reviewCount} Review)', style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                    ]),
                    const SizedBox(height: 8),
                    Text(_formatRupiah(p.price),
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 22)),
                    const Text('/ 20 pax - Nett', style: TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                    const SizedBox(height: 12),
                    Text(p.description, style: const TextStyle(fontSize: 14, color: AppTheme.textGrey, height: 1.5)),
                    const SizedBox(height: 16),

                    // Isi paket
                    _sectionTitle('Isi Paket'),
                    ...p.includes.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
                      ]),
                    )),
                    const SizedBox(height: 16),

                    // Pilihan sauce
                    _sectionTitle('Pilihan Sauce'),
                    Wrap(
                      spacing: 8,
                      children: _sauces.map((sauce) {
                        final isSelected = _selectedSauce == sauce;
                        return ChoiceChip(
                          label: Text(sauce),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedSauce = sauce),
                          selectedColor: AppTheme.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.textDark, fontSize: 13),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Jumlah pax
                    _sectionTitle('Jumlah Pax'),
                    const Text('Minimal 20 pax', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                    const SizedBox(height: 8),
                    Row(children: [
                      IconButton(
                        onPressed: _pax > 20 ? () => setState(() => _pax -= 20) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppTheme.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.primary), borderRadius: BorderRadius.circular(8)),
                        child: Text('$_pax Pax', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _pax += 20),
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppTheme.primary,
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // Add-On
                    _sectionTitle('Add-On (Opsional)'),
                    ..._addOns.map((addon) => CheckboxListTile(
                      title: Text(addon.name, style: const TextStyle(fontSize: 13)),
                      subtitle: Text('+ ${_formatRupiah(addon.price)}', style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
                      value: addon.isSelected,
                      activeColor: AppTheme.primary,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (v) => setState(() => addon.isSelected = v ?? false),
                    )),
                    const SizedBox(height: 16),

                    // Total real-time
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Harga:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(_formatRupiah(_totalPrice),
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        child: const Text('Tambah ke Keranjang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
  );

  Widget _badge(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
    child: Text(label, style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.bold)),
  );

  String _formatRupiah(double price) {
    final str = price.toInt().toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result = '.' + result;
      result = str[i] + result;
      count++;
    }
    return 'Rp. ' + result;
  }
}
