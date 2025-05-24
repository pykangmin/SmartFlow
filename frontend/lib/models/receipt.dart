class Receipt {
  final int? id;
  final String imageUrl;
  final double totalAmount;
  final DateTime receiptDate;
  final DateTime createdAt;
  final List<ReceiptItem> items;

  Receipt({
    this.id,
    required this.imageUrl,
    required this.totalAmount,
    required this.receiptDate,
    required this.createdAt,
    this.items = const [],
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      imageUrl: json['image_url'],
      totalAmount: json['total_amount'].toDouble(),
      receiptDate: DateTime.parse(json['receipt_date']),
      createdAt: DateTime.parse(json['created_at']),
      items: (json['items'] as List?)
              ?.map((item) => ReceiptItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'total_amount': totalAmount,
      'receipt_date': receiptDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ReceiptItem {
  final int? id;
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  ReceiptItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
} 