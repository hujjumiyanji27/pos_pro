import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/db_helper.dart';
import '../models/product.dart';
import 'customer_form_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'customer_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
String selectedCategory = 'All';


final List<Map<String, dynamic>> zeroVatAddOns = [
  {'name': 'Lettuce', 'price': 0.00},
  {'name': 'Red Onion', 'price': 0.00},
  {'name': 'Tomatoes', 'price': 0.00},
{'name': 'Garlic Mayo tub', 'price': 0.50},
    {'name': 'Mint Sauce tub', 'price': 0.50},
    {'name': 'Spicy Sauce tub', 'price': 0.30},
        {'name': 'Garlic Sauce tub', 'price': 0.50},
        {'name': 'Ketchup Sauce tub', 'price': 0.50},
        {'name': 'Burger Sauce tub', 'price': 0.50},
        {'name': 'Buffalo Sauce tub', 'price': 0.50},
        {'name': 'Onion & Pepper Sauce', 'price': 0.99},
        {'name': 'Plain- No Sauce & Salad', 'price': 0.00},
];

final List<Map<String, dynamic>> baseOptions = [
  {'name': 'Naan', 'price': 0.00},
  {'name': 'Fries', 'price': 0.00},
  {'name': 'Garlic Naan', 'price': 0.50},
  {'name': 'Plain Rice', 'price': 0.00},
  {'name': 'Peri Peri Rice', 'price': 0.00},
  {'name': 'Masala Rice', 'price': 0.00},
];


