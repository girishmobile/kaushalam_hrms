import 'package:neeknots_admin/core/constants/string_constant.dart';

enum OrderStatus { pending, processing, shipped, onWay, delivered, cancelled }

class OrderModel {
  final String orderId;
  final String customerName;
  final DateTime orderDate;
  final double totalAmount;
  final List<OrderItem> items;
  final OrderStatus status;

  OrderModel({
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    this.status = OrderStatus.pending,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double price;
  OrderItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

List<OrderModel> sampleOrders = [
  OrderModel(
    orderId: "ORD12345",
    customerName: "John Doe",
    orderDate: DateTime.now().subtract(const Duration(days: 1)),
    totalAmount: 150.75,
    status: OrderStatus.delivered,
    items: [
      OrderItem(
        productId: "PROD1",
        productName: "Product 1",
        imageUrl: productUrl,
        quantity: 2,
        price: 50.00,
      ),
      OrderItem(
        productId: "PROD2",
        productName: "Product 2",
        imageUrl: productUrl1,
        quantity: 1,
        price: 50.75,
      ),
    ],
  ),
  OrderModel(
    orderId: "ORD12346",
    customerName: "Jane Smith",
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    totalAmount: 200.00,
    status: OrderStatus.onWay,
    items: [
      OrderItem(
        productId: "PROD3",
        productName: "Product 3",
        imageUrl: productUrl,
        quantity: 4,
        price: 50.00,
      ),
    ],
  ),
];
