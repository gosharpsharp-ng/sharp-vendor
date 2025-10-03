class RestaurantAnalytics {
  final int totalOrders;
  final int pendingOrders;
  final int weeklyOrders;
  final int newOrders;
  final int completedOrders;
  final List<DailyOrder> dailyOrders;
  final String weekStart;
  final String weekEnd;
  final Map<String, String> weekDays;

  RestaurantAnalytics({
    required this.totalOrders,
    required this.pendingOrders,
    required this.weeklyOrders,
    required this.newOrders,
    required this.completedOrders,
    required this.dailyOrders,
    required this.weekStart,
    required this.weekEnd,
    required this.weekDays,
  });

  factory RestaurantAnalytics.fromJson(Map<String, dynamic> json) {
    return RestaurantAnalytics(
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      weeklyOrders: json['weekly_orders'] ?? 0,
      newOrders: json['new_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      dailyOrders: (json['daily_orders'] as List<dynamic>?)
              ?.map((item) => DailyOrder.fromJson(item))
              .toList() ??
          [],
      weekStart: json['week_start'] ?? '',
      weekEnd: json['week_end'] ?? '',
      weekDays: Map<String, String>.from(json['week_days'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'pending_orders': pendingOrders,
      'weekly_orders': weeklyOrders,
      'new_orders': newOrders,
      'completed_orders': completedOrders,
      'daily_orders': dailyOrders.map((item) => item.toJson()).toList(),
      'week_start': weekStart,
      'week_end': weekEnd,
      'week_days': weekDays,
    };
  }

  // Helper methods
  int get totalActiveOrders => pendingOrders + newOrders;

  double get completionRate {
    if (totalOrders == 0) return 0.0;
    return (completedOrders / totalOrders) * 100;
  }

  // Get the highest order count day
  DailyOrder? get peakDay {
    if (dailyOrders.isEmpty) return null;
    return dailyOrders.reduce((current, next) =>
        current.ordersCount > next.ordersCount ? current : next);
  }

  // Get average daily orders for the week
  double get averageDailyOrders {
    if (dailyOrders.isEmpty) return 0.0;
    final total = dailyOrders.fold(0, (sum, day) => sum + day.ordersCount);
    return total / dailyOrders.length;
  }
}

class DailyOrder {
  final String date;
  final String dayName;
  final int dayOfWeek;
  final int ordersCount;

  DailyOrder({
    required this.date,
    required this.dayName,
    required this.dayOfWeek,
    required this.ordersCount,
  });

  factory DailyOrder.fromJson(Map<String, dynamic> json) {
    return DailyOrder(
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      dayOfWeek: json['day_of_week'] ?? 0,
      ordersCount: json['orders_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day_name': dayName,
      'day_of_week': dayOfWeek,
      'orders_count': ordersCount,
    };
  }

  // Helper methods
  DateTime get dateTime => DateTime.parse(date);

  String get shortDayName => dayName.substring(0, 3);

  bool get isToday {
    final now = DateTime.now();
    final orderDate = dateTime;
    return now.year == orderDate.year &&
           now.month == orderDate.month &&
           now.day == orderDate.day;
  }
}