// import 'package:flutter/material.dart';
// import '../db/db_helper.dart';
// import '../models/customer.dart';
// import 'customer_form_screen.dart';

// class CustomerSearchScreen extends StatefulWidget {
//   const CustomerSearchScreen({super.key});

//   @override
//   State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
// }

// class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
//   final DBHelper db = DBHelper();
//   final TextEditingController postcodeController = TextEditingController();
//   List<Customer> customers = [];

//   Future<void> search() async {
//     final input = postcodeController.text.trim();
//     if (input.isEmpty) return;

//     final results = await db.searchCustomersByPostcode(input);
//     setState(() => customers = results);
//   }

//   Future<void> deleteCustomer(String phone) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Delete Customer"),
//         content: const Text("Are you sure you want to delete this customer?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await db.deleteCustomer(phone);
//       await search();
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer deleted")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Search Customers by Postcode")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: postcodeController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Postcode',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: search,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: customers.isEmpty
//                   ? const Center(child: Text("No customers found"))
//                   : ListView.builder(
//                       itemCount: customers.length,
//                       itemBuilder: (_, index) {
//                         final customer = customers[index];
//                         return ListTile(
//                           title: Text(customer.name),
//                           subtitle: Text("${customer.address}, ${customer.postcode}"),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => deleteCustomer(customer.phone),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => CustomerFormScreen(
//                                   phone: customer.phone,
//                                   existingCustomer: customer,
//                                 ),
//                               ),
//                             ).then((_) => search());
//                           },
                          
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/customer.dart';
import 'customer_form_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final DBHelper db = DBHelper();
  final TextEditingController postcodeController = TextEditingController();
  List<Customer> customers = [];

  Future<void> search() async {
final input = postcodeController.text.trim().toUpperCase();
    if (input.isEmpty) return;

    final results = await db.searchCustomersByPostcode(input);
    setState(() => customers = results);
  }

  Future<void> deleteCustomer(String phone) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Customer"),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      await db.deleteCustomer(phone);
      await search();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Customers by Postcode")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: postcodeController,
              decoration: InputDecoration(
                labelText: 'Enter Postcode',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: customers.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No customers found"),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final newCustomer = await Navigator.push(
                              context,
                              MaterialPageRoute(
builder: (_) => CustomerFormScreen(phone: '',),
                              ),
                            );
                            if (newCustomer != null && newCustomer is Customer) {
                              Navigator.pop(context, newCustomer);
                            }
                          },
                          child: const Text("Add New Customer"),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (_, index) {
                        final customer = customers[index];
                        return ListTile(
  title: Text(customer.name),
  subtitle: Text('${customer.address}, ${customer.postcode}'),
  onTap: () {
    Navigator.pop(context, {
      'name': customer.name,
      'address': customer.address,
      'phone': customer.phone,
    });
  },
);

                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
