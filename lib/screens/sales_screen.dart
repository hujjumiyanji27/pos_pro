// // import 'package:flutter/material.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:csv/csv.dart';
// // import 'dart:io';
// // import '../db/db_helper.dart';

// // class SalesScreen extends StatefulWidget {
// //   const SalesScreen({super.key});

// //   @override
// //   State<SalesScreen> createState() => _SalesScreenState();
// // }

// // class _SalesScreenState extends State<SalesScreen> {
// //   final DBHelper db = DBHelper();
// //   List<Map<String, dynamic>> orders = [];
// //   DateTimeRange? selectedDateRange;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchOrders();
// //   }

// //   Future<void> pickDateRange() async {
// //     final picked = await showDateRangePicker(
// //       context: context,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null) {
// //       setState(() => selectedDateRange = picked);
// //       fetchOrders();
// //     }
// //   }
// //   List<pw.Widget> _buildItemLines(String raw) {
// //   final lines = <pw.Widget>[];
// //   final parts = raw.split(',');

// //   for (var item in parts) {
// //     final trimmed = item.trim();
// //     final match = RegExp(r'(.*?)(?:\s*\(£([0-9.]+)\))?$').firstMatch(trimmed);
// //     final name = match?.group(1)?.trim() ?? trimmed;
// //     final price = match?.group(2);

// //     lines.add(
// //       pw.Row(
// //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //         children: [
// //           pw.Expanded(child: pw.Text(name, style: const pw.TextStyle(fontSize: 8))),
// //           if (price != null) pw.Text("£$price", style: const pw.TextStyle(fontSize: 8)),
// //         ],
// //       ),
// //     );
// //   }

// //   return lines;
// // }

// // Future<void> printSingleOrder(Map<String, dynamic> order) async {
// //   final addOnTotal = extractAddOnTotal(order['items']);
// //   final vatableSubtotal = (order['total'] as double) - addOnTotal;
// //   final vat = vatableSubtotal * (1 - (1 / 1.2));
// //   final net = (order['total'] as double) - vat;

// //   final pdf = pw.Document();

// //   pdf.addPage(
// //     pw.Page(
// //       pageFormat: PdfPageFormat(58 * PdfPageFormat.mm, double.infinity),
// //       margin: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
// //       build: (context) {
// //         return pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Center(
// //               child: pw.Text("GRILL CORNER",
// //                 style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
// //             ),
// //             pw.SizedBox(height: 4),
// //             pw.Divider(),
// //             pw.Text("Order ID: ${order['id']}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.Text("Date: ${order['date']}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.SizedBox(height: 5),
// //             pw.Text("Items:", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
// //             pw.SizedBox(height: 2),
// //             ..._buildItemLines(order['items']),
// //             pw.SizedBox(height: 6),
// //             if (order['orderType'] != null)
// //               pw.Text("Type: ${order['orderType']}", style: const pw.TextStyle(fontSize: 8)),
// //             if (order['paymentMethod'] != null)
// //               pw.Text("Payment: ${order['paymentMethod']}", style: const pw.TextStyle(fontSize: 8)),
// //             if (order['address'] != null && order['address'].toString().isNotEmpty)
// //               pw.Column(children: [
// //                 pw.Text("Address:", style: const pw.TextStyle(fontSize: 8)),
// //                 pw.Text("${order['address']}", style:  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
// //               ]),
// //             pw.Divider(),
// //             pw.Text("Breakdown", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
// //             pw.Text("Total (inc VAT): £${(order['total'] as double).toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.Text("Zero-rated (0%): £${addOnTotal.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.Text("VATable: £${vatableSubtotal.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.Text("VAT (20%): £${vat.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.Text("Net (ex VAT): £${net.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
// //             pw.SizedBox(height: 4),
// //             pw.Divider(),
// //             pw.Center(child: pw.Text("Thank You!", style: const pw.TextStyle(fontSize: 9))),
// //           ],
// //         );
// //       },
// //     ),
// //   );

// //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
// // }

// //   Future<void> fetchOrders() async {
// //     final data = await db.getAllOrders();
// //     if (selectedDateRange != null) {
// //       orders = data.where((order) {
// //         final orderDate = DateTime.parse(order['date']);
// //         return orderDate.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
// //             orderDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
// //       }).toList();
// //     } else {
// //       orders = data;
// //     }
// //     setState(() {});
// //   }

// //   double extractAddOnTotal(String items) {
// //     final addonMatches = RegExp(r'\(£([0-9.]+)\)').allMatches(items);
// //     return addonMatches.fold(0.0, (sum, match) {
// //       final price = double.tryParse(match.group(1) ?? '0') ?? 0;
// //       return sum + price;
// //     });
// //   }
// // void showOrderOptions(BuildContext context, Map<String, dynamic> order) {
// //   final addOnTotal = extractAddOnTotal(order['items']);
// //   final vatableSubtotal = (order['total'] as double) - addOnTotal;
// //   final vat = vatableSubtotal * (1 - (1 / 1.2));
// //   final net = (order['total'] as double) - vat;

