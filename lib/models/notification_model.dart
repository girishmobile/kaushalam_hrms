class NotificationModel {
  final String title;
  final String message;
  final DateTime time;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
  });
}

final List<NotificationModel> listOfnotification = [
  NotificationModel(
    title: "New Order",
    message: "Order #1234 has been placed",
    time: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  NotificationModel(
    title: "Order Shipped",
    message: "Order #1229 has been shipped",
    time: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  NotificationModel(
    title: "Order Delivered",
    message: "Order #1223 delivered successfully",
    time: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  NotificationModel(
    title: "New Customer",
    message: "John Doe just signed up",
    time: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NotificationModel(
    title: "Payment Received",
    message: "Payment for order #1234 confirmed",
    time: DateTime.now().subtract(const Duration(hours: 7)),
  ),
  NotificationModel(
    title: "Order Cancelled",
    message: "Order #1225 has been cancelled by customer",
    time: DateTime.now().subtract(const Duration(days: 2)),
  ),
  NotificationModel(
    title: "Low Stock Alert",
    message: "Product 'Sneakers' stock is below 5 items",
    time: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
  ),
  NotificationModel(
    title: "Product Review",
    message: "Customer rated 'Blue Denim Jacket' 5 stars",
    time: DateTime.now().subtract(const Duration(hours: 10)),
  ),
  NotificationModel(
    title: "Order Returned",
    message: "Return request for order #1218 approved",
    time: DateTime.now().subtract(const Duration(days: 3)),
  ),
  NotificationModel(
    title: "New Subscriber",
    message: "Emma joined the newsletter list",
    time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
  NotificationModel(
    title: "Discount Offer",
    message: "Weekend sale: 20% off on all electronics",
    time: DateTime.now().subtract(const Duration(days: 4)),
  ),
  NotificationModel(
    title: "Order Processing",
    message: "Order #1237 is being prepared for shipment",
    time: DateTime.now().subtract(const Duration(minutes: 45)),
  ),
  NotificationModel(
    title: "Refund Issued",
    message: "Refund for order #1209 processed successfully",
    time: DateTime.now().subtract(const Duration(days: 5)),
  ),
  NotificationModel(
    title: "Order Delivered",
    message: "Order #1231 delivered to customer address",
    time: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  NotificationModel(
    title: "Price Drop Alert",
    message: "‘Leather Wallet’ price dropped by 15%",
    time: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
  ),
  NotificationModel(
    title: "Inventory Updated",
    message: "New stock added for ‘Running Shoes’",
    time: DateTime.now().subtract(const Duration(hours: 9)),
  ),
  NotificationModel(
    title: "New Order",
    message: "Order #1240 placed successfully",
    time: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  NotificationModel(
    title: "Order Shipped",
    message: "Order #1235 has been shipped",
    time: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  NotificationModel(
    title: "Customer Feedback",
    message: "Liam left feedback on your service",
    time: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
  ),
  NotificationModel(
    title: "New Message",
    message: "Support ticket #3042: Customer replied",
    time: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
];
