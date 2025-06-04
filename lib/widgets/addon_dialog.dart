import 'package:flutter/material.dart';

class AddOnDialog extends StatefulWidget {
  final List<Map<String, dynamic>> addOns;

  const AddOnDialog(this.addOns, {super.key});

  @override
  State<AddOnDialog> createState() => _AddOnDialogState();
}

class _AddOnDialogState extends State<AddOnDialog> {
  final Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Salad & Sauce"),
      content: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.addOns.length, (index) {
            final addOn = widget.addOns[index];
            return CheckboxListTile(
              value: selectedIndexes.contains(index),
title: Tooltip(
  message: "Cold add-ons are zero-rated (no VAT)",
  child: Text("${addOn['name']} (£${addOn['price']})"),
),
              onChanged: (_) {
                setState(() {
                  selectedIndexes.contains(index)
                      ? selectedIndexes.remove(index)
                      : selectedIndexes.add(index);
                });
              },
            );
          }),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final selected = selectedIndexes.map((i) => widget.addOns[i]).toList();
            Navigator.pop(context, selected);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
