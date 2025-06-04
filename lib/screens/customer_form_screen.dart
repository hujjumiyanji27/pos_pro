// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../db/db_helper.dart';
// import '../models/customer.dart';

// class CustomerFormScreen extends StatefulWidget {
//   final String phone;

//   const CustomerFormScreen({super.key, required this.phone});

//   @override
//   State<CustomerFormScreen> createState() => _CustomerFormScreenState();
// }

// class _CustomerFormScreenState extends State<CustomerFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _db = DBHelper();

//   final nameController = TextEditingController();
//   final addressController = TextEditingController();
//   final postcodeController = TextEditingController();
//   final notesController = TextEditingController();

//   List<String> addressList = [];
//   String? selectedAddress;

//   final String apiKey = 'mRf2EdJpSUmKtBqkLc3G9Q46349'; // Replace this

//   Future<void> fetchAddresses() async {
//   final postcode = postcodeController.text.trim();
//   if (postcode.isEmpty) return;

//   final encodedPostcode = Uri.encodeComponent(postcode);
//   final url = Uri.parse(
//       'https://api.getaddress.io/autocomplete/$encodedPostcode?api-key=$apiKey');

//   try {
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final suggestions = data['suggestions'] as List;
//       setState(() {
//         addressList = suggestions.map((s) => s['address'] as String).toList();
//         selectedAddress = null;
//       });
//     } else {
//       showError();
//     }
//   } catch (e) {
//     showError();
//   }
// }

// void showError() {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("Failed to fetch addresses")),
//   );
// }


//   void saveCustomer() async {
//     if (_formKey.currentState!.validate()) {
//       final customer = Customer(
//         phone: widget.phone,
//         name: nameController.text.trim(),
//         address: addressController.text.trim(),
//         postcode: postcodeController.text.trim(),
//         notes: notesController.text.trim(),
//       );
//       await _db.insertCustomer(customer);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customer Saved')));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("New Customer")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Text("Phone: ${widget.phone}", style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator: (val) => val!.isEmpty ? "Enter name" : null,
//               ),
//               TextFormField(
//                 controller: postcodeController,
//                 decoration: InputDecoration(
//                   labelText: "Postcode",
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: fetchAddresses,
//                   ),
//                 ),
//               ),
//               if (addressList.isNotEmpty) ...[
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: selectedAddress,
//                   hint: Text("Select Address"),
//                   items: addressList.map((address) {
//                     return DropdownMenuItem(
//                       value: address,
//                       child: Text(address),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedAddress = value;
//                       addressController.text = value ?? '';
//                     });
//                   },
//                 ),
//               ],
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//               ),
//               TextFormField(
//                 controller: notesController,
//                 decoration: const InputDecoration(labelText: "Notes (Optional)"),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: saveCustomer,
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save Customer"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/db_helper.dart';
import '../models/customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final String phone;
  final Customer? existingCustomer;

  const CustomerFormScreen({
    super.key,
    required this.phone,
    this.existingCustomer,
  });

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DBHelper();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final postcodeController = TextEditingController();
  final notesController = TextEditingController();

  List<String> addressList = [];
  String? selectedAddress;
  final String apiKey = 'mRf2EdJpSUmKtBqkLc3G9Q46349'; // your getAddress.io key

  @override
  void initState() {
    super.initState();
    if (widget.existingCustomer != null) {
      nameController.text = widget.existingCustomer!.name;
      addressController.text = widget.existingCustomer!.address;
      postcodeController.text = widget.existingCustomer!.postcode;
      notesController.text = widget.existingCustomer!.notes ?? '';
    }
  }

  Future<void> fetchAddresses() async {
    final postcode = postcodeController.text.trim();
    if (postcode.isEmpty) return;

    final encodedPostcode = Uri.encodeComponent(postcode);
    final url = Uri.parse(
        'https://api.getaddress.io/autocomplete/$encodedPostcode?api-key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final suggestions = data['suggestions'] as List;
        setState(() {
          addressList =
              suggestions.map((s) => s['address'] as String).toList();
          selectedAddress = null;
        });
      } else {
        showError();
      }
    } catch (_) {
      showError();
    }
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to fetch addresses")),
    );
  }

  void saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        phone: widget.phone,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        postcode: postcodeController.text.trim(),
        notes: notesController.text.trim(),
      );
      await _db.insertCustomer(customer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              widget.existingCustomer != null ? 'Customer Updated' : 'Customer Saved'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingCustomer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Customer" : "New Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Phone: ${widget.phone}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: postcodeController,
                decoration: InputDecoration(
                  labelText: "Postcode",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: fetchAddresses,
                  ),
                ),
              ),
              if (addressList.isNotEmpty) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedAddress,
                  hint: const Text("Select Address"),
                  items: addressList.map((address) {
                    return DropdownMenuItem(
                      value: address,
                      child: Text(address),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAddress = value;
                      addressController.text = value ?? '';
                    });
                  },
                ),
              ],
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? "Enter address" : null,
              ),
              TextFormField(
                controller: notesController,
                decoration:
                    const InputDecoration(labelText: "Notes (Optional)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: saveCustomer,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? "Update Customer" : "Save Customer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