// //   showDialog(
// //     context: context,
// //     builder: (_) => AlertDialog(
// //       title: const Text("Order Options"),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("Order ID: ${order['id']}"),
// //             Text("Date: ${order['date'].substring(0, 10)}"),
// //             Text("Items:\n${order['items']}"),
// //             const SizedBox(height: 10),
// //             Text("💰 Breakdown:"),
// //             Text("Total (inc VAT): £${(order['total'] as double).toStringAsFixed(2)}"),
// //             Text("Zero-rated (0%): £${addOnTotal.toStringAsFixed(2)}"),
// //             Text("VATable subtotal: £${vatableSubtotal.toStringAsFixed(2)}"),
// //             Text("VAT (20%): £${vat.toStringAsFixed(2)}"),
// //             Text("Net Sales (ex VAT): £${net.toStringAsFixed(2)}"),
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         TextButton.icon(
// //           icon: const Icon(Icons.picture_as_pdf),
// //           label: const Text("Export PDF"),
// //           onPressed: () async {
// //             Navigator.pop(context);
// //             await exportAllToPDF(); // ensure this is also defined
// //           },
// //         ),
// //         TextButton.icon(
// //           icon: const Icon(Icons.delete, color: Colors.red),
// //           label: const Text("Delete", style: TextStyle(color: Colors.red)),
// //           onPressed: () async {
// //             await db.deleteOrder(order['id']);
// //             Navigator.pop(context);
// //             fetchOrders();
// //           },
// //         ),
// //         TextButton(
// //           child: const Text("Close"),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ],
// //     ),
// //   );
// // }

// //   Map<String, Map<String, dynamic>> getItemSummary(List<Map<String, dynamic>> orders) {
// //     final summary = <String, Map<String, dynamic>>{};
// //     for (var order in orders) {
// //       final items = order['items'].split(',');
// //       for (var item in items) {
// //         final cleaned = item.trim();
// //         final match = RegExp(r'^(.*?)(?:\s*\(£([\d.]+)\))?$').firstMatch(cleaned);
// //         if (match != null) {
// //           final name = match.group(1)!.trim();
// //           final price = double.tryParse(match.group(2) ?? '0') ?? 0;
// //           if (!summary.containsKey(name)) {
// //             summary[name] = {'quantity': 1, 'total': price};
// //           } else {
// //             summary[name]!['quantity'] += 1;
// //             summary[name]!['total'] += price;
// //           }
// //         }
// //       }
// //     }
// //     return summary;
// //   }

// //   Future<void> exportCSV() async {
// //     final rows = [
// //       ['Order ID', 'Items', 'Total', 'Zero-rated (0%)', 'VATable', 'VAT (20%)', 'Net (ex VAT)', 'Date'],
// //       ...orders.map((o) {
// //         final addOnTotal = extractAddOnTotal(o['items']);
// //         final vatableSubtotal = (o['total'] as double) - addOnTotal;
// //         final vat = vatableSubtotal * (1 - (1 / 1.2));
// //         final net = (o['total'] as double) - vat;
// //         return [
// //           o['id'].toString(),
// //           o['items'],
// //           o['total'].toStringAsFixed(2),
// //           addOnTotal.toStringAsFixed(2),
// //           vatableSubtotal.toStringAsFixed(2),
// //           vat.toStringAsFixed(2),
// //           net.toStringAsFixed(2),
// //           o['date'],
// //         ];
// //       }),
// //     ];

// //     final itemSummary = getItemSummary(orders);
// //     rows.add([]);
// //     rows.add(['Item Summary']);
// //     rows.add(['Item', 'Qty', 'Total']);
// //     itemSummary.forEach((item, data) {
// //       rows.add([item, data['quantity'].toString(), data['total'].toStringAsFixed(2)]);
// //     });

// //     final csv = const ListToCsvConverter().convert(rows);
// //     final downloads = Directory('${Platform.environment['USERPROFILE']}\\Downloads');
// //     final file = File("${downloads.path}/sales_report.csv");
// //     await file.writeAsString(csv);
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CSV exported to ${file.path}")));
// //   }

// //   Future<void> exportAllToPDF() async {
// //     final pdf = pw.Document();
// //     final itemSummary = getItemSummary(orders);

// //     double totalSales = orders.fold(0, (sum, o) => sum + (o['total'] as double));
// //     double totalZeroRated = orders.fold(0, (sum, o) => sum + extractAddOnTotal(o['items']));
// //     double totalVat = totalSales - totalZeroRated;
// //     double netSales = totalSales - (totalVat * (1 - (1 / 1.2)));

// //     pdf.addPage(
// //       pw.MultiPage(
// //         build: (context) => [
// //           pw.Text("Sales Report - Grill Corner", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),

// //           // Summary Table
// //           pw.Table(
// //             border: pw.TableBorder.all(),
// //             children: [
// //               _tableRow("Total Sales (£)", totalSales.toStringAsFixed(2)),
// //               _tableRow("Zero-rated (0%)", totalZeroRated.toStringAsFixed(2)),
// //               _tableRow("VAT (20%)", (totalVat * (1 - (1 / 1.2))).toStringAsFixed(2)),
// //               _tableRow("Net Sales (ex VAT)", netSales.toStringAsFixed(2)),
// //             ],
// //           ),

// //           pw.SizedBox(height: 15),

// //           ...orders.map((order) {
// //             final addOnTotal = extractAddOnTotal(order['items']);
// //             final vatableSubtotal = (order['total'] as double) - addOnTotal;
// //             final vat = vatableSubtotal * (1 - (1 / 1.2));
// //             final net = (order['total'] as double) - vat;
// //             return pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.start,
// //               children: [
// //                 pw.Text("Order ID: ${order['id']}"),
// //                 pw.Text("Date: ${order['date']}"),
// //                 pw.Text("Items: ${order['items']}"),
// //                 pw.Text("Zero-rated: £${addOnTotal.toStringAsFixed(2)}"),
// //                 pw.Text("VATable: £${vatableSubtotal.toStringAsFixed(2)}"),
// //                 pw.Text("VAT (20%): £${vat.toStringAsFixed(2)}"),
// //                 pw.Text("Net (ex VAT): £${net.toStringAsFixed(2)}"),
// //                 pw.Text("Total: £${(order['total'] as double).toStringAsFixed(2)}"),
// //                 pw.Divider(),
// //               ],
// //             );
// //           }),

// //           pw.SizedBox(height: 20),
// //           pw.Text("Item Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.Table(
// //             border: pw.TableBorder.all(),
// //             children: [
// //               pw.TableRow(
// //                 children: [
// //                   _cell("Item", bold: true),
// //                   _cell("Qty", bold: true),
// //                   _cell("Total (£)", bold: true),
// //                 ],
// //               ),
// //               ...itemSummary.entries.map((e) {
// //                 return pw.TableRow(
// //                   children: [
// //                     _cell(e.key),
// //                     _cell("${e.value['quantity']}"),
// //                     _cell("£${e.value['total'].toStringAsFixed(2)}"),
// //                   ],
// //                 );
// //               })
// //             ],
// //           ),
// //         ],
// //       ),
// //     );

// //     await Printing.sharePdf(bytes: await pdf.save(), filename: 'sales_report.pdf');
// //   }

// //   pw.TableRow _tableRow(String label, String value) {
// //     return pw.TableRow(children: [
// //       pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
// //       pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(value)),
// //     ]);
// //   }

// //   pw.Widget _cell(String text, {bool bold = false}) {
// //     return pw.Padding(
// //       padding: pw.EdgeInsets.all(5),
// //       child: pw.Text(text, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double totalSales = orders.fold(0, (sum, o) => sum + (o['total'] as double));
// //     double totalZeroRated = orders.fold(0, (sum, o) => sum + extractAddOnTotal(o['items']));
// //     double totalVat = totalSales - totalZeroRated;
// //     double netSales = totalSales - (totalVat * (1 - (1 / 1.2)));

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Sales Report"),
// //         actions: [
// //           IconButton(icon: const Icon(Icons.date_range), onPressed: pickDateRange),
// //           IconButton(icon: const Icon(Icons.download), onPressed: exportCSV),
// //           IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: exportAllToPDF),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           const SizedBox(height: 12),
// //           Text("Total Sales: £${totalSales.toStringAsFixed(2)}"),
// //           Text("Zero-rated: £${totalZeroRated.toStringAsFixed(2)}"),
// //           Text("VAT (20%): £${(totalVat * (1 - (1 / 1.2))).toStringAsFixed(2)}"),
// //           Text("Net Sales: £${netSales.toStringAsFixed(2)}"),
// //           const Divider(),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: orders.length,
// //               itemBuilder: (_, i) {
// //                 final o = orders[i];
// //                 return ListTile(
// //                   title: Text("🧾 ${o['items']}"),
// //                   subtitle: Text("Date: ${o['date']}"),
// //                   trailing: Text("£${(o['total'] as double).toStringAsFixed(2)}"),
// //                   onTap: () => showOrderOptions(context, o),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:csv/csv.dart';
// import 'dart:io';
// import '../db/db_helper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class SalesScreen extends StatefulWidget {
//   const SalesScreen({super.key});

//   @override
//   State<SalesScreen> createState() => _SalesScreenState();
// }

// class _SalesScreenState extends State<SalesScreen> {
//   final DBHelper db = DBHelper();
//   List<Map<String, dynamic>> orders = [];
//   DateTimeRange? selectedDateRange;

//  @override
// void initState() {
//   super.initState();
//   fetchOrders();

//   FirebaseFirestore.instance
//       .collection('orders')
//       .orderBy('createdAt', descending: true)
//       .snapshots()
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         final order = change.doc.data();
//         print("🔔 New Order: ${order?['customerName']}");
//         // Add your notification logic here
//       }
//     }
//   });
// }


//   Future<void> pickDateRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() => selectedDateRange = picked);
//       fetchOrders();
//     }
//   }
  

//   Future<void> updateOrderStatus(String docId, String status, String estimateTime) async {
//   await FirebaseFirestore.instance.collection('orders').doc(docId).update({
//     'status': status,
//     'estimatedTime': estimateTime,
//   });
// }


//   Future<void> fetchOrders() async {
//     final data = await db.getAllOrders();
//     if (selectedDateRange != null) {
//       orders = data.where((order) {
//         final orderDate = DateTime.parse(order['date']);
//         return orderDate.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
//             orderDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
//       }).toList();
//     } else {
//       orders = data;
//     }
//     setState(() {});
//   }

//   double extractAddOnTotal(String items) {
//     final addonMatches = RegExp(r'\(£([0-9.]+)\)').allMatches(items);
//     return addonMatches.fold(0.0, (sum, match) {
//       final price = double.tryParse(match.group(1) ?? '0') ?? 0;
//       return sum + price;
//     });
//   }

//  List<pw.Widget> _buildItemLines(String raw) {
//   final lines = <pw.Widget>[];
//   final parts = raw.split(',');

//   for (var item in parts) {
//     final trimmed = item.trim();
//     final match = RegExp(r'(.*?)(?:\s*\(£([0-9.]+)\))?$').firstMatch(trimmed);
//     final name = match?.group(1)?.trim() ?? trimmed;
//     final price = match?.group(2);

//     lines.add(
//       pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Expanded(child: pw.Text(name, style: pw.TextStyle(fontSize: 8))),
//           if (price != null)
//             pw.Text("£$price", style: pw.TextStyle(fontSize: 8)),
//         ],
//       ),
//     );

//     // Add a dotted line below each item
//     lines.add(
//       pw.Text(
//         "··············································",
//         style: pw.TextStyle(fontSize: 6),
//       ),
//     );
//   }

//   return lines;
// }


//   Future<void> printSingleOrder(Map<String, dynamic> order) async {
//     final addOnTotal = extractAddOnTotal(order['items']);
//     final vatableSubtotal = (order['total'] as double) - addOnTotal;
//     final vat = vatableSubtotal * (1 - (1 / 1.2));
//     final net = (order['total'] as double) - vat;

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat(88 * PdfPageFormat.mm, double.infinity),
//         margin: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//         build: (context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Center(child: pw.Text("GRILL CORNER", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
//             pw.SizedBox(height: 4),
//             pw.Divider(),
//             pw.Text("Order ID: ${order['id']}", style: pw.TextStyle(fontSize: 8)),
//             pw.Text("Date: ${order['date']}", style: pw.TextStyle(fontSize: 8)),
//             pw.SizedBox(height: 5),
//             pw.Text("Items:", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 2),
//             ..._buildItemLines(order['items']),
//             pw.SizedBox(height: 6),
//             if (order['orderType'] != null)
//               pw.Text("Type: ${order['orderType']}", style: pw.TextStyle(fontSize: 8)),
//             if (order['paymentMethod'] != null)
//               pw.Text("Payment: ${order['paymentMethod']}", style: pw.TextStyle(fontSize: 8)),
//             if (order['address'] != null && order['address'].toString().isNotEmpty)
//               pw.Column(children: [
//                 pw.Text("Address:", style: pw.TextStyle(fontSize: 8)),
//                 pw.Text("${order['address']}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
//               ]),
//             pw.Divider(),
//             pw.Text("Breakdown", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
//             pw.Text("Total (inc VAT): £${(order['total'] as double).toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8)),
//             pw.Text("Zero-rated (0%): £${addOnTotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8)),
//             pw.Text("VATable: £${vatableSubtotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8)),
//             pw.Text("VAT (20%): £${vat.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8)),
//             pw.Text("Net (ex VAT): £${net.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 8)),
//             pw.SizedBox(height: 4),
//             pw.Divider(),
//             pw.Center(child: pw.Text("Thank You!", style: pw.TextStyle(fontSize: 9))),
//           ],
//         ),
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   Future<void> exportAllToPDF() async {
//     final pdf = pw.Document();
//     final itemSummary = getItemSummary(orders);

//     double totalSales = orders.fold(0, (sum, o) => sum + (o['total'] as double));
//     double totalZeroRated = orders.fold(0, (sum, o) => sum + extractAddOnTotal(o['items']));
//     double totalVat = totalSales - totalZeroRated;
//     double netSales = totalSales - (totalVat * (1 - (1 / 1.2)));

//     pdf.addPage(
//       pw.MultiPage(
//         build: (context) => [
//           pw.Text("Sales Report - Grill Corner", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(),
//             children: [
//               _tableRow("Total Sales (£)", totalSales.toStringAsFixed(2)),
//               _tableRow("Zero-rated (0%)", totalZeroRated.toStringAsFixed(2)),
//               _tableRow("VAT (20%)", (totalVat * (1 - (1 / 1.2))).toStringAsFixed(2)),
//               _tableRow("Net Sales (ex VAT)", netSales.toStringAsFixed(2)),
//             ],
//           ),
//           pw.SizedBox(height: 15),
//           ...orders.map((order) {
//             final addOnTotal = extractAddOnTotal(order['items']);
//             final vatableSubtotal = (order['total'] as double) - addOnTotal;
//             final vat = vatableSubtotal * (1 - (1 / 1.2));
//             final net = (order['total'] as double) - vat;
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text("Order ID: ${order['id']}"),
//                 pw.Text("Date: ${order['date']}"),
//                 pw.Text("Items: ${order['items']}"),
//                 pw.Text("Zero-rated: £${addOnTotal.toStringAsFixed(2)}"),
//                 pw.Text("VATable: £${vatableSubtotal.toStringAsFixed(2)}"),
//                 pw.Text("VAT (20%): £${vat.toStringAsFixed(2)}"),
//                 pw.Text("Net (ex VAT): £${net.toStringAsFixed(2)}"),
//                 pw.Text("Total: £${(order['total'] as double).toStringAsFixed(2)}"),
//                 pw.Divider(),
//               ],
//             );
//           }),
//           pw.SizedBox(height: 20),
//           pw.Text("Item Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.Table(
//             border: pw.TableBorder.all(),
//             children: [
//               pw.TableRow(children: [_cell("Item", bold: true), _cell("Qty", bold: true), _cell("Total (£)", bold: true)]),
//               ...itemSummary.entries.map((e) => pw.TableRow(
//                     children: [
//                       _cell(e.key),
//                       _cell("${e.value['quantity']}"),
//                       _cell("£${e.value['total'].toStringAsFixed(2)}"),
//                     ],
//                   )),
//             ],
//           ),
//         ],
//       ),
//     );

//     await Printing.sharePdf(bytes: await pdf.save(), filename: 'sales_report.pdf');
//   }

//   pw.TableRow _tableRow(String label, String value) {
//     return pw.TableRow(children: [
//       pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
//       pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(value)),
//     ]);
//   }

//   pw.Widget _cell(String text, {bool bold = false}) {
//     return pw.Padding(
//       padding: pw.EdgeInsets.all(5),
//       child: pw.Text(text, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
//     );
//   }

//   Map<String, Map<String, dynamic>> getItemSummary(List<Map<String, dynamic>> orders) {
//     final summary = <String, Map<String, dynamic>>{};
//     for (var order in orders) {
//       final items = order['items'].split(',');
//       for (var item in items) {
//         final cleaned = item.trim();
//         final match = RegExp(r'^(.*?)(?:\s*\(£([\d.]+)\))?$').firstMatch(cleaned);
//         if (match != null) {
//           final name = match.group(1)!.trim();
//           final price = double.tryParse(match.group(2) ?? '0') ?? 0;
//           if (!summary.containsKey(name)) {
//             summary[name] = {'quantity': 1, 'total': price};
//           } else {
//             summary[name]!['quantity'] += 1;
//             summary[name]!['total'] += price;
//           }
//         }
//       }
//     }
//     return summary;
//   }
// Future<void> exportCSV() async {
//   final rows = [
//     ['Order ID', 'Items', 'Total', 'Zero-rated (0%)', 'VATable', 'VAT (20%)', 'Net (ex VAT)', 'Date'],
//     ...orders.map((o) {
//       final addOnTotal = extractAddOnTotal(o['items']);
//       final vatableSubtotal = (o['total'] as double) - addOnTotal;
//       final vat = vatableSubtotal * (1 - (1 / 1.2));
//       final net = (o['total'] as double) - vat;
//       return [
//         o['id'].toString(),
//         o['items'],
//         o['total'].toStringAsFixed(2),
//         addOnTotal.toStringAsFixed(2),
//         vatableSubtotal.toStringAsFixed(2),
//         vat.toStringAsFixed(2),
//         net.toStringAsFixed(2),
//         o['date'],
//       ];
//     }),
//   ];

//   final csv = const ListToCsvConverter().convert(rows);
//   final downloads = Directory('${Platform.environment['USERPROFILE']}\\Downloads');
//   final file = File("${downloads.path}/sales_report.csv");
//   await file.writeAsString(csv);

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("CSV exported to ${file.path}")),
//   );
// }

//   void showOrderOptions(BuildContext context, Map<String, dynamic> order) {
//   final addOnTotal = extractAddOnTotal(order['items']);
//   final vatableSubtotal = (order['total'] as double) - addOnTotal;
//   final vat = vatableSubtotal * (1 - (1 / 1.2));
//   final net = (order['total'] as double) - vat;

//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text("Order Options"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Print or export this order."),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 icon: const Icon(Icons.print, size: 18),
//                 label: const Text("Receipt"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   printSingleOrder(order);
//                 },
//               ),
//               TextButton.icon(
//                 icon: const Icon(Icons.picture_as_pdf, size: 18),
//                 label: const Text("Export All PDF"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   exportAllToPDF();
//                 },
//               ),
//               TextButton(
//                 child: const Text("Close"),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Center(
//             child: TextButton.icon(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               label: const Text("Delete", style: TextStyle(color: Colors.red)),
//               onPressed: () async {
//                 await db.deleteOrder(order['id']);
//                 Navigator.pop(context);
//                 fetchOrders();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Order deleted")),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     double totalSales = orders.fold(0, (sum, o) => sum + (o['total'] as double));
//     double totalZeroRated = orders.fold(0, (sum, o) => sum + extractAddOnTotal(o['items']));
//     double totalVat = totalSales - totalZeroRated;
//     double netSales = totalSales - (totalVat * (1 - (1 / 1.2)));

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sales Report"),
//         actions: [
//           IconButton(icon: const Icon(Icons.date_range), onPressed: pickDateRange),
//           IconButton(icon: const Icon(Icons.download), onPressed: exportCSV),
//           IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: exportAllToPDF),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//           Text("Total Sales: £${totalSales.toStringAsFixed(2)}"),
//           Text("Zero-rated: £${totalZeroRated.toStringAsFixed(2)}"),
//           Text("VAT (20%): £${(totalVat * (1 - (1 / 1.2))).toStringAsFixed(2)}"),
//           Text("Net Sales: £${netSales.toStringAsFixed(2)}"),
//           const Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (_, i) {
//                 final o = orders[i];
//                 return ListTile(
//                   title: Text("🧾 ${o['items']}"),
//                   subtitle: Text("Date: ${o['date']}"),
//                   trailing: Text("£${(o['total'] as double).toStringAsFixed(2)}"),
//                   onTap: () => showOrderOptions(context, o),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:csv/csv.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../db/db_helper.dart';
// import 'package:pdf/pdf.dart';


// class SalesScreen extends StatefulWidget {
//   const SalesScreen({super.key});

//   @override
//   State<SalesScreen> createState() => _SalesScreenState();
// }

// class _SalesScreenState extends State<SalesScreen> {
//   final DBHelper db = DBHelper();
//   List<Map<String, dynamic>> orders = [];
//   DateTimeRange? selectedDateRange;

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<List<Map<String, dynamic>>> fetchFirestoreOrders() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('orders')
//         .orderBy('date', descending: true)
//         .get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
//       return {
//         'id': doc.id,
//         'items': items,
//         'total': (data['total'] ?? 0).toDouble(),
//         'vat': (data['vatTotal'] ?? 0).toDouble(),
//         'net': (data['netTotal'] ?? 0).toDouble(),
//         'date': data['date'].toDate().toString(),
//         'orderType': data['orderType'] ?? '',
//         'paymentMethod': data['paymentMethod'] ?? '',
//         'address': data['address'] ?? '',
//       };
//     }).toList();
//   }

//   Map<String, double> calculateVatBreakdown(List<Map<String, dynamic>> items) {
//     double vatItems = 0.0;
//     double nonVatItems = 0.0;

//     for (var item in items) {
//       final price = (item['price'] ?? 0).toDouble();
//       final isVat = item['isVat'] ?? false;
//       if (isVat) {
//         vatItems += price;
//       } else {
//         nonVatItems += price;
//       }
//     }

//     final vat = vatItems * (1 - (1 / 1.2));
//     final net = vatItems + nonVatItems - vat;

//     return {
//       'vatableSubtotal': vatItems,
//       'zeroRated': nonVatItems,
//       'vat': vat,
//       'net': net,
//     };
//   }

// // Add this helper method:
// Map<String, Map<String, dynamic>> getItemSummary(List<Map<String, dynamic>> orders) {
//   final summary = <String, Map<String, dynamic>>{};
//   for (var order in orders) {
// final rawItems = order['items'];
// final items = rawItems is String
//     ? [] // or use jsonDecode(rawItems) if you stored it as a stringified JSON
//     : List<Map<String, dynamic>>.from(rawItems);
//     for (var item in items) {
//       final name = item['name'];
//       final price = (item['price'] ?? 0).toDouble();
//       if (!summary.containsKey(name)) {
//         summary[name] = {'quantity': 1, 'total': price};
//       } else {
//         summary[name]!['quantity'] += 1;
//         summary[name]!['total'] += price;
//       }
//     }
//   }
//   return summary;
// }




//   Future<void> fetchOrders() async {
//     final localOrders = await db.getAllOrders();
//     final firebaseOrders = await fetchFirestoreOrders();

//     final all = [...localOrders, ...firebaseOrders];

//     if (selectedDateRange != null) {
//       orders = all.where((order) {
//         final orderDate = DateTime.parse(order['date']);
//         return orderDate.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
//             orderDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
//       }).toList();
//     } else {
//       orders = all;
//     }

//     setState(() {});
//   }

//   Future<void> pickDateRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() => selectedDateRange = picked);
//       await fetchOrders();
//     }
//   }

//   Future<void> exportToCSV() async {
//     final rows = [
//       ['Date', 'Order Type', 'Total', 'VAT', 'Net', 'Zero Rated']
//     ];

//     for (var order in orders) {
//       final breakdown = calculateVatBreakdown(List<Map<String, dynamic>>.from(order['items']));
//       rows.add([
//         order['date'],
//         order['orderType'],
//         order['total'].toStringAsFixed(2),
//         breakdown['vat']!.toStringAsFixed(2),
//         breakdown['net']!.toStringAsFixed(2),
//         breakdown['zeroRated']!.toStringAsFixed(2),
//       ]);
//     }

//     final dir = await getApplicationDocumentsDirectory();
//     final file = File("${dir.path}/sales_report.csv");
//     await file.writeAsString(const ListToCsvConverter().convert(rows));

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CSV exported to ${file.path}")));
//   }

// Future<void> printSingleOrder(Map<String, dynamic> order) async {
//   final breakdown = calculateVatBreakdown(List<Map<String, dynamic>>.from(order['items']));
//   final date = DateTime.parse(order['date']);
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat(88 * PdfPageFormat.mm, double.infinity),
//       margin: const pw.EdgeInsets.all(6),
//       build: (context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Center(child: pw.Text("GRILL CORNER", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
//           pw.SizedBox(height: 4),
//           pw.Divider(),
//           pw.Text("Date: ${date.toLocal()}"),
//           pw.Text("Order Type: ${order['orderType']}"),
//           if ((order['address'] ?? '').isNotEmpty)
//             pw.Text("Address: ${order['address']}"),
//           pw.SizedBox(height: 6),
//           pw.Text("Items:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 2),
//           ...List<Map<String, dynamic>>.from(order['items']).map((item) => pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Expanded(child: pw.Text("${item['name']}")),
//               pw.Text("£${(item['price']).toStringAsFixed(2)}"),
//             ],
//           )),
//           pw.Divider(),
//           pw.Text("VAT: £${breakdown['vat']!.toStringAsFixed(2)}"),
//           pw.Text("Net: £${breakdown['net']!.toStringAsFixed(2)}"),
//           pw.Text("Zero Rated: £${breakdown['zeroRated']!.toStringAsFixed(2)}"),
//           pw.Text("Total: £${order['total'].toStringAsFixed(2)}"),
//           pw.Divider(),
//           pw.Center(child: pw.Text("Thank You!")),
//         ],
//       ),
//     ),
//   );

//   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
// }

// Future<void> confirmDeleteOrder(BuildContext context, String orderId) async {
//   final confirm = await showDialog<bool>(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text("Delete Order"),
//       content: const Text("Are you sure you want to delete this order?"),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//         TextButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: const Text("Delete", style: TextStyle(color: Colors.red)),
//         ),
//       ],
//     ),
//   );

//   if (confirm == true) {
//     await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
//     await fetchOrders();
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order deleted")));
//     }
//   }
// }

//   Future<void> exportToPDF() async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         build: (context) => [
//           pw.Text("Sales Report", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
         
//           pw.SizedBox(height: 10),
//           pw.Table.fromTextArray(
//             headers: ['Date', 'Order Type', 'Total', 'VAT', 'Net', 'Zero Rated'],
//             data: orders.map((order) {
//               final breakdown = calculateVatBreakdown(List<Map<String, dynamic>>.from(order['items']));
//               return [
//                 order['date'],
//                 order['orderType'],
//                 '£${order['total'].toStringAsFixed(2)}',
//                 '£${breakdown['vat']!.toStringAsFixed(2)}',
//                 '£${breakdown['net']!.toStringAsFixed(2)}',
//                 '£${breakdown['zeroRated']!.toStringAsFixed(2)}',
//               ];
//             }).toList(),
//           ),
//           // After the main sales table
// pw.SizedBox(height: 20),
// pw.Text("Item Summary", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// pw.Table(
//   border: pw.TableBorder.all(),
//   children: [
//     pw.TableRow(
//       children: [
//         pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Item", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
//         pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
//         pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Total (£)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
//       ],
//     ),
//     ...getItemSummary(orders).entries.map((entry) {
//       final name = entry.key;
//       final qty = entry.value['quantity'];
//       final total = entry.value['total'];
//       return pw.TableRow(
//         children: [
//           pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(name)),
//           pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(qty.toString())),
//           pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("£${total.toStringAsFixed(2)}")),
//         ],
//       );
//     }),
//   ],
// ),

//  // Add overall totals summary
// pw.SizedBox(height: 20),
// pw.Text("Overall Totals", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// pw.SizedBox(height: 5),
// pw.Text("Total Sales: £${orders.fold(0.0, (sum, o) => sum + (o['total'] ?? 0.0)).toStringAsFixed(2)}"),
// pw.Text("Total VAT: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['vat'] ?? 0.0)).toStringAsFixed(2)}"),
// pw.Text("Net Sales: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['net'] ?? 0.0)).toStringAsFixed(2)}"),
// pw.Text("Zero Rated: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['zeroRated'] ?? 0.0)).toStringAsFixed(2)}"),


//         ],
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }

