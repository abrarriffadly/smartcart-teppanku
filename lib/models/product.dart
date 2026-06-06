// lib/models/product.dart

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;  // ganti dari imageEmoji ke imagePath
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> includes;
  final bool isBestSeller;
  final bool isPremium;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.includes,
    this.isBestSeller = false,
    this.isPremium = false,
  });
}

class CartItem {
  final Product product;
  int quantity;
  String selectedSauce;
  List<AddOn> selectedAddOns;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSauce = 'Teriyaki',
    List<AddOn>? selectedAddOns,
  }) : selectedAddOns = selectedAddOns ?? [];

  double get subtotal {
    double base = product.price * quantity;
    double addOnTotal = selectedAddOns.fold(0, (sum, a) => sum + a.price);
    return base + addOnTotal;
  }
}

class AddOn {
  final String name;
  final double price;
  bool isSelected;

  AddOn({
    required this.name,
    required this.price,
    this.isSelected = false,
  });
}
