import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhoneOrderScreen extends StatefulWidget {
  const PhoneOrderScreen({super.key});

  @override
  State<PhoneOrderScreen> createState() => _PhoneOrderScreenState();
}

class _PhoneOrderScreenState extends State<PhoneOrderScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  String? selectedAddress;
  List<String> addressList = [];

  // ✅ Replace this with your real GetAddress.io API key
  String apiKey = 'your_getaddress_api_key';

  Future<void> fetchAddresses() async {
    final postcode = postcodeController.text.trim().replaceAll(' ', '');
    if (postcode.isEmpty) return;

    final uri = Uri.parse(
        'https://api.getaddress.io/find/$postcode?api-key=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        addressList = List<String>.from(data['addresses']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address lookup failed.")),
      );
    }
  }

  void onConfirmSelection() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty || selectedAddress == null) return;

    // You can now pass this data back or save to DB
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Customer: $phone | $selectedAddress")),
    );

    // Optionally navigate back or pass result to another screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Order")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: postcodeController,
              decoration: InputDecoration(
                labelText: "Enter Postcode",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: fetchAddresses,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (addressList.isNotEmpty)
              DropdownButtonFormField<String>(
                value: selectedAddress,
                hint: const Text("Select Address"),
                items: addressList.map((address) {
                  return DropdownMenuItem(
                    value: address,
                    child: Text(address),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedAddress = val),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onConfirmSelection,
              icon: const Icon(Icons.check),
              label: const Text("Confirm and Use"),
            ),
          ],
        ),
      ),
    );
  }
}
