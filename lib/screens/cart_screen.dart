// lib/screens/cart_screen.dart
// Halaman Keranjang: menampilkan daftar belanjaan, form alamat + validasi, checkout

import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../utils/theme.dart';
import 'report_screen.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk form pengiriman (Sub CPMK-4: validasi input)
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _promoCtrl = TextEditingController();

  String _promoMessage = '';
  double _discount = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _dateCtrl.dispose();
    _notesCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    setState(() {
      if (code == 'TEPPAN50') {
        _discount = 50000;
        _promoMessage = 'Promo berhasil! Diskon Rp. 50.000';
      } else if (code == 'HEMAT10') {
        _discount = widget.cart.totalPrice * 0.1;
        _promoMessage = 'Promo berhasil! Diskon 10%';
      } else {
        _discount = 0;
        _promoMessage = 'Kode promo tidak valid';
      }
    });
  }

  void _checkout() {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong!'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi informasi acara terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigasi ke halaman laporan dengan data keranjang (passing arguments)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportScreen(
          cart: widget.cart,
          customerName: _nameCtrl.text,
          address: _addressCtrl.text,
          eventDate: _dateCtrl.text,
          discount: _discount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Pesanan'),
        actions: [
          if (cart.itemCount > 0)
            TextButton(
              onPressed: () => setState(() => cart.clear()),
              child: const Text('Kosongkan', style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: SafeArea(
        child: cart.items.isEmpty
            ? _buildEmptyCart()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daftar item keranjang
                    _buildCartSection(cart),

                    // Form informasi acara + validasi (Sub CPMK-4)
                    _buildEventForm(),

                    // Kode promo
                    _buildPromoSection(),

                    // Ringkasan pesanan
                    _buildOrderSummary(cart),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: ElevatedButton(
                onPressed: _checkout,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(
                  'Checkout  •  ${_formatRupiah(cart.totalPrice - _discount)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🛒', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text('Keranjang masih kosong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tambahkan paket Teppanku favoritmu!', style: TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  Widget _buildCartSection(Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Paket Dipilih', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ...cart.items.map((item) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item.product.imagePath, width: 56, height: 56, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.restaurant, size: 40)),
              ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Sauce: ${item.selectedSauce}', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                      Text(_formatRupiah(item.subtotal), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // Kontrol quantity real-time (setState)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => cart.decrementQuantity(item.product.id)),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primary),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.remove, size: 16, color: AppTheme.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => cart.incrementQuantity(item.product.id)),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildEventForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Acara', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            // Nama pemesan
            _formField(
              controller: _nameCtrl,
              label: 'Nama Pemesan',
              icon: Icons.person_outline,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong';
                if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                // Validasi keamanan: tidak boleh ada karakter injeksi
                if (RegExp(r'[<>"\\/]').hasMatch(v)) return 'Nama mengandung karakter tidak valid';
                return null;
              },
            ),

            // Nomor HP
            _formField(
              controller: _phoneCtrl,
              label: 'Nomor WhatsApp',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nomor HP tidak boleh kosong';
                if (!RegExp(r'^[0-9]{10,13}$').hasMatch(v.trim())) return 'Masukkan nomor HP yang valid (10-13 digit)';
                return null;
              },
            ),

            // Alamat acara
            _formField(
              controller: _addressCtrl,
              label: 'Lokasi Acara',
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Alamat tidak boleh kosong';
                if (v.trim().length < 10) return 'Alamat terlalu singkat (minimal 10 karakter)';
                if (RegExp(r'[<>"\\]').hasMatch(v)) return 'Alamat mengandung karakter tidak valid';
                return null;
              },
            ),

            // Tanggal acara
            _formField(
              controller: _dateCtrl,
              label: 'Tanggal Acara (contoh: Sabtu, 24 Mei 2026)',
              icon: Icons.calendar_today_outlined,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Tanggal acara tidak boleh kosong';
                return null;
              },
            ),

            // Catatan opsional
            _formField(
              controller: _notesCtrl,
              label: 'Catatan Pesanan (Opsional)',
              icon: Icons.notes_outlined,
              maxLines: 3,
              required: false,
              hint: 'Contoh:\nTidak Pedas\nTanpa Bawang\nAcara Ulang Tahun (Surprise)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = true,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kode Promo (Opsional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoCtrl,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode promo anda',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyPromo,
                child: const Text('Terapkan'),
              ),
            ],
          ),
          if (_promoMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _promoMessage,
                style: TextStyle(
                  color: _discount > 0 ? AppTheme.success : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Cart cart) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...cart.items.map((item) => _summaryRow(
            '${item.product.name} x${item.quantity}',
            _formatRupiah(item.subtotal),
          )),
          if (_discount > 0) ...[
            const Divider(),
            _summaryRow('Subtotal', _formatRupiah(cart.totalPrice)),
            _summaryRow('Diskon Promo', '- ${_formatRupiah(_discount)}', isDiscount: true),
          ],
          const Divider(thickness: 1.5),
          _summaryRow(
            'TOTAL PEMBAYARAN',
            _formatRupiah(cart.totalPrice - _discount),
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 15 : 13,
            color: isTotal ? AppTheme.textDark : AppTheme.textGrey,
          )),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 13,
            color: isTotal ? AppTheme.primary : (isDiscount ? AppTheme.success : AppTheme.textDark),
          )),
        ],
      ),
    );
  }

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
