// class Product {
//   final int id;
//   final String name;
//   final double price;
//   final bool isVat;
//   final String category;

//   List<String>? addOns;
//   double addOnsValue;

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.isVat,
//     required this.category,
//     this.addOns,
//     this.addOnsValue = 0.0,
//   });
// }

class Product {
  final int id;
  final String name;
  final double price;
  final bool isVat;
  final String category;

  List<String>? addOns;
  double addOnsValue;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.isVat,
    required this.category,
    this.addOns,
    this.addOnsValue = 0.0,
    this.quantity = 1, // default 1
  });

  // Optional: to map for saving or duplication
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isVat': isVat,
      'category': category,
      'addOns': addOns,
      'addOnsValue': addOnsValue,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      isVat: map['isVat'],
      category: map['category'],
      addOns: map['addOns'] != null ? List<String>.from(map['addOns']) : null,
      addOnsValue: map['addOnsValue'] ?? 0.0,
      quantity: map['quantity'] ?? 1,
    );
  }
}
