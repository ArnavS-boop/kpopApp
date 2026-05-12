import 'package:antipattern/models/sales_analytics_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';

class SalesAnalyticsPage extends StatelessWidget {
  final String sellerId;

  const SalesAnalyticsPage({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    // TEMP MOCK (replace with backend later)
    final analytics = SalesAnalyticsData(
      totalRevenue: 12450,
      totalOrders: 87,
      revenueSeries: List.generate(
        7,
        (i) => TimeSeriesPoint(
          date: DateTime.now().subtract(Duration(days: 6 - i)),
          value: 200 + (i * 120),
        ),
      ),
      ordersSeries: List.generate(
        7,
        (i) => TimeSeriesPoint(
          date: DateTime.now().subtract(Duration(days: 6 - i)),
          value: 3 + i.toDouble(),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const _SectionTitle("Overview"),
                      const SizedBox(height: 12),

                      _StatCard(
                        title: "Total Revenue",
                        value: "₹${analytics.totalRevenue.toStringAsFixed(0)}",
                        icon: Icons.attach_money_rounded,
                      ),

                      _StatCard(
                        title: "Total Orders",
                        value: analytics.totalOrders.toString(),
                        icon: Icons.shopping_cart_checkout_rounded,
                      ),

                      const SizedBox(height: 30),

                      const _SectionTitle("Performance"),
                      const SizedBox(height: 12),

                      _GraphCard(
                        title: "Revenue (Last 7 Days)",
                        series: analytics.revenueSeries,
                        color: const Color(0xFFB590F7),
                        isCurrency: true,
                      ),

                      const SizedBox(height: 20),

                      _GraphCard(
                        title: "Orders (Last 7 Days)",
                        series: analytics.ordersSeries,
                        color: Colors.blueAccent,
                        isCurrency: false,
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),

            const TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
  final String title;
  final List<TimeSeriesPoint> series;
  final Color color;
  final bool isCurrency;

  const _GraphCard({
    required this.title,
    required this.series,
    required this.color,
    required this.isCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (series.length - 1).toDouble(),
                  minY: 0,
                  maxY: series
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,

                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= series.length) {
                            return const SizedBox.shrink();
                          }

                          final date = series[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${date.day}/${date.month}",
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 3,
                      color: color,
                      spots: series
                          .asMap()
                          .entries
                          .map(
                            (entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value.value,
                            ),
                          )
                          .toList(),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.4),
                            color.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}