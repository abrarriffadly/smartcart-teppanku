// lib/screens/report_screen.dart
// Halaman Ringkasan/Report: narasi data visual, statistik belanja (Sub CPMK-1 & 2)

import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../utils/theme.dart';

class ReportScreen extends StatelessWidget {
  final Cart cart;
  final String customerName;
  final String address;
  final String eventDate;
  final double discount;

  const ReportScreen({
    super.key,
    required this.cart,
    required this.customerName,
    required this.address,
    required this.eventDate,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final totalPayment = cart.totalPrice - discount;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Pesanan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header sukses
              _buildSuccessHeader(),
              const SizedBox(height: 16),

              // Analisis statistik belanja
              _buildStatisticsCard(),
              const SizedBox(height: 16),

              // Narasi laporan
              _buildNarrativeCard(),
              const SizedBox(height: 16),

              // Info acara
              _buildEventInfoCard(),
              const SizedBox(height: 16),

              // Detail pesanan
              _buildOrderDetailCard(totalPayment),
              const SizedBox(height: 24),

              // Tombol aksi
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('✅', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pesanan Berhasil!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text('Halo, $customerName!', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const Text('Pesanan Teppanku Anda sudah kami terima.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Statistik analisis belanja (Sub CPMK-1: OOP + perhitungan)
  Widget _buildStatisticsCard() {
    final mostExp = cart.mostExpensiveItem;
    final cheapest = cart.cheapestItem;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.bar_chart, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('Analisis Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            // Grid statistik 2x2
            LayoutBuilder(
              builder: (ctx, constraints) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _statBox('Total Belanja', _formatRupiah(cart.totalPrice), '💰', AppTheme.primary, constraints),
                    _statBox('Rata-rata Harga', _formatRupiah(cart.averagePrice), '📊', Colors.blue, constraints),
                    _statBox('Paket Termahal', mostExp?.product.name ?? '-', '⬆️', Colors.orange, constraints),
                    _statBox('Paket Termurah', cheapest?.product.name ?? '-', '⬇️', AppTheme.success, constraints),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            // Statistik tambahan
            _infoRow('Total Paket Dipesan', '${cart.itemCount} paket'),
            _infoRow('Total Pax', '${cart.totalPax} pax'),
            if (cart.mostExpensiveItem != null)
              _infoRow(
                'Porsi terbesar dari total',
                '${cart.mostExpensivePercentage.toStringAsFixed(1)}% (${cart.mostExpensiveItem!.product.name})',
              ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String label, String value, String emoji, Color color, BoxConstraints constraints) {
    final width = (constraints.maxWidth - 12) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // Narasi data visual hasil belanja
  Widget _buildNarrativeCard() {
    final mostExp = cart.mostExpensiveItem;
    final cheapest = cart.cheapestItem;
    final avg = cart.averagePrice;

    String narrative = 'Anda memesan ${cart.itemCount} paket Teppanku senilai total ${_formatRupiah(cart.totalPrice)} untuk ${cart.totalPax} pax. ';
    if (mostExp != null) {
      narrative += 'Paket dengan nilai tertinggi adalah "${mostExp.product.name}" (${_formatRupiah(mostExp.product.price)}), '
          'yang menyumbang ${cart.mostExpensivePercentage.toStringAsFixed(1)}% dari total belanja. ';
    }
    if (cheapest != null && cheapest.product.id != mostExp?.product.id) {
      narrative += 'Sedangkan pilihan paling ekonomis adalah "${cheapest.product.name}" (${_formatRupiah(cheapest.product.price)}). ';
    }
    narrative += 'Rata-rata harga paket yang Anda pilih adalah ${_formatRupiah(avg)}.';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.description_outlined, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('Ringkasan Naratif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
              ),
              child: Text(narrative, style: const TextStyle(fontSize: 13, height: 1.6, color: AppTheme.textDark)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.event, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('Informasi Acara', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Nama Pemesan', customerName),
            _infoRow('Lokasi Acara', address),
            _infoRow('Tanggal Acara', eventDate),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailCard(double totalPayment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.receipt_long_outlined, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('Detail Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            ...cart.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${item.product.name} x${item.quantity}', style: const TextStyle(fontSize: 13))),
                  Text(_formatRupiah(item.subtotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            )),
            if (discount > 0) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Diskon Promo', style: TextStyle(color: AppTheme.success)),
                  Text('- ${_formatRupiah(discount)}', style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
            const Divider(thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL PEMBAYARAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(_formatRupiah(totalPayment), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menghubungi WhatsApp Teppanku... 📲'), backgroundColor: AppTheme.success),
              );
            },
            icon: const Icon(Icons.chat_outlined),
            label: const Text('Konfirmasi via WhatsApp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home_outlined, color: AppTheme.primary),
            label: const Text('Kembali ke Beranda', style: TextStyle(color: AppTheme.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppTheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey)),
        ),
        const Text(': ', style: TextStyle(color: AppTheme.textGrey)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      ],
    ),
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
