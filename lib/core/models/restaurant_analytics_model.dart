class RestaurantAnalyticsStats {
  final Summary summary;
  final List<DailyBreakdown> dailyBreakdown;
  final OrderStatusBreakdown orderStatusBreakdown;
  final List<TopPerformingDay> topPerformingDays;
  final PeakPerformance peakPerformance;

  RestaurantAnalyticsStats({
    required this.summary,
    required this.dailyBreakdown,
    required this.orderStatusBreakdown,
    required this.topPerformingDays,
    required this.peakPerformance,
  });

  factory RestaurantAnalyticsStats.fromJson(Map<String, dynamic> json) {
    return RestaurantAnalyticsStats(
      summary: Summary.fromJson(json['summary'] ?? {}),
      dailyBreakdown: (json['daily_breakdown'] as List<dynamic>?)
              ?.map((item) => DailyBreakdown.fromJson(item))
              .toList() ??
          [],
      orderStatusBreakdown: OrderStatusBreakdown.fromJson(
          json['order_status_breakdown'] ?? {}),
      topPerformingDays: (json['top_performing_days'] as List<dynamic>?)
              ?.map((item) => TopPerformingDay.fromJson(item))
              .toList() ??
          [],
      peakPerformance:
          PeakPerformance.fromJson(json['peak_performance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'daily_breakdown': dailyBreakdown.map((item) => item.toJson()).toList(),
      'order_status_breakdown': orderStatusBreakdown.toJson(),
      'top_performing_days':
          topPerformingDays.map((item) => item.toJson()).toList(),
      'peak_performance': peakPerformance.toJson(),
    };
  }
}

class Summary {
  final double totalRevenue;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int pendingOrders;
  final double averageOrderValue;
  final double completionRate;
  final double cancellationRate;
  final PreviousPeriod previousPeriod;
  final PercentageChanges percentageChanges;

  Summary({
    required this.totalRevenue,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.pendingOrders,
    required this.averageOrderValue,
    required this.completionRate,
    required this.cancellationRate,
    required this.previousPeriod,
    required this.percentageChanges,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalRevenue: (json['total_revenue'] ?? 0.0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      averageOrderValue: (json['average_order_value'] ?? 0.0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
      cancellationRate: (json['cancellation_rate'] ?? 0.0).toDouble(),
      previousPeriod:
          PreviousPeriod.fromJson(json['previous_period'] ?? {}),
      percentageChanges:
          PercentageChanges.fromJson(json['percentage_changes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'cancelled_orders': cancelledOrders,
      'pending_orders': pendingOrders,
      'average_order_value': averageOrderValue,
      'completion_rate': completionRate,
      'cancellation_rate': cancellationRate,
      'previous_period': previousPeriod.toJson(),
      'percentage_changes': percentageChanges.toJson(),
    };
  }
}

class PreviousPeriod {
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final double completionRate;

  PreviousPeriod({
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.completionRate,
  });

  factory PreviousPeriod.fromJson(Map<String, dynamic> json) {
    return PreviousPeriod(
      totalRevenue: (json['total_revenue'] ?? 0.0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      averageOrderValue: (json['average_order_value'] ?? 0.0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
      'average_order_value': averageOrderValue,
      'completion_rate': completionRate,
    };
  }
}

class PercentageChanges {
  final double revenueChange;
  final double ordersChange;
  final double aovChange;
  final double completionRateChange;

  PercentageChanges({
    required this.revenueChange,
    required this.ordersChange,
    required this.aovChange,
    required this.completionRateChange,
  });

  factory PercentageChanges.fromJson(Map<String, dynamic> json) {
    return PercentageChanges(
      revenueChange: (json['revenue_change'] ?? 0.0).toDouble(),
      ordersChange: (json['orders_change'] ?? 0.0).toDouble(),
      aovChange: (json['aov_change'] ?? 0.0).toDouble(),
      completionRateChange:
          (json['completion_rate_change'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue_change': revenueChange,
      'orders_change': ordersChange,
      'aov_change': aovChange,
      'completion_rate_change': completionRateChange,
    };
  }
}

class DailyBreakdown {
  final String date;
  final String dayName;
  final double revenue;
  final int orders;
  final int completed;
  final int cancelled;
  final int pending;

  DailyBreakdown({
    required this.date,
    required this.dayName,
    required this.revenue,
    required this.orders,
    required this.completed,
    required this.cancelled,
    required this.pending,
  });

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) {
    return DailyBreakdown(
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      orders: json['orders'] ?? 0,
      completed: json['completed'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day_name': dayName,
      'revenue': revenue,
      'orders': orders,
      'completed': completed,
      'cancelled': cancelled,
      'pending': pending,
    };
  }

  // Helper methods
  DateTime get dateTime => DateTime.parse(date);

  String get shortDayName =>
      dayName.length >= 3 ? dayName.substring(0, 3) : dayName;

  bool get isToday {
    final now = DateTime.now();
    final orderDate = dateTime;
    return now.year == orderDate.year &&
        now.month == orderDate.month &&
        now.day == orderDate.day;
  }
}

class OrderStatusBreakdown {
  final int completed;
  final int pending;
  final int cancelled;
  final int rejected;
  final int preparing;
  final int ready;
  final int inTransit;
  final int total;

  OrderStatusBreakdown({
    required this.completed,
    required this.pending,
    required this.cancelled,
    required this.rejected,
    required this.preparing,
    required this.ready,
    required this.inTransit,
    required this.total,
  });

  factory OrderStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return OrderStatusBreakdown(
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      rejected: json['rejected'] ?? 0,
      preparing: json['preparing'] ?? 0,
      ready: json['ready'] ?? 0,
      inTransit: json['in_transit'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
      'pending': pending,
      'cancelled': cancelled,
      'rejected': rejected,
      'preparing': preparing,
      'ready': ready,
      'in_transit': inTransit,
      'total': total,
    };
  }

  // Helper method to get completion percentage
  double get completionPercentage {
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  // Helper method to get cancellation percentage
  double get cancellationPercentage {
    if (total == 0) return 0.0;
    return (cancelled / total) * 100;
  }
}

class TopPerformingDay {
  final String date;
  final String dayName;
  final int orders;
  final double revenue;
  final double averageOrderValue;

  TopPerformingDay({
    required this.date,
    required this.dayName,
    required this.orders,
    required this.revenue,
    required this.averageOrderValue,
  });

  factory TopPerformingDay.fromJson(Map<String, dynamic> json) {
    return TopPerformingDay(
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      orders: json['orders'] ?? 0,
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      averageOrderValue: (json['average_order_value'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day_name': dayName,
      'orders': orders,
      'revenue': revenue,
      'average_order_value': averageOrderValue,
    };
  }

  // Helper methods
  DateTime get dateTime => DateTime.parse(date);
}

class PeakPerformance {
  final String bestDayOfWeek;
  final String bestTimeOfDay;
  final String? peakDayDate;
  final int peakDayOrders;
  final double peakDayRevenue;

  PeakPerformance({
    required this.bestDayOfWeek,
    required this.bestTimeOfDay,
    this.peakDayDate,
    required this.peakDayOrders,
    required this.peakDayRevenue,
  });

  factory PeakPerformance.fromJson(Map<String, dynamic> json) {
    return PeakPerformance(
      bestDayOfWeek: json['best_day_of_week'] ?? 'N/A',
      bestTimeOfDay: json['best_time_of_day'] ?? 'N/A',
      peakDayDate: json['peak_day_date'],
      peakDayOrders: json['peak_day_orders'] ?? 0,
      peakDayRevenue: (json['peak_day_revenue'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'best_day_of_week': bestDayOfWeek,
      'best_time_of_day': bestTimeOfDay,
      'peak_day_date': peakDayDate,
      'peak_day_orders': peakDayOrders,
      'peak_day_revenue': peakDayRevenue,
    };
  }
}

// Keep old model for backward compatibility with dashboard
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
