import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neeknots_admin/components/components.dart';
import 'package:neeknots_admin/models/order_model.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late PageController _pageController;
  int _currentPage = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 🔹 Auto scroll every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && widget.order.items.isNotEmpty) {
        int nextPage = (_currentPage + 1) % widget.order.items.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Product Image Carousel
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.order.items.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final item = widget.order.items[index];
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: loadNetworkImage(
                    imageUrl: item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          /**
   * Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
   */
          // 🔹 Page Indicator (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.order.items.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                width: _currentPage == index ? 10 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.black26,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          // 🔹 Order Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${widget.order.orderId}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total-\$${widget.order.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Qty: ${widget.order.items.fold<int>(0, (sum, item) => sum + item.quantity)}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "16-sept-25 10:30 AM",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  "Delivered",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