//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text("Sales Report"),
//       actions: [
//         IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: exportToPDF),
//         IconButton(icon: const Icon(Icons.download), onPressed: exportToCSV),
//         IconButton(icon: const Icon(Icons.date_range), onPressed: pickDateRange),
//       ],
//     ),
//     body: orders.isEmpty
//         ? const Center(child: Text("No sales to display"))
//         : Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 3,
//                   color: Colors.orange.shade50,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("📊 Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 8),
//                         Text("Total Sales: £${orders.fold(0.0, (sum, o) => sum + (o['total'] ?? 0.0)).toStringAsFixed(2)}"),
//                         Text("Total VAT: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['vat'] ?? 0.0)).toStringAsFixed(2)}"),
//                         Text("Net Sales: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['net'] ?? 0.0)).toStringAsFixed(2)}"),
//                         Text("Zero Rated: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(List<Map<String, dynamic>>.from(o['items']))['zeroRated'] ?? 0.0)).toStringAsFixed(2)}"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];
//                     final breakdown = calculateVatBreakdown(List<Map<String, dynamic>>.from(order['items']));
//                     final date = DateTime.parse(order['date']);

//                     return Card(
//                       margin: const EdgeInsets.all(8),
//                       elevation: 3,
//                       child: ExpansionTile(
//                         title: Text("${order['orderType']} - £${order['total'].toStringAsFixed(2)}"),
//                         subtitle: Text("VAT: £${breakdown['vat']!.toStringAsFixed(2)} | Net: £${breakdown['net']!.toStringAsFixed(2)}"),
//                         children: [
//                           ...List<Map<String, dynamic>>.from(order['items']).map((item) => ListTile(
//                                 title: Text(item['name']),
//                                 trailing: Text("£${item['price'].toStringAsFixed(2)}"),
//                                 subtitle: Text(item['isVat'] ? "VAT" : "Zero VAT"),
//                               )),
//                           Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       ElevatedButton.icon(
//         icon: const Icon(Icons.print, size: 16),
//         label: const Text("Print"),
//         onPressed: () => printSingleOrder(orders[index]),
//       ),
//       ElevatedButton.icon(
//         icon: const Icon(Icons.delete, size: 16, color: Colors.red),
//         label: const Text("Delete", style: TextStyle(color: Colors.red)),
//         onPressed: () => confirmDeleteOrder(context, orders[index]['id']),
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//       ),
//     ],
//   ),
// ),

