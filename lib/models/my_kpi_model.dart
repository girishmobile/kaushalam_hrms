class MyKpiModel {
  num? month;
  num? percent;

  MyKpiModel({this.month, this.percent});

  MyKpiModel.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['percent'] = percent;
    return data;
  }
}
