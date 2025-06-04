import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<void> acceptOrder({
    required String orderId,
    required String customerEmail,
    required String estimatedTime,
  }) async {
    // Update Firestore
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': 'Accepted',
      'estimatedTime': estimatedTime,
      'acceptedByAdmin': true,
    });

    // Optional: send email to customer (via your backend or 3rd-party email API)
    final emailApiUrl = Uri.parse('http://YOUR_SERVER/send-email');
    await http.post(
      emailApiUrl,
      headers: {'Content-Type': 'application/json'},
      body: {
        'email': customerEmail,
        'message': 'Your order has been accepted. Estimated time: $estimatedTime',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Orders"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'Pending';
              final accepted = data['acceptedByAdmin'] ?? false;

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${data['customerName']}"),
                      Text("Phone: ${data['phone']}"),
                      Text("Total: £${data['total'].toStringAsFixed(2)}"),
                      Text("Order Type: ${data['orderType']}"),
                      Text("Payment: ${data['paymentMethod']}"),
                      Text("Status: $status",
                          style: TextStyle(
                              color: accepted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (!accepted)
                        ElevatedButton(
                          onPressed: () async {
                            final controller = TextEditingController();
                            final result = await showDialog<String>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Enter Estimated Time"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(hintText: "e.g., 25 mins"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, controller.text),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );

                            if (result != null && result.isNotEmpty) {
                              await acceptOrder(
                                orderId: doc.id,
                                customerEmail: data['email'] ?? '', // Assuming email is stored
                                estimatedTime: result,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                          child: const Text("Accept & Set ETA"),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}