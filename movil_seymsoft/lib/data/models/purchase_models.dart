class PurchaseProduct {
  const PurchaseProduct({
    required this.name,
    required this.barcode,
    required this.quantity,
    required this.grossUnitPrice,
    required this.taxUnitPrice,
    required this.netUnitPrice,
    required this.grossSubtotal,
    required this.ivaSubtotal,
    required this.netSubtotal,
    required this.taxPercentage,
    required this.batchCode,
  });

  final String name;
  final String barcode;
  final int quantity;
  final double grossUnitPrice;
  final double taxUnitPrice;
  final double netUnitPrice;
  final double grossSubtotal;
  final double ivaSubtotal;
  final double netSubtotal;
  final double taxPercentage;
  final String batchCode;

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) {
    return PurchaseProduct(
      name: json['productName'] as String? ?? 'Producto',
      barcode: json['barcode'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      grossUnitPrice: (json['grossUnitPrice'] as num?)?.toDouble() ?? 0,
      taxUnitPrice: (json['taxUnitPrice'] as num?)?.toDouble() ?? 0,
      netUnitPrice: (json['netUnitPrice'] as num?)?.toDouble() ?? 0,
      grossSubtotal: (json['grossSubtotal'] as num?)?.toDouble() ?? 0,
      ivaSubtotal: (json['ivaSubtotal'] as num?)?.toDouble() ?? 0,
      netSubtotal: (json['netSubtotal'] as num?)?.toDouble() ?? 0,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0,
      batchCode: json['batchCode'] as String? ?? '',
    );
  }
}

class Purchase {
  const Purchase({
    required this.id,
    required this.invoiceNumber,
    required this.purchaseDate,
    required this.totalAmount,
    required this.totalQuantity,
    required this.providerName,
    required this.status,
    this.details = const [],
  });

  final int id;
  final String invoiceNumber;
  final DateTime purchaseDate;
  final double totalAmount;
  final int totalQuantity;
  final String providerName;
  final String status;
  final List<PurchaseProduct> details;

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as List<dynamic>? ?? const [];
    final parsedDetails = details
        .map((item) => PurchaseProduct.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    final detailQuantity = parsedDetails.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Purchase(
      id: (json['id'] as num).toInt(),
      invoiceNumber: json['invoiceNumber'] as String? ?? 'Sin factura',
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? detailQuantity,
      providerName:
          json['providerName'] as String? ?? 'Proveedor no disponible',
      status: json['status'] as String? ?? 'Sin estado',
      details: parsedDetails,
    );
  }
}

class PurchasesPageResult {
  const PurchasesPageResult({
    required this.purchases,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  final List<Purchase> purchases;
  final int page;
  final int total;
  final int totalPages;

  bool get hasNextPage => page < totalPages;
}
