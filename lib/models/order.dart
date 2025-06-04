class Order {
  final int id;
  final String items;
  final double total;
  final double vat;
  final double net;
  final String date;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.vat,
    required this.net,
    required this.date,
  });
}
