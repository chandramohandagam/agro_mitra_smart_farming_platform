class DealerDashboardSummary {
  final int totalOrders;
  final int pendingOrders;
  final double totalRevenue;
  final List<DealerInventoryItem> lowStockItems;
  final List<DealerOrder> recentOrders;

  DealerDashboardSummary({
    required this.totalOrders,
    required this.pendingOrders,
    required this.totalRevenue,
    required this.lowStockItems,
    required this.recentOrders,
  });

  factory DealerDashboardSummary.fromJson(Map<String, dynamic> json) {
    return DealerDashboardSummary(
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0.0).toDouble(),
      lowStockItems: (json['low_stock_items'] as List? ?? []).map((e) => DealerInventoryItem.fromJson(e)).toList(),
      recentOrders: (json['recent_orders'] as List? ?? []).map((e) => DealerOrder.fromJson(e)).toList(),
    );
  }
}

class DealerInventoryItem {
  final String id;
  final String name;
  final int currentStock;
  final String unit;

  DealerInventoryItem({required this.id, required this.name, required this.currentStock, required this.unit});

  factory DealerInventoryItem.fromJson(Map<String, dynamic> json) {
    return DealerInventoryItem(
      id: json['id'],
      name: json['name'] ?? '',
      currentStock: json['current_stock'] ?? 0,
      unit: json['unit'] ?? 'units',
    );
  }
}

class DealerOrder {
  final String id;
  final String customerName;
  final double amount;
  final String status;
  final DateTime date;

  DealerOrder({required this.id, required this.customerName, required this.amount, required this.status, required this.date});

  factory DealerOrder.fromJson(Map<String, dynamic> json) {
    return DealerOrder(
      id: json['id'],
      customerName: json['customer_name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      date: DateTime.parse(json['date']),
    );
  }
}
