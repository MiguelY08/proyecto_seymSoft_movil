class SaleProduct {
  const SaleProduct({
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  factory SaleProduct.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? const {};
    final quantity = (json['quantity'] as num?)?.toInt() ?? 0;
    final unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0;

    return SaleProduct(
      name: product['name'] as String? ?? 'Producto',
      description: product['reference'] as String? ?? '',
      quantity: quantity,
      unitPrice: unitPrice,
      total: quantity * unitPrice,
    );
  }
}

class Sale {
  const Sale({
    required this.id,
    required this.customerName,
    required this.employeeName,
    required this.date,
    required this.statusName,
    required this.paymentMethodNames,
    required this.subtotal,
    required this.ivaAmount,
    required this.total,
    this.products = const [],
  });

  final int id;
  final String customerName;
  final String employeeName;
  final DateTime date;
  final String statusName;
  final List<String> paymentMethodNames;
  final double subtotal;
  final double ivaAmount;
  final double total;
  final List<SaleProduct> products;

  String get paymentMethodsLabel {
    if (paymentMethodNames.isEmpty) return 'Sin especificar';
    return paymentMethodNames.join(' + ');
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'] as Map<String, dynamic>? ?? const {};
    final employeeUser = employee['user'] as Map<String, dynamic>? ?? const {};
    final order = json['order'] as Map<String, dynamic>? ?? const {};
    final customer = order['customer'] as Map<String, dynamic>? ?? const {};
    final customerUser = customer['user'] as Map<String, dynamic>? ?? const {};
    final status = json['saleStatus'] as Map<String, dynamic>? ?? const {};
    final paymentMethods = json['paymentMethods'] as List<dynamic>? ?? const [];
    final details = order['details'] as List<dynamic>? ?? const [];

    return Sale(
      id: (json['idSale'] as num).toInt(),
      customerName:
          customerUser['fullName'] as String? ?? 'Cliente no disponible',
      employeeName:
          employeeUser['fullName'] as String? ?? 'Vendedor no disponible',
      date: DateTime.parse(json['saleDate'] as String),
      statusName: status['nameStatus'] as String? ?? 'Sin estado',
      paymentMethodNames: paymentMethods
          .map((item) {
            final value = item as Map<String, dynamic>;
            final method =
                value['paymentMethod'] as Map<String, dynamic>? ?? const {};
            return method['namePaymentMethod'] as String?;
          })
          .whereType<String>()
          .toList(growable: false),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      ivaAmount: (json['ivaAmount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      products: details
          .map((item) => SaleProduct.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class SalesPageResult {
  const SalesPageResult({
    required this.sales,
    required this.page,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
  });

  final List<Sale> sales;
  final int page;
  final int total;
  final int totalPages;
  final bool hasNextPage;
}
