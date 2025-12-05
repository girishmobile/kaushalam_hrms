class HotlineCountModel {
  final String title; // This will hold the key, like "online"
  final dynamic count; // This will hold the value, like 78

  HotlineCountModel({
    required this.title,
    required this.count,
  });

  factory HotlineCountModel.fromJson(String key, dynamic value) {
    return HotlineCountModel(
      title: key,
      count: value,
    );
  }
}