Future<Map<String, dynamic>?> showWrapBurgerMealDialog(BuildContext context) async {
  bool makeMeal = false;
  String? selectedDrink;
  double drinkExtra = 0.0;
  final List<Map<String, dynamic>> selectedAddOns = [];

  final drinkOptions = [
    {'name': 'Pepsi Can', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'Tango Orange', 'extra': 0.0},
    {'name': 'Rubicon Passion', 'extra': 0.0},
    {'name': 'Irn-Bru', 'extra': 0.0},
    {'name': 'Irn-Bru Extra', 'extra': 0.0},
    {'name': 'San Pellegrino Lemon', 'extra': 0.5},
  ];

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Customize Meal"),
        content: SizedBox(
          width: 600,
          height: 400,
          child: Row(
            children: [
              // LEFT: Straight sauce/salad options
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🧂 Add Sauces & Salads (Zero VAT)", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: zeroVatAddOns.map((addon) {
                            final isSelected = selectedAddOns.contains(addon);
                            return ChoiceChip(
                              label: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
                              selected: isSelected,
                              selectedColor: Colors.deepOrange,
                              onSelected: (_) {
                                setState(() {
                                  if (isSelected) {
                                    selectedAddOns.remove(addon);
                                  } else {
                                    selectedAddOns.add(addon);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(),

              // RIGHT: Meal toggle + drinks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      value: makeMeal,
                      title: const Text("Make it a Meal? (+£1.99 incl. Fries)"),
                      onChanged: (val) => setState(() => makeMeal = val),
                    ),
                    if (makeMeal) ...[
                      const SizedBox(height: 10),
                      const Text("Select Drink", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: drinkOptions.map((drink) {
                          final name = drink['name'] as String;
                          final extra = drink['extra'] as double;
                          return ChoiceChip(
                            label: Text(extra > 0 ? "$name (+£${extra.toStringAsFixed(2)})" : name),
                            selected: selectedDrink == name,
                            selectedColor: Colors.deepOrange,
                            onSelected: (_) {
                              setState(() {
                                selectedDrink = name;
                                drinkExtra = extra;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("Drink Extra: £${drinkExtra.toStringAsFixed(2)}"),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final addonTotal = selectedAddOns.fold(0.0, (sum, item) => sum + (item['price'] as double));
              final totalMealExtra = makeMeal ? 1.99 + drinkExtra : 0.0;

              Navigator.pop(ctx, {
                'meal': makeMeal,
                'drink': makeMeal ? selectedDrink : null,
                'mealExtra': totalMealExtra,
                'addons': selectedAddOns,
                'addonTotal': addonTotal,
              });
            },
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    ),
  );
}


Future<Map<String, dynamic>?> showBaseDialog(BuildContext context) async {
  Map<String, dynamic>? selectedBase;
  final List<Map<String, dynamic>> selectedAddOns = [];

  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: const Text("Customize Your Meal"),
          content: SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.8,
            height: 400,
            child: Row(
              children: [
                // LEFT: Salads and Sauces as straight ChoiceChips
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Salads & Sauces (Cold, Zero VAT)", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: zeroVatAddOns.map((addon) {
                              final isSelected = selectedAddOns.contains(addon);
                              final label = addon['name'];
                              final price = addon['price'] as double;

                              return ChoiceChip(
                                label: Text("$label (£${price.toStringAsFixed(2)})"),
                                selected: isSelected,
                                selectedColor: Colors.deepOrange,
                                onSelected: (_) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedAddOns.remove(addon);
                                    } else {
                                      selectedAddOns.add(addon);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(),

                // RIGHT: Served With options as ChoiceChips
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Served With (Select One)", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: baseOptions.map((base) {
                          final isSelected = selectedBase == base;
                          return ChoiceChip(
                            label: Text(
                              "${base['name']}${base['price'] > 0 ? " (+£${base['price'].toStringAsFixed(2)})" : ""}",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.deepOrange,
                            onSelected: (_) {
                              setState(() => selectedBase = base);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedBase == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a base option")),
                  );
                  return;
                }
                final totalAddOnPrice = selectedAddOns.fold(0.0, (sum, item) => sum + (item['price'] as double));
                Navigator.pop(ctx, {
                  'base': selectedBase!,
                  'addons': selectedAddOns,
                  'addonTotal': totalAddOnPrice,
                });
              },
              child: const Text("Add to Cart"),
            ),
          ],
        );
      },
    ),
  );
}




class _HomeScreenState extends State<HomeScreen> {
  final DBHelper db = DBHelper();
  List<Product> allProducts = [];
  List<Product> orderCart = [];

  String searchQuery = '';
  String? incomingCallerId;
  TextEditingController phoneController = TextEditingController();

  String? orderType;
  String? paymentMethod;
  String? deliveryAddress;

  double get total => orderCart.fold(0, (sum, item) => sum + item.price);
  // double get zeroRatedTotal => orderCart.fold(0, (sum, item) => sum + item.addOnsValue);
double get zeroRatedTotal => orderCart.fold(0.0, (sum, item) {
  if (!item.isVat) {
    return sum + item.price; // Full item is zero-rated
  } else {
    return sum + item.addOnsValue; // Only addons are zero-rated
  }
});


double get vat => orderCart
    .where((item) => item.isVat)
    .fold(0.0, (sum, item) {
      final vatTaxablePortion = item.price - item.addOnsValue;
      return sum + (vatTaxablePortion * 20 / 120);
    });


  // double get vat => orderCart.where((item) => item.isVat).fold(0, (sum, item) {
  //   final taxable = item.price - item.addOnsValue;
  //   return sum + (taxable * 20 / 120);
  // });


  double get net => total - vat;

  @override
  void initState() {
    super.initState();
    loadProducts();
    pollForCallerId();
  }

  Future<void> loadProducts() async {
    allProducts = await db.getProducts();
    setState(() {});
  }

Future<void> printReceipt() async {
  final pdf = pw.Document();

  final now = DateTime.now();
  final formattedDate = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

  pdf.addPage(
    pw.Page(
      pageFormat: const PdfPageFormat(249, double.infinity), // 88mm width
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 12), // Shift content right
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("GRILL CORNER", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 4),
              pw.Center(child: pw.Text("EPOS PRO Receipt", style: pw.TextStyle(fontSize: 10))),
              pw.SizedBox(height: 2),
              pw.Text("Date: $formattedDate", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 4),
              pw.Text("Order Type: $orderType", style: pw.TextStyle(fontSize: 10)),
              if (orderType == 'Delivery') pw.Text("Address: $deliveryAddress", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Payment Method: $paymentMethod", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 0.5),

              // Item list
              ...orderCart.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(item.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    if (item.addOns != null && item.addOns!.isNotEmpty)
                      pw.Text(item.addOns!.join(', '), style: pw.TextStyle(fontSize: 9)),
                    pw.Text("£${item.price.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 4),
                  ],
                );
              }),

              pw.Divider(thickness: 0.5),
              pw.Text("Total: £${total.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Zero-rated: £${zeroRatedTotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("VAT (20%): £${vat.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Net Sales: £${net.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 6),
              pw.Center(child: pw.Text("Thank you!", style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10))),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}


  Future<void> handleProductTap(Product product) async {
  // Special case: Only show sauces/salads for Tray of Donner Meat (Large)
  if (product.name == "Tray of Donner Meat (Large)") {
    final List<Map<String, dynamic>> selectedAddOns = [];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Sauces & Salads"),
        content: SizedBox(
          width: MediaQuery.of(ctx).size.width * 0.6,
          height: 400,
          child: ListView.builder(
            itemCount: zeroVatAddOns.length,
            itemBuilder: (_, index) {
              final addon = zeroVatAddOns[index];
              final isSelected = selectedAddOns.contains(addon);
              return CheckboxListTile(
                title: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
                value: isSelected,
                onChanged: (val) {
                  if (val == true) {
                    selectedAddOns.add(addon);
                  } else {
                    selectedAddOns.remove(addon);
                  }
                  (ctx as Element).markNeedsBuild();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final addonTotal = selectedAddOns.fold(0.0, (sum, item) => sum + (item['price'] as double));
              final addonNames = selectedAddOns
                  .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
                  .toList();

              Navigator.pop(ctx, {
                'addons': selectedAddOns,
                'addonTotal': addonTotal,
                'addonNames': addonNames,
              });
            },
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    );

    if (result != null) {
      final addonNames = result['addonNames'] as List<String>;
      final addonTotal = result['addonTotal'] as double;

      final customized = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        isVat: product.isVat,
        category: product.category,
        addOns: addonNames,
        addOnsValue: addonTotal,
      );

      addToCart(customized);
    }
  }

  // Normal grill/sizzlers/donner/etc flow
  else if (["Grill", "Sizzlers", "Donner", "Peri Peri Chicken"].contains(product.category)) {
    final result = await showBaseDialog(context);
    if (result == null) return;

    final base = result['base'];
    final addons = result['addons'] as List<Map<String, dynamic>>;
    final addonTotal = result['addonTotal'] as double;

    final addonNames = addons
        .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
        .toList();

    final selectedProduct = Product(
      id: product.id,
      name: "${product.name} + ${base['name']}",
      price: product.price + (base['price'] as double),
      isVat: product.isVat,
      category: product.category,
      addOns: addonNames,
      addOnsValue: addonTotal,
    );

    addToCart(selectedProduct);
  }

  // Pizza / Calzone
  else if (["Pizza", "Calzone"].contains(product.category)) {
    await showPizzaDialog(product);
  }

  // Wraps or Burgers
  else if (["Wraps", "Burger"].contains(product.category)) {
    final result = await showWrapBurgerMealDialog(context);
    if (result != null) {
      final addons = result['addons'] as List<Map<String, dynamic>>;
      final addonTotal = result['addonTotal'] as double;
      final mealExtra = result['mealExtra'] as double;
      final drink = result['drink'] as String?;

      final addonNames = addons
          .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
          .toList();
      if (drink != null) addonNames.add("Drink: $drink");

      final customized = Product(
        id: product.id,
        name: "${product.name}${drink != null ? ' + Meal' : ''}",
        price: product.price + mealExtra,
        isVat: product.isVat,
        category: product.category,
        addOns: addonNames,
        addOnsValue: addonTotal,
      );

      addToCart(customized);
    }
  }

  // Other conditional offers and specials
  else if (product.name.contains("Nuggets Meal")) {
    await showNuggetsMealDialog(product);
  } else if (product.name.contains("Pizza Meal")) {
    await showPizzaMealDialog(product);
  } else if (product.category == "Milkshakes") {
    await showMilkshakeDialog(product);
  } else if (product.name.contains("Chicken Nuggets Meal") ||
      product.name.contains("Popcorn Chicken Meal")) {
    await showNuggetsMealDialog(product);
  } else if (product.name.contains('12" Pizza Offer')) {
    await showPizzaOfferDialog(
      context,
      '12"',
      24.99,
      allProducts.where((p) => p.category == "Pizza").toList(),
      addToCart,
    );
  } else if (product.name.contains('14" Pizza Offer')) {
    await showPizzaOfferDialog(
      context,
      '14"',
      29.99,
      allProducts.where((p) => p.category == "Pizza").toList(),
      addToCart,
    );
  } else if (product.name.contains("Family Offer 1")) {
    await showFamilyOffer1Dialog(
      context,
      allProducts.where((p) => p.category == "Pizza").toList(),
      addToCart,
    );
  } else if (product.name.contains("Family Offer 2")) {
    await showFamilyOffer2Dialog(
      context,
      allProducts.where((p) => p.category == "Pizza").toList(),
      addToCart,
    );
  } else if (product.name.contains("Wrap Meal")) {
    await showWrapMealDialog(product);
  }

  // Default: just add to cart
  else {
    addToCart(product);
  }
}


//   Future<void> handleProductTap(Product product) async {
//   // Special case: Only show sauces/salads for Tray of Donner Meat (Large)
//   if (product.name == "Tray of Donner Meat (Large)") {
//     final List<Map<String, dynamic>> selectedAddOns = [];

//     final result = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Add Sauces & Salads"),
//         content: SizedBox(
//           width: MediaQuery.of(ctx).size.width * 0.6,
//           height: 400,
//           child: ListView.builder(
//             itemCount: zeroVatAddOns.length,
//             itemBuilder: (_, index) {
//               final addon = zeroVatAddOns[index];
//               final isSelected = selectedAddOns.contains(addon);
//               return CheckboxListTile(
//                 title: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
//                 value: isSelected,
//                 onChanged: (val) {
//                   if (val == true) {
//                     selectedAddOns.add(addon);
//                   } else {
//                     selectedAddOns.remove(addon);
//                   }
//                   (ctx as Element).markNeedsBuild();
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               final addonTotal = selectedAddOns.fold(0.0, (sum, item) => sum + (item['price'] as double));
//               final addonNames = selectedAddOns
//                   .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
//                   .toList();

//               Navigator.pop(ctx, {
//                 'addons': selectedAddOns,
//                 'addonTotal': addonTotal,
//                 'addonNames': addonNames,
//               });
//             },
//             child: const Text("Add to Cart"),
//           ),
//         ],
//       ),
//     );

//     if (result != null) {
//       final addonNames = result['addonNames'] as List<String>;
//       final addonTotal = result['addonTotal'] as double;

//       final customized = Product(
//         id: product.id,
//         name: product.name,
//         price: product.price,
//         isVat: product.isVat,
//         category: product.category,
//         addOns: addonNames,
//         addOnsValue: addonTotal,
//       );

//       addToCart(customized);
//     }
//   }

//   // Normal grill/sizzlers/donner/etc flow
//   else if (["Grill", "Sizzlers", "Donner", "Peri Peri Chicken"].contains(product.category)) {
//     final result = await showBaseDialog(context);
//     if (result == null) return;

//     final base = result['base'];
//     final addons = result['addons'] as List<Map<String, dynamic>>;
//     final addonTotal = result['addonTotal'] as double;

//     final addonNames = addons
//         .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
//         .toList();

//     final selectedProduct = Product(
//       id: product.id,
//       name: "${product.name} + ${base['name']}",
//       price: product.price + (base['price'] as double),
//       isVat: product.isVat,
//       category: product.category,
//       addOns: addonNames,
//       addOnsValue: addonTotal,
//     );

//     addToCart(selectedProduct);
//   }

//   // Pizza / Calzone
//   else if (["Pizza", "Calzone"].contains(product.category)) {
//     await showPizzaDialog(product);
//   }

//   // Wraps or Burgers
//   else if (["Wraps", "Burger"].contains(product.category)) {
//     final result = await showWrapBurgerMealDialog(context);
//     if (result != null) {
//       final addons = result['addons'] as List<Map<String, dynamic>>;
//       final addonTotal = result['addonTotal'] as double;
//       final mealExtra = result['mealExtra'] as double;
//       final drink = result['drink'] as String?;

//       final addonNames = addons
//           .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
//           .toList();
//       if (drink != null) addonNames.add("Drink: $drink");

//       final customized = Product(
//         id: product.id,
//         name: "${product.name}${drink != null ? ' + Meal' : ''}",
//         price: product.price + mealExtra,
//         isVat: product.isVat,
//         category: product.category,
//         addOns: addonNames,
//         addOnsValue: addonTotal,
//       );

//       addToCart(customized);
//     }
//   }

//   // Other conditional offers and specials
//   else if (product.name.contains("Nuggets Meal")) {
//     await showNuggetsMealDialog(product);
//   } else if (product.name.contains("Pizza Meal")) {
//     await showPizzaMealDialog(product);
//   } else if (product.category == "Milkshakes") {
//     await showMilkshakeDialog(product);
//   } else if (product.name.contains("Chicken Nuggets Meal") ||
//       product.name.contains("Popcorn Chicken Meal")) {
//     await showNuggetsMealDialog(product);
//   } else if (product.name.contains('12" Pizza Offer')) {
//     await showPizzaOfferDialog(
//       context,
//       '12"',
//       24.99,
//       allProducts.where((p) => p.category == "Pizza").toList(),
//       addToCart,
//     );
//   } else if (product.name.contains('14" Pizza Offer')) {
//     await showPizzaOfferDialog(
//       context,
//       '14"',
//       29.99,
//       allProducts.where((p) => p.category == "Pizza").toList(),
//       addToCart,
//     );
//   } else if (product.name.contains("Family Offer 1")) {
//     await showFamilyOffer1Dialog(
//       context,
//       allProducts.where((p) => p.category == "Pizza").toList(),
//       addToCart,
//     );
//   } else if (product.name.contains("Family Offer 2")) {
//     await showFamilyOffer2Dialog(
//       context,
//       allProducts.where((p) => p.category == "Pizza").toList(),
//       addToCart,
//     );
//   } else if (product.name.contains("Wrap Meal")) {
//     await showWrapMealDialog(product);
//   }

//   // Default: just add to cart
//   else {
//     addToCart(product);
//   }
// }

Widget _buildCartSection() {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        const Text("🧾 Order Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Expanded(
          child: ListView.builder(
            itemCount: orderCart.length,
            itemBuilder: (_, index) {
              final item = orderCart[index];
              return ListTile(
                title: Text(item.name),
                subtitle: item.addOns != null && item.addOns!.isNotEmpty
                    ? Text("With: ${item.addOns!.join(', ')}")
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("£${item.price.toStringAsFixed(2)}"),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => orderCart.removeAt(index)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Total: £${total.toStringAsFixed(2)}"),
            Text("Zero-rated total: £${zeroRatedTotal.toStringAsFixed(2)}"),
            Text("VATable subtotal: £${(total - zeroRatedTotal).toStringAsFixed(2)}"),
            Text("VAT (20%): £${vat.toStringAsFixed(2)}"),
            Text("Net Sales: £${net.toStringAsFixed(2)}"),

            const SizedBox(height: 10),
            const Text("Order Type", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ['Collection', 'Delivery'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: orderType == type,
                  selectedColor: Colors.deepOrange,
                  onSelected: (_) => setState(() => orderType = type),
                );
              }).toList(),
            ),

            if (orderType == 'Delivery') ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(text: deliveryAddress),
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.location_searching),
                    onPressed: openCustomerAddressSearch,
                  ),
                ),
                minLines: 2,
                maxLines: 3,
                onChanged: (value) => deliveryAddress = value,
              ),
            ],

            const SizedBox(height: 10),
            const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ['Cash', 'Card', 'Bank Transfer'].map((method) {
                return ChoiceChip(
                  label: Text(method),
                  selected: paymentMethod == method,
                  selectedColor: Colors.deepOrange,
                  onSelected: (_) => setState(() => paymentMethod = method),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            ElevatedButton.icon(
             onPressed: () async {
  if (orderCart.isEmpty || orderType == null || paymentMethod == null || (orderType == 'Delivery' && (deliveryAddress == null || deliveryAddress!.isEmpty))) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all order fields")),
    );
    return;
  }

  final items = orderCart.map((e) {
    return {
      'name': e.name,
      'price': e.price,
      'isVat': e.isVat,
      'addOns': e.addOns ?? [],
      'addOnsValue': e.addOnsValue,
    };
  }).toList();

  final now = DateTime.now();

  // ✅ Save to local DB
  final flatItemString = items.map((e) {
    final addonText = (e['addOns'] as List).isNotEmpty ? "With: ${(e['addOns'] as List).join(', ')}" : "";
    return "${e['name']} $addonText";
  }).join(', ');

  // await db.saveOrder(
  //   items: flatItemString,
  //   total: total,
  //   vat: vat,
  //   net: net,
  //   date: now.toIso8601String().substring(0, 16),
  //   orderType: orderType!,
  //   paymentMethod: paymentMethod!,
  //   address: orderType == 'Delivery' ? deliveryAddress! : 'N/A',
  // );

  // ✅ Save to Firebase
  await FirebaseFirestore.instance.collection('orders').add({
    'items': items,
    'total': total,
    'vatTotal': vat,
    'netTotal': net,
    'orderType': orderType,
    'paymentMethod': paymentMethod,
    'address': orderType == 'Delivery' ? deliveryAddress : 'N/A',
    'date': Timestamp.fromDate(now),
  });

  await printReceipt();

  clearOrder();
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order saved to DB and Firebase!")));
},


              icon: const Icon(Icons.save),
              label: const Text("Save Order"),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: clearOrder,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Clear Order"),
            ),
            const SizedBox(height: 8),
            Text(
              "Note: Cold food add-ons (salads/sauces) are zero-rated and excluded from VAT.",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}



// Future<void> showPizzaMealDialog(Product baseProduct) async {
//   String? selectedDrink;
//   String? selectedCrust;
//   final List<String> crusts = ["Thin Crust", "Deep Pan", "Stuffed Crust"];

//   final List<Map<String, dynamic>> drinks = [
//     {'name': 'Pepsi Can', 'extra': 0.0},
//     {'name': 'Rubicon Mango', 'extra': 0.0},
//     {'name': 'Tango Orange', 'extra': 0.0},
//     {'name': 'Rubicon Passion', 'extra': 0.0},
//     {'name': 'Irn-Bru', 'extra': 0.0},
//     {'name': 'Irn-Bru Extra', 'extra': 0.0},
//     {'name': 'Rubicon Mango', 'extra': 0.0},
//     {'name': 'San Pellegrino Lemon', 'extra': 0.5},
//   ];

//   await showDialog(
//     context: context,
//     builder: (ctx) => StatefulBuilder(
//       builder: (ctx, setState) {
//         return AlertDialog(
//           title: const Text("Customize 9\" Pizza Meal"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//   width: double.infinity,
//   child: DropdownButtonFormField<String>(
//     decoration: const InputDecoration(labelText: "Choose Crust"),
//     value: selectedCrust,
//     items: crusts.map<DropdownMenuItem<String>>((c) {
//       return DropdownMenuItem<String>(
//         value: c,
//         child: Text(c),
//       );
//     }).toList(),
//     onChanged: (val) => setState(() => selectedCrust = val),
//   ),
// ),

//               SizedBox(
//   width: double.infinity,
//   child: DropdownButtonFormField<String>(
//     decoration: const InputDecoration(labelText: "Choose Drink"),
//     value: selectedDrink,
//     items: drinks.map<DropdownMenuItem<String>>((d) {
//       final label = d['extra'] > 0
//           ? "${d['name']} (+£${(d['extra'] as double).toStringAsFixed(2)})"
//           : d['name'] as String;
//       return DropdownMenuItem<String>(
//         value: d['name'] as String,
//         child: Text(label),
//       );
//     }).toList(),
//     onChanged: (val) => setState(() => selectedDrink = val),
//   ),
// ),

//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
//             ElevatedButton(
//               onPressed: () {
//                 final drink = drinks.firstWhere((d) => d['name'] == selectedDrink, orElse: () => {'extra': 0.0});
//                 final extra = drink['extra'];
//                 final updated = Product(
//                   id: baseProduct.id,
//                   name: "${baseProduct.name} ($selectedCrust + $selectedDrink)",
//                   price: baseProduct.price + extra,
//                   isVat: baseProduct.isVat,
//                   category: baseProduct.category,
//                   addOns: [selectedDrink ?? "", selectedCrust ?? ""],
//                   addOnsValue: extra,
//                 );
//                 addToCart(updated);
//                 Navigator.pop(ctx);
//               },
//               child: const Text("Add to Cart"),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }

Future<void> showNuggetsMealDialog(Product baseProduct) async {
  String? selectedDrink;

  final List<Map<String, dynamic>> drinks = [
    {'name': 'Pepsi Can', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'Tango Orange', 'extra': 0.0},
    {'name': 'Rubicon Passion', 'extra': 0.0},
    {'name': 'Irn-Bru', 'extra': 0.0},
    {'name': 'Irn-Bru Extra', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'San Pellegrino Lemon', 'extra': 0.5},
  ];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Select Drink for Nuggets Meal"),
        content: SizedBox(
  width: double.infinity,
  child: DropdownButtonFormField<String>(
    value: selectedDrink,
    decoration: const InputDecoration(labelText: "Select Drink"),
    items: drinks.map<DropdownMenuItem<String>>((d) {
      final label = (d['extra'] ?? 0.0) > 0
          ? "${d['name']} (+£${(d['extra'] as double).toStringAsFixed(2)})"
          : d['name'] as String;

      return DropdownMenuItem<String>(
        value: d['name'] as String,
        child: Text(label),
      );
    }).toList(),
    onChanged: (val) => setState(() => selectedDrink = val),
  ),
),

        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final drink = drinks.firstWhere((d) => d['name'] == selectedDrink, orElse: () => {'extra': 0.0});
              final extra = drink['extra'];
              final updated = Product(
                id: baseProduct.id,
                name: "${baseProduct.name} + $selectedDrink",
                price: baseProduct.price + extra,
                isVat: baseProduct.isVat,
                category: baseProduct.category,
                addOns: [selectedDrink ?? ""],
                addOnsValue: extra,
              );
              addToCart(updated);
              Navigator.pop(ctx);
            },
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    ),
  );
}

Future<void> showWrapMealDialog(Product baseProduct) async {
  final List<Map<String, dynamic>> sauces = [
    {'name': 'Lettuce', 'price': 0.00},
    {'name': 'Red Onion', 'price': 0.00},
    {'name': 'Tomatoes', 'price': 0.00},
    {'name': 'Garlic Mayo tub', 'price': 0.50},
    {'name': 'Mint Sauce tub', 'price': 0.50},
    {'name': 'Spicy Sauce tub', 'price': 0.30},
        {'name': 'Garlic Sauce tub', 'price': 0.50},
        {'name': 'Ketchup Sauce tub', 'price': 0.50},
        {'name': 'Burger Sauce tub', 'price': 0.50},
        {'name': 'Buffalo Sauce tub', 'price': 0.50},
        {'name': 'Onion & Pepper Sauce', 'price': 0.99},
        {'name': 'Plain- No Sauce & Salad', 'price': 0.00},








  ];

  final List<Map<String, dynamic>> drinks = [
    {'name': 'Pepsi Can', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'Tango Orange', 'extra': 0.0},
    {'name': 'Rubicon Passion', 'extra': 0.0},
    {'name': 'Irn-Bru', 'extra': 0.0},
    {'name': 'Irn-Bru Extra', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'San Pellegrino Lemon', 'extra': 0.5},
  ];

  final List<Map<String, dynamic>> selectedSauces = [];
  String? selectedDrink;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Make it a Meal?"),
        content: SizedBox(
          height: 300,
          child: Row(
            children: [
              // Left - Sauce & Salad
              Expanded(
                child: ListView(
                  children: sauces.map((sauce) {
                    return CheckboxListTile(
                      title: Text("${sauce['name']} (£${sauce['price'].toStringAsFixed(2)})"),
                      value: selectedSauces.contains(sauce),
                      onChanged: (v) {
                        setState(() {
                          if (v!) {
                            selectedSauces.add(sauce);
                          } else {
                            selectedSauces.remove(sauce);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const VerticalDivider(),
              // Right - Drink
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDrink,
                  decoration: const InputDecoration(labelText: "Select Drink"),
items: drinks.map<DropdownMenuItem<String>>((d) {
  final label = (d['extra'] ?? 0.0) > 0
      ? "${d['name']} (+£${(d['extra'] as double).toStringAsFixed(2)})"
      : d['name'] as String;

  return DropdownMenuItem<String>(
    value: d['name'] as String,
    child: Text(label),
  );
}).toList(),
                  onChanged: (val) => setState(() => selectedDrink = val),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final drink = drinks.firstWhere((d) => d['name'] == selectedDrink, orElse: () => {'extra': 0.0});
              final drinkExtra = drink['extra'];
              final saucesTotal = selectedSauces.fold(0.0, (sum, s) => sum + s['price']);
              final allAddOns = [...selectedSauces.map((s) => "${s['name']} (£${s['price'].toStringAsFixed(2)})"), selectedDrink ?? ""];
              final totalAddOn = saucesTotal + drinkExtra;

              final updated = Product(
                id: baseProduct.id,
                name: "${baseProduct.name} + Meal",
                price: baseProduct.price + totalAddOn,
                isVat: baseProduct.isVat,
                category: baseProduct.category,
                addOns: allAddOns,
                addOnsValue: saucesTotal,
              );
              addToCart(updated);
              Navigator.pop(ctx);
            },
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    ),
  );
}
Future<void> showMilkshakeDialog(Product baseProduct) async {
  bool withCream = true;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: Text("Customize ${baseProduct.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<bool>(
                title: const Text("With Whipped Cream (+£0.50)"),
                value: true,
                groupValue: withCream,
                onChanged: (val) => setState(() => withCream = val!),
              ),
              RadioListTile<bool>(
                title: const Text("Without Whipped Cream"),
                value: false,
                groupValue: withCream,
                onChanged: (val) => setState(() => withCream = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final creamCharge = withCream ? 0.50 : 0.0;
                final updated = Product(
                  id: baseProduct.id,
                  name: "${baseProduct.name}${withCream ? ' + Whipped Cream' : ''}",
                  price: baseProduct.price + creamCharge,
                  isVat: baseProduct.isVat,
                  category: baseProduct.category,
                  addOns: [withCream ? "Whipped Cream" : "No Cream"],
                  addOnsValue: creamCharge,
                );
                addToCart(updated);
                Navigator.pop(ctx);
              },
              child: const Text("Add to Cart"),
            ),
          ],
        );
      },
    ),
  );
}

Future<void> showPizzaOfferDialog(
  BuildContext context,
  String size,
  double offerPrice,
  List<Product> pizzaProducts,
  Function(Product) addToCart,
) async {
  List<Product> selectedPizzas = [];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: Text("🍕 3x $size Pizza Offer (£${offerPrice.toStringAsFixed(2)})"),
          content: SizedBox(
            width: 600,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select 3 Pizzas", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: pizzaProducts.map((pizza) {
                      final isSelected = selectedPizzas.contains(pizza);
                      return ChoiceChip(
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(pizza.name, style: const TextStyle(fontSize: 12)),
                            Text("£${pizza.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: Colors.deepOrange,
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedPizzas.remove(pizza);
                            } else {
                              if (selectedPizzas.length < 3) {
                                selectedPizzas.add(pizza);
                              } else {
                                selectedPizzas.removeAt(0);
                                selectedPizzas.add(pizza);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text("Selected: ${selectedPizzas.length}/3"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: selectedPizzas.length == 3
                  ? () {
                      final combined = Product(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: "Pizza Offer ($size)",
                        price: offerPrice,
                        isVat: true,
                        category: "Pizza Offer",
                        addOns: selectedPizzas.map((p) => p.name).toList(),
                        addOnsValue: 0.0,
                      );

                      addToCart(combined);
                      Navigator.pop(ctx);
                    }
                  : null,
              child: const Text("Add Offer to Cart"),
            ),
          ],
        );
      },
    ),
  );
}



Future<void> showFamilyOffer1Dialog(BuildContext context, List<Product> pizzaMenu, Function(Product) addToCart) async {
  List<Product> selectedPizzas = [];
  List<String> selectedDrinks = [];

  List<Map<String, dynamic>> burger1AddOns = [];
  List<Map<String, dynamic>> burger2AddOns = [];

  final List<String> drinkOptions = [
    'Pepsi Can',
    'Rubicon Mango',
    'Tango Orange',
    '7up Can',
    'Irn-Bru'
  ];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Family Offer 1 - £26.99"),
        content: SizedBox(
          width: 700,
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select 2x 12\" Pizzas", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: pizzaMenu.map((pizza) {
                    final isSelected = selectedPizzas.contains(pizza);
                    return ChoiceChip(
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(pizza.name, style: const TextStyle(fontSize: 12)),
                          Text("£${pizza.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: Colors.deepOrange,
                      onSelected: (_) {
                        setState(() {
                          if (isSelected) {
                            selectedPizzas.remove(pizza);
                          } else if (selectedPizzas.length < 2) {
                            selectedPizzas.add(pizza);
                          } else {
                            selectedPizzas.removeAt(0);
                            selectedPizzas.add(pizza);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("🍔 Burger 1 - Salads & Sauces (Zero VAT)", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: zeroVatAddOns.map((addon) {
                    final isSelected = burger1AddOns.contains(addon);
                    return FilterChip(
                      label: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            burger1AddOns.add(addon);
                          } else {
                            burger1AddOns.remove(addon);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("🍔 Burger 2 - Salads & Sauces (Zero VAT)", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: zeroVatAddOns.map((addon) {
                    final isSelected = burger2AddOns.contains(addon);
                    return FilterChip(
                      label: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            burger2AddOns.add(addon);
                          } else {
                            burger2AddOns.remove(addon);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("Select 4 Cans Drinks if no bottle available", style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Drink ${i + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: drinkOptions.map((drink) {
                            final selected = selectedDrinks.length > i && selectedDrinks[i] == drink;
                            return ChoiceChip(
                              label: Text(drink),
                              selected: selected,
                              selectedColor: Colors.deepOrange,
                              onSelected: (_) {
                                setState(() {
                                  if (selectedDrinks.length > i) {
                                    selectedDrinks[i] = drink;
                                  } else {
                                    selectedDrinks.add(drink);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: selectedPizzas.length == 2 && selectedDrinks.length == 4
                ? () {
                    final addonList1 = burger1AddOns.map((a) => "${a['name']} (£${a['price'].toStringAsFixed(2)})").toList();
                    final addonList2 = burger2AddOns.map((a) => "${a['name']} (£${a['price'].toStringAsFixed(2)})").toList();

                    final addonTotal = [
                      ...burger1AddOns,
                      ...burger2AddOns,
                    ].fold(0.0, (sum, a) => sum + (a['price'] as double));

                    final details = [
                      "2x 12\" Pizzas: ${selectedPizzas.map((e) => e.name).join(', ')}",
                      "Burger 1: ${addonList1.join(', ')}",
                      "Burger 2: ${addonList2.join(', ')}",
                      "Drinks: ${selectedDrinks.join(', ')}",
                      "5 Wings + 1 Large Fries"
                    ];

                    final offerProduct = Product(
                      id: -1,
                      name: "Family Offer 1",
                      price: 26.99,
                      isVat: true,
                      category: "Offers",
                      addOns: details,
                      addOnsValue: addonTotal,
                    );
                    addToCart(offerProduct);
                    Navigator.pop(ctx);
                  }
                : null,
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    ),
  );
}



Future<void> showFamilyOffer2Dialog(BuildContext context, List<Product> pizzaMenu, Function(Product) addToCart) async {
  List<Product> selectedPizzas = [];
  List<String> selectedDrinks = [];
  String? periPeriSide;
  List<Map<String, dynamic>> selectedAddOns = [];

  final List<String> sides = ['Naan', 'Fries', 'Rice', 'Masala Rice', 'Peri Peri Rice'];
  final List<String> drinkOptions = ['Pepsi Can', 'Rubicon Mango', 'Tango Orange', '7up Can', 'Irn-Bru'];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Family Offer 2 - £32.99"),
        content: SizedBox(
          width: 700,
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select 2x 12\" Pizzas", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: pizzaMenu.map((pizza) {
                    final isSelected = selectedPizzas.contains(pizza);
                    return ChoiceChip(
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(pizza.name, style: const TextStyle(fontSize: 12)),
                          Text("£${pizza.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: Colors.deepOrange,
                      onSelected: (_) {
                        setState(() {
                          if (isSelected) {
                            selectedPizzas.remove(pizza);
                          } else if (selectedPizzas.length < 2) {
                            selectedPizzas.add(pizza);
                          } else {
                            selectedPizzas.removeAt(0);
                            selectedPizzas.add(pizza);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("Peri Peri Chicken Served With", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: sides.map((side) {
                    return ChoiceChip(
                      label: Text(side),
                      selected: periPeriSide == side,
                      selectedColor: Colors.deepOrange,
                      onSelected: (_) => setState(() => periPeriSide = side),
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("Add Salads & Sauces for Chicken (Cold, Zero VAT)", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: zeroVatAddOns.map((addon) {
                    final isSelected = selectedAddOns.contains(addon);
                    return FilterChip(
                      label: Text("${addon['name']} (£${addon['price'].toStringAsFixed(2)})"),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            selectedAddOns.add(addon);
                          } else {
                            selectedAddOns.remove(addon);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const Divider(),
                const Text("Select 4 Drinks (can repeat same drink)", style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Drink ${i + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: drinkOptions.map((drink) {
                            final selected = selectedDrinks.length > i && selectedDrinks[i] == drink;
                            return ChoiceChip(
                              label: Text(drink),
                              selected: selected,
                              selectedColor: Colors.deepOrange,
                              onSelected: (_) {
                                setState(() {
                                  if (selectedDrinks.length > i) {
                                    selectedDrinks[i] = drink;
                                  } else {
                                    selectedDrinks.add(drink);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: selectedPizzas.length == 2 && selectedDrinks.length == 4 && periPeriSide != null
                ? () {
                    final addonNames = selectedAddOns.map((a) => "${a['name']} (£${a['price'].toStringAsFixed(2)})").toList();
                    final addonTotal = selectedAddOns.fold(0.0, (sum, a) => sum + (a['price'] as double));

                    final details = [
                      "2x 12\" Pizzas: ${selectedPizzas.map((e) => e.name).join(', ')}",
                      "Full Peri Peri Chicken with $periPeriSide",
                      if (addonNames.isNotEmpty) "Chicken Add-ons: ${addonNames.join(', ')}",
                      "Drinks: ${selectedDrinks.join(', ')}",
                      "5 Wings + 1 Large Fries"
                    ];

                    final offerProduct = Product(
                      id: -2,
                      name: "Family Offer 2",
                      price: 32.99,
                      isVat: true,
                      category: "Offers",
                      addOns: details,
                      addOnsValue: addonTotal,
                    );
                    addToCart(offerProduct);
                    Navigator.pop(ctx);
                  }
                : null,
            child: const Text("Add to Cart"),
          ),
        ],
      ),
    ),
  );
}







Future<void> showPizzaMealDialog(Product baseProduct) async {
  String? selectedCrust;
  String? selectedDrink;
  final List<String> selectedToppings = [];

  final List<String> crusts = ["Deep Pan", "Thin Crust"];

  final List<Map<String, dynamic>> toppings = [
    {'label': 'Cheese'},
    {'label': 'Onions'},
    {'label': 'Green Peppers'},
    {'label': 'Mushrooms'},
    {'label': 'Sweetcorn'},
    {'label': 'Fresh Chillies'},
    {'label': 'Jalapenos'},
    {'label': 'Spicy Chicken'},
    {'label': 'Pepperoni'},
    {'label': 'Ham'},
    {'label': 'Donner'},
  ];

  final List<Map<String, dynamic>> drinks = [
    {'name': 'Pepsi Can', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'Tango Orange', 'extra': 0.0},
    {'name': 'Rubicon Passion', 'extra': 0.0},
    {'name': 'Irn-Bru', 'extra': 0.0},
    {'name': 'Irn-Bru Extra', 'extra': 0.0},
    {'name': 'Rubicon Mango', 'extra': 0.0},
    {'name': 'San Pellegrino Lemon', 'extra': 0.5},
  ];

  // Size detection
  final bool is7Inch = baseProduct.name.contains('7"');
  final int freeToppings = is7Inch ? 2 : 3;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final int extraCount = selectedToppings.length - freeToppings;
        final double extraCharge = extraCount > 0 ? extraCount * 1.10 : 0.0;

        return AlertDialog(
          title: Text(baseProduct.name),
          content: SizedBox(
            height: 400,
            width: 500,
            child: Column(
              children: [
                if (!baseProduct.name.contains('7"') && !baseProduct.name.contains('9"')) ...[
  const Text("Select Crust"),
  Wrap(
    spacing: 8,
    children: crusts.map((crust) {
      return ChoiceChip(
        label: Text(crust),
        selected: selectedCrust == crust,
        onSelected: (_) => setState(() => selectedCrust = crust),
      );
    }).toList(),
  ),
  const SizedBox(height: 10),
  const Text("Select Drink"),
  Wrap(
    spacing: 8,
    children: drinks.map((drink) {
      final name = drink['name'] as String;
      final extra = drink['extra'] as double;
      return ChoiceChip(
        label: Text(extra > 0 ? "$name (+£${extra.toStringAsFixed(2)})" : name),
        selected: selectedDrink == name,
        onSelected: (_) {
          setState(() {
            selectedDrink = name;
double drinkExtra = 0.0;
          });
        },
      );
    }).toList(),
  ),
],

                const SizedBox(height: 10),
                const Text("Toppings"),
const SizedBox(height: 8),
Wrap(
  spacing: 10,
  runSpacing: 10,
  children: toppings.map((t) {
    final label = t['label'];
    final isSelected = selectedToppings.contains(label);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.deepOrange,
      onSelected: (_) {
        setState(() {
          if (isSelected) {
            selectedToppings.remove(label);
          } else {
            selectedToppings.add(label);
          }
        });
      },
    );
  }).toList(),
),
const SizedBox(height: 10),
Text("Extra Topping Charge: £${extraCharge.toStringAsFixed(2)}",
    style: const TextStyle(fontWeight: FontWeight.bold)),

                Text("Extra Topping Charge: £${extraCharge.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final drink = drinks.firstWhere((d) => d['name'] == selectedDrink, orElse: () => {'extra': 0.0});
                final drinkExtra = drink['extra'] ?? 0.0;

                final updated = Product(
                  id: baseProduct.id,
                  name: "${baseProduct.name} ($selectedCrust + $selectedDrink)",
                  price: baseProduct.price + extraCharge + drinkExtra,
                  isVat: baseProduct.isVat,
                  category: baseProduct.category,
                  addOns: [...selectedToppings, selectedDrink ?? "", selectedCrust ?? ""],
                  addOnsValue: extraCharge,
                );

                addToCart(updated);
                Navigator.pop(ctx);
              },
              child: const Text("Add to Cart"),
            ),
          ],
        );
      },
    ),
  );
}



Future<void> showPizzaDialog(Product baseProduct) async {
  String? selectedSize;
  String? selectedCrust;
  final List<String> selectedToppings = [];

  final Map<String, double> stuffcrustCharges = {
    '7"': 1.99,
    '9"': 1.99,
    '12"': 2.99,
    '14"': 3.49,
  };

  final List<Map<String, dynamic>> crustOptions = [
    {'label': 'Deep Pan'},
    {'label': 'Thin Crust'},
    {'label': 'Stuffed Crust'},
  ];

  

  // final List<Map<String, dynamic>> toppings = [
  //   {'label': 'Pineapple', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Mushroom', 'type': 'veg', 'price': 0.0},
  //   {'label': 'White Onion', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Red Onion', 'type': 'veg', 'price': 0.0},
  //       {'label': 'Green Pepper', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Black Olives', 'type': 'veg', 'price': 0.0},
  //   {'label': 'SweetCorn', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Fresh Tomatoes', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Cheese', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Chilli Powder', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Fresh Green Chillies', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Jalapenoes', 'type': 'veg', 'price': 0.0},
  //   {'label': 'Garlic Sauce', 'type': 'veg', 'price': 0.0},
  //   {'label': 'BBQ Sauce', 'type': 'veg', 'price': 0.0},

  //   {'label': 'Spicy Chicken', 'type': 'meat', 'price': 0.0},
  //   {'label': 'Spicy Beef', 'type': 'meat', 'price': 0.0},
  //       {'label': 'Pepperoni', 'type': 'meat', 'price': 0.0},
  //   {'label': 'Ham', 'type': 'meat', 'price': 0.0},
  //   {'label': 'Donner Before', 'type': 'meat', 'price': 0.0},
  //       {'label': 'Donner After', 'type': 'meat', 'price': 0.0},


  //   {'label': 'Prawns', 'type': 'sea', 'price': 0.0},
  //   {'label': 'Tuna', 'type': 'sea', 'price': 0.0},
  // ];
  final Map<String, Map<String, double>> menuPrices = {
  // PIZZAS
  'Cheese & Tomato': {'9"': 5.99, '12"': 8.49, '14"': 9.99},
  'Vegetarian Supreme': {'9"': 7.99, '12"': 9.99, '14"': 11.49},
  'Vegetarian Hot': {'9"': 7.99, '12"': 9.99, '14"': 11.49},
  'Hawaiian': {'9"': 7.99, '12"': 9.99, '14"': 11.99},
  'Mexican Heatwave': {'9"': 7.99, '12"': 10.99, '14"': 12.49},
  'BBQ Deluxe': {'9"': 7.99, '12"': 10.99, '14"': 12.49},
  'Hot & Spicy': {'9"': 7.99, '12"': 10.99, '14"': 12.49},
  'Meat Feast': {'9"': 8.99, '12"': 11.99, '14"': 13.99},
  'Meat Feast Deluxe': {'9"': 8.99, '12"': 11.99, '14"': 13.99},
  'Pepperoni Special': {'9"': 8.99, '12"': 11.99, '14"': 13.99},
  'Grill Corner Special': {'9"': 8.99, '12"': 11.99, '14"': 13.99},

  // CALZONES
  'Mixed Grill Calzone': {'9"': 10.99, '12"': 13.99, '14"': 15.99},
  'Donner Calzone': {'9"': 9.99, '12"': 12.99, '14"': 14.99},
  "Pick'n' Mix Calzone": {'9"': 10.49, '12"': 13.49, '14"': 15.49},
};

final List<Map<String, dynamic>> baseOptions = [
  {'name': 'Naan', 'price': 0.00},
  {'name': 'Fries', 'price': 0.00},
  {'name': 'Garlic Naan', 'price': 0.50},
  {'name': 'Plain Rice', 'price': 0.00},
  {'name': 'Peri Peri Rice', 'price': 0.00},
  {'name': 'Masala Rice', 'price': 0.00},
];




  final List<Map<String, dynamic>> extraToppings = [
   {'label': 'Pineapple', 'type': 'veg', 'price': 1.10},
  {'label': 'Mushroom', 'type': 'veg', 'price': 1.10},
  {'label': 'White Onion', 'type': 'veg', 'price': 1.10},
  {'label': 'Red Onion', 'type': 'veg', 'price': 1.10},
  {'label': 'Green Pepper', 'type': 'veg', 'price': 1.10},
  {'label': 'Black Olives', 'type': 'veg', 'price': 1.10},
  {'label': 'SweetCorn', 'type': 'veg', 'price': 1.10},
  {'label': 'Fresh Tomatoes', 'type': 'veg', 'price': 1.10},
  {'label': 'Cheese', 'type': 'veg', 'price': 1.10},
  {'label': 'Chilli Powder', 'type': 'veg', 'price': 1.10},
  {'label': 'Fresh Green Chillies', 'type': 'veg', 'price': 1.10},
  {'label': 'Jalapenoes', 'type': 'veg', 'price': 1.10},
  {'label': 'Garlic Sauce', 'type': 'veg', 'price': 1.10},
  {'label': 'BBQ Sauce', 'type': 'veg', 'price': 1.10},

  {'label': 'Spicy Chicken', 'type': 'meat', 'price': 1.10},
  {'label': 'Spicy Beef', 'type': 'meat', 'price': 1.10},
  {'label': 'Pepperoni', 'type': 'meat', 'price': 1.10},
  {'label': 'Ham', 'type': 'meat', 'price': 1.10},
  {'label': 'Donner Before', 'type': 'meat', 'price': 1.10},
  {'label': 'Donner After', 'type': 'meat', 'price': 1.10},

  {'label': 'Prawns', 'type': 'sea', 'price': 1.10},
  {'label': 'Tuna', 'type': 'sea', 'price': 1.10},
  ];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final double extraCharge = selectedToppings.fold(0.0, (sum, t) {
          final match = extraToppings.firstWhere((top) => top['label'] == t, orElse: () => {'price': 0.0});
          return sum + (match['price'] as double);
        });

        return AlertDialog(
          title: const Text("🍕 Customize Pizza"),
          content: SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.8,
            height: 400,
            child: Row(
              children: [
                // LEFT - Toppings
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Extra Toppings (+£)", style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: ListView(
children: [
  Wrap(
    spacing: 8,
    runSpacing: 6,
    children: extraToppings.map((top) {
      final label = top['label'] as String;
      final display = "$label (£${top['price'].toStringAsFixed(2)})";
      final isSelected = selectedToppings.contains(label);

      return ChoiceChip(
        label: Text(display, style: const TextStyle(color: Colors.orange)),
        selected: isSelected,
        selectedColor: Colors.deepOrange,
        onSelected: (_) {
          setState(() {
            if (isSelected) {
              selectedToppings.remove(label);
            } else {
              selectedToppings.add(label);
            }
          });
        },
      );
    }).toList(),
  )
],

                        ),
                      ),
                    ],
                  ),
                ),

                const VerticalDivider(),

                // RIGHT - Size and Crust
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: stuffcrustCharges.keys.map((size) {
                          return ChoiceChip(
                            label: Text(size),
                            selected: selectedSize == size,
                            selectedColor: Colors.deepOrange,
                            onSelected: (_) => setState(() => selectedSize = size),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text("Select Crust", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: crustOptions.map((crust) {
                          final label = crust['label']!;
                          return ChoiceChip(
                            label: Text(label),
                            selected: selectedCrust == label,
                            selectedColor: Colors.deepOrange,
                            onSelected: (_) => setState(() => selectedCrust = label),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      Text("Extra Charge: £${extraCharge.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: selectedSize != null && selectedCrust != null
                  ? () {
                      final basePrice = baseProduct.price;
                      final stuffedCrustPrice = selectedCrust == 'Stuffed Crust'
                          ? (stuffcrustCharges[selectedSize!] ?? 0.0)
                          : 0.0;

                      final totalPrice = basePrice + stuffedCrustPrice + extraCharge;

                      final updated = Product(
                        id: baseProduct.id,
                        name: "${baseProduct.name} ($selectedSize, $selectedCrust)",
                        price: totalPrice,
                        isVat: baseProduct.isVat,
                        category: baseProduct.category,
                        addOns: selectedToppings,
                        addOnsValue: extraCharge,
                      );

                      addToCart(updated);
                      Navigator.pop(ctx);
                    }
                  : null,
              child: const Text("Add to Cart"),
            ),
          ],
        );
      },
    ),
  );
}

  void addToCart(Product product) {
    setState(() {
      orderCart.add(product);
    });
  }

  void clearOrder() {
    setState(() {
      orderCart.clear();
      orderType = null;
      paymentMethod = null;
      deliveryAddress = null;
    });
  }

  void pollForCallerId() async {
    while (mounted) {
      try {
        final response = await http.get(Uri.parse('http://localhost:5000/caller_id'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['number'] != null && data['number'] != incomingCallerId) {
            setState(() {
              incomingCallerId = data['number'];
              phoneController.text = data['number'];
            });
          }
        }
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  void handlePhoneSearch() async {
  final number = phoneController.text.trim();
  if (number.isEmpty) return;

  final customer = await db.getCustomerByPhone(number);
  if (customer != null) {
    setState(() {
      deliveryAddress = "${customer.name}, ${customer.address}";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Found: ${customer.name}, ${customer.address}")),
    );
  } else {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerFormScreen(phone: number),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        deliveryAddress = result;
      });
    }
  }
}


 void openCustomerAddressSearch() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CustomerSearchScreen(),
    ),
  );

  if (result != null && result is Map<String, String>) {
    setState(() {
      deliveryAddress = "${result['name']}, ${result['address']}";
      phoneController.text = result['phone']!;
    });
  }
}


//   @override
//   Widget build(BuildContext context) {
//     final grouped = <String, List<Product>>{};
//     for (var product in allProducts) {
//       if (product.name.toLowerCase().contains(searchQuery.toLowerCase())) {
//         grouped.putIfAbsent(product.category, () => []).add(product);
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("EPOS PRO - Grill Corner")),
//       body: Row(
//         children: [
//           // Left Panel
//           Expanded(
//             flex: 2,
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         incomingCallerId != null
//                             ? "📞 Incoming Call: $incomingCallerId"
//                             : "📞 No incoming call detected",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: phoneController,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone Number',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               icon: const Icon(Icons.person_search),
//                               label: const Text("Search / Add Customer"),
//                               onPressed: handlePhoneSearch,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton.icon(
//                             icon: const Icon(Icons.search),
//                             label: const Text("Find by Postcode"),
//                             onPressed: openCustomerAddressSearch,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.receipt_long),
//                         label: const Text("View Sales"),
//                         onPressed: () => Navigator.pushNamed(context, '/sales'),
//                       ),
//                       const SizedBox(height: 12),
//                       TextField(
//                         decoration: const InputDecoration(
//                           labelText: 'Search items...',
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (val) {
//                           setState(() => searchQuery = val);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 ...grouped.entries.map((entry) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: Text(
//                           entry.key,
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       ...entry.value.map((product) => ListTile(
//                             title: Text(product.name),
//                             subtitle: Text("£${product.price.toStringAsFixed(2)}"),
//                             trailing: Text(
//                               product.isVat ? "VAT 20%" : "No VAT",
//                               style: TextStyle(
//                                 color: product.isVat ? Colors.red : Colors.green[700],
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             onTap: () async {
// if (["Grill", "Sizzlers", "Donner", "Peri Peri Chicken"].contains(product.category)) {
//     final result = await showBaseDialog(context);
// if (result == null) return;

// final base = result['base'];
// final addons = result['addons'] as List<Map<String, dynamic>>;
// final addonTotal = result['addonTotal'] as double;

// final addonNames = addons.map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})").toList();

// final selectedProduct = Product(
//   id: product.id,
//   name: "${product.name} + ${base['name']}",
//   price: product.price + (base['price'] as double),
//   isVat: product.isVat,
//   category: product.category,
//   addOns: addonNames,
//   addOnsValue: addonTotal,
// );

// addToCart(selectedProduct);

//   } else if (["Pizza", "Calzone"].contains(product.category)) {
//     await showPizzaDialog(product);
//   } else if (["Wraps", "Burger"].contains(product.category)) {
//   final result = await showWrapBurgerMealDialog(context);
//   if (result != null) {
//     final addons = result['addons'] as List<Map<String, dynamic>>;
//     final addonTotal = result['addonTotal'] as double;
//     final mealExtra = result['mealExtra'] as double;
//     final drink = result['drink'] as String?;

//     final List<String> addonNames = addons
//         .map((e) => "${e['name']} (£${e['price'].toStringAsFixed(2)})")
//         .toList();
//     if (drink != null) {
//       addonNames.add("Drink: $drink");
//     }

//     final customized = Product(
//       id: product.id,
//       name: "${product.name}${drink != null ? ' + Meal' : ''}",
//       price: product.price + mealExtra,
//       isVat: product.isVat,
//       category: product.category,
//       addOns: addonNames,
//       addOnsValue: addonTotal,
//     );

//     addToCart(customized);
//   }
// }else if (product.name.contains("Nuggets Meal")) {
//   await showNuggetsMealDialog(product);
// }else if (product.name.contains("Pizza Meal")) {
//   await showPizzaMealDialog(product);
// }

// else if (product.category == "Milkshakes") {
//   await showMilkshakeDialog(product);
// }
// else if (product.name.contains("Chicken Nuggets Meal") || product.name.contains("Popcorn Chicken Meal")) {
//   await showNuggetsMealDialog(product);
// }
// else if (product.name.contains('12" Pizza Offer')) {
// await showPizzaOfferDialog(
//   context,
//   '12"',
//   24.99,
//   allProducts.where((p) => p.category == "Pizza").toList(), // or filtered pizza list
//   addToCart
// );
// } else if (product.name.contains('14" Pizza Offer')) {
// await showPizzaOfferDialog(
//   context,
//   '14"',
//   29.99,
//   allProducts.where((p) => p.category == "Pizza").toList(),
//   addToCart
// );
// }
// else if (product.name.contains("Family Offer 1")) {
// await showFamilyOffer1Dialog(context, allProducts.where((p) => p.category == "Pizza").toList(), addToCart);
// }
// else if (product.name.contains("Family Offer 2")) {
// await showFamilyOffer2Dialog(context, allProducts.where((p) => p.category == "Pizza").toList(), addToCart);
// }

//  else if (product.name.contains("Wrap Meal")) {
//   await showWrapMealDialog(product);
// }

// else {
//     addToCart(product);
//   }
// },


    
//                           ))
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),

//           const VerticalDivider(),
//           // Right Panel - Cart
//           Expanded(
//             flex: 1,
//             child: _buildCartSection(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCartSection() {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//           const Text("🧾 Order Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orderCart.length,
//               itemBuilder: (_, index) {
//                 final item = orderCart[index];
//                 return ListTile(
//                   title: Text(item.name),
//                   subtitle: item.addOns != null && item.addOns!.isNotEmpty
//                       ? Text("With: ${item.addOns!.join(', ')}")
//                       : null,
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("£${item.price.toStringAsFixed(2)}"),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => setState(() => orderCart.removeAt(index)),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text("Total: £${total.toStringAsFixed(2)}"),
//               Text("Zero-rated total: £${zeroRatedTotal.toStringAsFixed(2)}"),
//               Text("VATable subtotal: £${(total - zeroRatedTotal).toStringAsFixed(2)}"),
//               Text("VAT (20%): £${vat.toStringAsFixed(2)}"),
//               Text("Net Sales: £${net.toStringAsFixed(2)}"),
//               DropdownButtonFormField<String>(
//                 value: orderType,
//                 decoration: const InputDecoration(labelText: 'Order Type'),
//                 items: ['Collection', 'Delivery'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
//                 onChanged: (value) => setState(() => orderType = value),
//               ),
//               if (orderType == 'Delivery')
//                 TextFormField(
//                   initialValue: deliveryAddress,
//                   decoration: InputDecoration(
//                     labelText: 'Delivery Address',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.location_searching),
//                       onPressed: openCustomerAddressSearch,
//                     ),
//                   ),
//                   minLines: 2,
//                   maxLines: 3,
//                   onChanged: (value) => deliveryAddress = value,
//                 ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: paymentMethod,
//                 decoration: const InputDecoration(labelText: 'Payment Method'),
//                 items: ['Cash', 'Card', 'Bank Transfer'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
//                 onChanged: (value) => setState(() => paymentMethod = value),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   if (orderCart.isEmpty || orderType == null || paymentMethod == null || (orderType == 'Delivery' && (deliveryAddress == null || deliveryAddress!.isEmpty))) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Please fill all order fields")),
//                     );
//                     return;
//                   }

//                   final items = orderCart.map((e) {
//                     final addonText = (e.addOns != null && e.addOns!.isNotEmpty) ? "With: ${e.addOns!.join(', ')}" : "";
//                     return "${e.name} $addonText";
//                   }).join(', ');

//                   final now = DateTime.now().toIso8601String().substring(0, 16);

//                   await db.saveOrder(
//                     items: items,
//                     total: total,
//                     vat: vat,
//                     net: net,
//                     date: now,
//                     orderType: orderType!,
//                     paymentMethod: paymentMethod!,
//                     address: orderType == 'Delivery' ? deliveryAddress! : 'N/A',
//                   );

//                   clearOrder();
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order saved!")));
//                 },
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save Order"),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton.icon(
//                 onPressed: clearOrder,
//                 icon: const Icon(Icons.delete_forever),
//                 label: const Text("Clear Order"),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Note: Cold food add-ons (salads/sauces) are zero-rated and excluded from VAT.",
//                 style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

@override
Widget build(BuildContext context) {
  final grouped = <String, List<Product>>{};
  final Set<String> allCategories = allProducts.map((p) => p.category).toSet();

  for (var product in allProducts) {
    final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
    if (matchesSearch && matchesCategory) {
      grouped.putIfAbsent(product.category, () => []).add(product);
    }
  }

  return Scaffold(
    appBar: AppBar(title: const Text("EPOS PRO - Grill Corner")),
    body: Row(
      children: [
        // Left Panel - Products + Customer
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // Phone and customer actions
              Text(
                incomingCallerId != null
                    ? "\ud83d\udcde Incoming Call Detected: $incomingCallerId"
                    : "\ud83d\udcde No Incoming Call",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Auto/Manual)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_search),
                      label: const Text("Search / Add Customer"),
                      onPressed: handlePhoneSearch,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text("Find by Postcode"),
                    onPressed: openCustomerAddressSearch,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                icon: const Icon(Icons.receipt_long),
                label: const Text("View Sales"),
                onPressed: () => Navigator.pushNamed(context, '/sales'),
              ),
              const Divider(),

              // Search and filter
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Category',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: ['All', ...allCategories]
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedCategory = value!),
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Product listings
              ...grouped.entries.map((entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...entry.value.map((product) => ListTile(
                            title: Text(product.name),
                            subtitle: Text("\u00a3${product.price.toStringAsFixed(2)}"),
                            trailing: Text(
                              product.isVat ? "VAT 20%" : "No VAT",
                              style: TextStyle(
                                color: product.isVat ? Colors.red : Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async => await handleProductTap(product),
                          )),
                    ],
                  )),
            ],
          ),
        ),

        const VerticalDivider(),

        // Right Panel - Cart
        Expanded(
          flex: 1,
          child: _buildCartSection(),
        ),
      ],
    ),
  );
}
}