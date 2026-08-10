class MonthlySalesIndicator {
  const MonthlySalesIndicator({
    required this.currentMonthSales,
    required this.previousMonthSales,
    required this.growthPercentage,
  });

  final double currentMonthSales;
  final double previousMonthSales;
  final double growthPercentage;

  factory MonthlySalesIndicator.fromJson(Map<String, dynamic> json) {
    return MonthlySalesIndicator(
      currentMonthSales:
          (json['currentMonthSales'] as num?)?.toDouble() ?? 0,
      previousMonthSales:
          (json['previousMonthSales'] as num?)?.toDouble() ?? 0,
      growthPercentage:
          (json['growthPercentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class StockIndicator {
  const StockIndicator({required this.totalUnitsInStock});

  final int totalUnitsInStock;

  factory StockIndicator.fromJson(Map<String, dynamic> json) {
    return StockIndicator(
      totalUnitsInStock:
          (json['totalUnitsInStock'] as num?)?.toInt() ?? 0,
    );
  }
}

class TopProductIndicator {
  const TopProductIndicator({
    required this.idProduct,
    required this.productName,
    required this.value,
  });

  final int idProduct;
  final String productName;
  final double value;

  factory TopProductIndicator.fromJson(Map<String, dynamic> json) {
    return TopProductIndicator(
      idProduct: (json['idProduct'] as num?)?.toInt() ?? 0,
      productName: json['productName'] as String? ?? 'Producto sin nombre',
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TopClientIndicator {
  const TopClientIndicator({required this.clientName, required this.value});
  final String clientName;
  final double value;
  factory TopClientIndicator.fromJson(Map<String, dynamic> json) => TopClientIndicator(
        clientName: json['clientName'] as String? ?? 'Cliente',
        value: (json['value'] as num?)?.toDouble() ?? 0,
      );
}

class CategoryDemandIndicator {
  const CategoryDemandIndicator({required this.categoryName, required this.units});
  final String categoryName;
  final int units;
  factory CategoryDemandIndicator.fromJson(Map<String, dynamic> json) => CategoryDemandIndicator(
        categoryName: json['categoryName'] as String? ?? 'Sin categoría',
        units: (json['units'] as num?)?.toInt() ?? 0,
      );
}

class CommercialTrendIndicator {
  const CommercialTrendIndicator({required this.month, required this.sales});
  final String month;
  final double sales;
  factory CommercialTrendIndicator.fromJson(Map<String, dynamic> json) => CommercialTrendIndicator(
        month: json['month'] as String? ?? '',
        sales: (json['sales'] as num?)?.toDouble() ?? 0,
      );
}

class DashboardIndicators {
  const DashboardIndicators({
    required this.monthlySales,
    required this.stock,
    required this.topProducts,
    required this.activeClients,
    required this.topClients,
    required this.categoryDemand,
    required this.commercialTrends,
  });

  final MonthlySalesIndicator monthlySales;
  final StockIndicator stock;
  final List<TopProductIndicator> topProducts;
  final int activeClients;
  final List<TopClientIndicator> topClients;
  final List<CategoryDemandIndicator> categoryDemand;
  final List<CommercialTrendIndicator> commercialTrends;

  factory DashboardIndicators.fromJson(Map<String, dynamic> json) {
    final monthlySales = json['monthlySales'] as Map<String, dynamic>? ?? const {};
    final stock = json['stock'] as Map<String, dynamic>? ?? const {};
    final topProducts = json['topProducts'] as Map<String, dynamic>? ?? const {};
    final quantity = topProducts['quantity'] as List<dynamic>? ?? const [];
    return DashboardIndicators(
      monthlySales: MonthlySalesIndicator.fromJson(monthlySales),
      stock: StockIndicator.fromJson(stock),
      topProducts: quantity
          .whereType<Map<String, dynamic>>()
          .map(TopProductIndicator.fromJson)
          .take(5)
          .toList(growable: false),
      activeClients: (json['activeClients'] as num?)?.toInt() ?? 0,
      topClients: (json['topClients'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(TopClientIndicator.fromJson)
          .take(5)
          .toList(growable: false),
      categoryDemand: (json['categoryDemand'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CategoryDemandIndicator.fromJson)
          .take(5)
          .toList(growable: false),
      commercialTrends: (json['commercialTrends'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CommercialTrendIndicator.fromJson)
          .toList(growable: false),
    );
  }
}
