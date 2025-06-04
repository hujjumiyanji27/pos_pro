class Customer {
  int? id;
  String phone;
  String name;
  String address;
  String postcode;
  String? notes;

  Customer({
    this.id,
    required this.phone,
    required this.name,
    required this.address,
    required this.postcode,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'address': address,
      'postcode': postcode,
      'notes': notes,
    };
  }

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      phone: map['phone'],
      name: map['name'],
      address: map['address'],
      postcode: map['postcode'],
      notes: map['notes'],
    );
  }
}
