class TimeSeriesPoint {
  final DateTime date;
  final double value;

  const TimeSeriesPoint({
    required this.date,
    required this.value,
  });
}

class SalesAnalyticsData {
  final double totalRevenue;
  final int totalOrders;
  final List<TimeSeriesPoint> revenueSeries;
  final List<TimeSeriesPoint> ordersSeries;

  const SalesAnalyticsData({
    required this.totalRevenue,
    required this.totalOrders,
    required this.revenueSeries,
    required this.ordersSeries,
  });
}

final mockAnalytics = SalesAnalyticsData(
  totalRevenue: 17840.0,
  totalOrders: 132,

  revenueSeries: [
    TimeSeriesPoint(
      date: DateTime(2026, 2, 20),
      value: 1200,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 21),
      value: 950,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 22),
      value: 1500,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 23),
      value: 1800,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 24),
      value: 2100,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 25),
      value: 2300,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 26),
      value: 2600,
    ),
  ],

  ordersSeries: [
    TimeSeriesPoint(
      date: DateTime(2026, 2, 20),
      value: 5,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 21),
      value: 4,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 22),
      value: 6,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 23),
      value: 8,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 24),
      value: 9,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 25),
      value: 11,
    ),
    TimeSeriesPoint(
      date: DateTime(2026, 2, 26),
      value: 13,
    ),
  ],
);