//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//   );
// }

// }





import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../db/db_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final DBHelper db = DBHelper();
  List<Map<String, dynamic>> orders = [];
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  List<Map<String, dynamic>> parseItems(dynamic raw) {
    try {
      if (raw is String) {
        return List<Map<String, dynamic>>.from(jsonDecode(raw)).map((item) {
          return {...item, 'isVat': item['isVat'] == true || item['isVat'] == 'true'};
        }).toList();
      } else if (raw is List) {
        return List<Map<String, dynamic>>.from(raw).map((item) {
          return {...item, 'isVat': item['isVat'] == true || item['isVat'] == 'true'};
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  Map<String, double> calculateVatBreakdown(List<Map<String, dynamic>> items) {
    double vatItems = 0.0;
    double nonVatItems = 0.0;

    for (var item in items) {
      final price = (item['price'] ?? 0).toDouble();
      final isVat = item['isVat'] == true || item['isVat'] == 'true';
      if (isVat) {
        vatItems += price;
      } else {
        nonVatItems += price;
      }
    }

    final vat = vatItems * (1 - (1 / 1.2));
    final net = vatItems + nonVatItems - vat;

    return {
      'vatableSubtotal': vatItems,
      'zeroRated': nonVatItems,
      'vat': vat,
      'net': net,
    };
  }

  Future<List<Map<String, dynamic>>> fetchFirestoreOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'items': data['items'],
        'total': (data['total'] ?? 0).toDouble(),
        'date': data['date'].toDate().toString(),
        'orderType': data['orderType'] ?? '',
        'paymentMethod': data['paymentMethod'] ?? '',
        'address': data['address'] ?? '',
      };
    }).toList();
  }

  Future<void> fetchOrders() async {
    final localOrders = await db.getAllOrders();
    final firebaseOrders = await fetchFirestoreOrders();
    final all = [...localOrders, ...firebaseOrders];

    if (selectedDateRange != null) {
      orders = all.where((order) {
        final orderDate = DateTime.parse(order['date']);
        return orderDate.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            orderDate.isBefore(selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    } else {
      orders = all;
    }

    setState(() {});
  }

  Future<void> exportToCSV() async {
    final rows = [
      ['Date', 'Order Type', 'Total', 'VAT', 'Net', 'Zero Rated']
    ];

    for (var order in orders) {
      final breakdown = calculateVatBreakdown(parseItems(order['items']));
      rows.add([
        order['date'],
        order['orderType'],
        order['total'].toStringAsFixed(2),
        breakdown['vat']!.toStringAsFixed(2),
        breakdown['net']!.toStringAsFixed(2),
        breakdown['zeroRated']!.toStringAsFixed(2),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/sales_report.csv");
    await file.writeAsString(const ListToCsvConverter().convert(rows));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CSV exported to ${file.path}")));
  }

  Future<void> printSingleOrder(Map<String, dynamic> order) async {
    final items = parseItems(order['items']);
    final breakdown = calculateVatBreakdown(items);
    final date = DateTime.parse(order['date']);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(88 * PdfPageFormat.mm, double.infinity),
        margin: const pw.EdgeInsets.all(6),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(child: pw.Text("GRILL CORNER", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
            pw.Divider(),
            pw.Text("Date: ${date.toLocal()}"),
            pw.Text("Order Type: ${order['orderType']}"),
            if ((order['orderType'] == 'Delivery') && (order['address'] ?? '').isNotEmpty)
              pw.Text("Address: ${order['address']}"),
            pw.SizedBox(height: 6),
            pw.Text("Items:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ...items.map((item) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Text("${item['name']}")),
                pw.Text("£${(item['price']).toStringAsFixed(2)}"),
              ],
            )),
            pw.Divider(),
            pw.Text("VAT: £${breakdown['vat']!.toStringAsFixed(2)}"),
            pw.Text("Net: £${breakdown['net']!.toStringAsFixed(2)}"),
            pw.Text("Zero Rated: £${breakdown['zeroRated']!.toStringAsFixed(2)}"),
            pw.Text("Total: £${order['total'].toStringAsFixed(2)}"),
            pw.Center(child: pw.Text("Thank You!")),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> confirmDeleteOrder(BuildContext context, String orderId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Order"),
        content: const Text("Are you sure you want to delete this order?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
      } catch (_) {
if (int.tryParse(orderId) != null) {
  await db.deleteOrder(int.parse(orderId)); // Local order
}
      }
      await fetchOrders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order deleted")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Report"),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: exportToCSV),
          IconButton(icon: const Icon(Icons.date_range), onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => selectedDateRange = picked);
              await fetchOrders();
            }
          }),
        ],
      ),
      body: orders.isEmpty
          ? const Center(child: Text("No sales to display"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("📊 Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Total Sales: £${orders.fold(0.0, (sum, o) => sum + (o['total'] ?? 0.0)).toStringAsFixed(2)}"),
                          Text("Total VAT: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(parseItems(o['items']))['vat'] ?? 0.0)).toStringAsFixed(2)}"),
                          Text("Net Sales: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(parseItems(o['items']))['net'] ?? 0.0)).toStringAsFixed(2)}"),
                          Text("Zero Rated: £${orders.fold(0.0, (sum, o) => sum + (calculateVatBreakdown(parseItems(o['items']))['zeroRated'] ?? 0.0)).toStringAsFixed(2)}"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 16,
                        columns: const [
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Order Type")),
                          DataColumn(label: Text("Total")),
                          DataColumn(label: Text("VAT")),
                          DataColumn(label: Text("Net")),
                          DataColumn(label: Text("Zero Rated")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: orders.map((order) {
                          final items = parseItems(order['items']);
                          final breakdown = calculateVatBreakdown(items);
                          final date = DateTime.parse(order['date']);

                          return DataRow(
                            cells: [
                              DataCell(Text("${date.day}/${date.month}/${date.year}")),
                              DataCell(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order['orderType']),
                                  if (order['orderType'] == 'Delivery' && (order['address'] ?? '').isNotEmpty)
                                    Text(order['address'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              )),
                              DataCell(Text("£${order['total'].toStringAsFixed(2)}")),
                              DataCell(Text("£${breakdown['vat']!.toStringAsFixed(2)}")),
                              DataCell(Text("£${breakdown['net']!.toStringAsFixed(2)}")),
                              DataCell(Text("£${breakdown['zeroRated']!.toStringAsFixed(2)}")),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.print, size: 20, color: Colors.green),
                                    tooltip: "Print",
                                    onPressed: () => printSingleOrder(order),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                    tooltip: "Delete",
                                    onPressed: () => confirmDeleteOrder(context, order['id']),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
