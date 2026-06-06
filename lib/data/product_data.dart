// lib/data/product_data.dart
// Simulasi async loading produk dari "server" (Sub CPMK-1: Future & async/await)

import '../models/product.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return const [
      Product(
        id: '1',
        name: 'Chicken Teppanyaki',
        description: 'Paket ayam premium dengan live cooking di lokasi acara Anda bersama chef profesional.',
        price: 1500000,
        imagePath: 'assets/images/chicken.png',
        category: 'Chicken',
        rating: 4.8,
        reviewCount: 76,
        includes: ['Teriyaki / Yakiniku Sauce', 'Egg Chicken Roll / Shrimp Roll', 'Rice', 'Miso Soup + Tofu', 'Ocha / Mineral Water', 'Japanese Milk Pudding', 'Vegetables'],
        isBestSeller: false,
        isPremium: false,
      ),
      Product(
        id: '2',
        name: 'Slice Beef Teppanyaki',
        description: 'Paket beef slice pilihan, live cooking langsung di lokasi acara Anda bersama chef profesional.',
        price: 1950000,
        imagePath: 'assets/images/slice_beef.png',
        category: 'Beef',
        rating: 4.9,
        reviewCount: 120,
        includes: ['Teriyaki / Yakiniku Sauce', 'Egg Roll / Shrimp Roll', 'Rice', 'Miso Soup', 'Pudding'],
        isBestSeller: true,
        isPremium: true,
      ),
      Product(
        id: '3',
        name: 'Seafood Teppanyaki',
        description: 'Paket seafood segar: udang, cumi, scallop dengan saus Jepang pilihan.',
        price: 2200000,
        imagePath: 'assets/images/seafood.png',
        category: 'Seafood',
        rating: 4.8,
        reviewCount: 126,
        includes: ['Shrimp / Squid / Scallop', 'Rice', 'Miso Soup', 'Japanese Pudding', 'Soft Drink'],
        isBestSeller: false,
        isPremium: true,
      ),
      Product(
        id: '4',
        name: 'Salmon Teppanyaki',
        description: 'Salmon segar premium dengan pilihan sauce Jepang eksklusif dan live cooking.',
        price: 2300000,
        imagePath: 'assets/images/salmon.png',
        category: 'Seafood',
        rating: 4.9,
        reviewCount: 120,
        includes: ['Teriyaki / Yakiniku / Miso / Kalbi Sauce', 'Fish Cake / Tsukune', 'Rice', 'Miso Soup', 'Soft Drink', 'Japanese Coffee Jelly'],
        isBestSeller: true,
        isPremium: true,
      ),
      Product(
        id: '5',
        name: 'Tenderloin Teppanyaki',
        description: 'Daging tenderloin premium dengan tekstur lembut dan juicy, dimasak langsung di depan Anda.',
        price: 2500000,
        imagePath: 'assets/images/tenderloin.png',
        category: 'Beef',
        rating: 5.0,
        reviewCount: 92,
        includes: ['Teriyaki / Yakiniku / Miso / Kalbi Sauce', 'Chicken Karaage / Ebi Tempura', 'Rice', 'Oden Soup / Chawan Musi', 'Soft Drink / Fresh Juice', 'Japanese Coffee Jelly / Taiyaki'],
        isBestSeller: true,
        isPremium: true,
      ),
      Product(
        id: '6',
        name: 'Sirloin Teppanyaki',
        description: 'Sirloin premium dengan marbling terbaik, sajian mewah untuk acara spesial Anda.',
        price: 2500000,
        imagePath: 'assets/images/sirloin.png',
        category: 'Beef',
        rating: 5.0,
        reviewCount: 64,
        includes: ['Teriyaki / Yakiniku / Miso Sauce', 'Shrimp Roll / Mini Katsu / Fish Cake', 'Rice', 'Miso Soup + Tofu', 'Lemon Tea / Blackcurrant Tea', 'Japanese Milk Pudding / Dorayaki'],
        isBestSeller: false,
        isPremium: true,
      ),
      Product(
        id: '7',
        name: 'Scallop Teppanyaki',
        description: 'Kerang scallop pilihan dengan bumbu Jepang autentik.',
        price: 1850000,
        imagePath: 'assets/images/scallop.png',
        category: 'Seafood',
        rating: 4.8,
        reviewCount: 126,
        includes: ['Teriyaki / Yakiniku / Miso / Kalbi Sauce', 'Fish Cake / Tsukune', 'Rice', 'Miso Soup', 'Soft Drink', 'Taiyaki'],
        isBestSeller: false,
        isPremium: true,
      ),
      Product(
        id: '8',
        name: 'Vegetable Teppanyaki',
        description: 'Paket sayuran segar berkualitas untuk pilihan sehat dalam acara Anda.',
        price: 1550000,
        imagePath: 'assets/images/vegetable.png',
        category: 'Vegetable',
        rating: 5.0,
        reviewCount: 64,
        includes: ['Teriyaki / Yakiniku / Miso / Kalbi Sauce', 'Mix Vegetables / Grill Vegetables', 'Rice', 'Miso Soup + Tofu', 'Soft Drink / Infused Water', 'Japanese Coffee Jelly'],
        isBestSeller: false,
        isPremium: false,
      ),
    ];
  }

  static List<AddOn> getAddOns() {
    return [
      AddOn(name: 'Extra Beef Slice', price: 150000),
      AddOn(name: 'Extra Beef Slice Premium', price: 250000),
      AddOn(name: 'Extra Seafood Mix', price: 180000),
      AddOn(name: 'Extra Rice', price: 50000),
      AddOn(name: 'Extra Pudding', price: 80000),
      AddOn(name: 'Extra Vegetables', price: 60000),
    ];
  }
}
