import 'package:antipattern/widgets/glass_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/search_bar.dart';
import 'package:antipattern/widgets/order_item_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController _controller = TextEditingController();
  String query = "";

  // TEMP orders (replace later with real order model)
  List<Listings> get _orders => dummyListings.take(6).toList();

  List<Listings> get _filteredOrders {
    if (query.isEmpty) return _orders;

    final q = query.toLowerCase();

    return _orders.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.sellerName.toLowerCase().contains(q) ||
          (item.group ?? "").toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredOrders;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              children: [
                /// HEADER
                Row(
                  children: [
                    GlassCircleIcon(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppSearchBar(
                        controller: _controller,
                        hint: "Search orders...",
                        onChanged: (value) {
                          setState(() => query = value.trim());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// CONTENT
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Text(
                            "You have no orders yet",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 30),
                          itemCount: results.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) =>
                              OrderItemCard(item: results[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}