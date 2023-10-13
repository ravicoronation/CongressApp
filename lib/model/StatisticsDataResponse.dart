import 'dart:convert';
/// count : 11
/// message : "Success"
/// statistics : [{"id":1,"name":"ac_name","value":"Khairatabad"},{"id":2,"name":"ac_no","value":"60"},{"id":3,"name":"pc_name","value":"Secunderabad"},{"id":4,"name":"pc_no","value":"8"},{"id":5,"name":"total_voters","value":"279542"},{"id":6,"name":"total_male_voters","value":"145970"},{"id":7,"name":"total_female_voters","value":"133549"},{"id":8,"name":"total_trans_voters","value":"23"},{"id":9,"name":"total_parts","value":"304"},{"id":10,"name":"total_tehsils","value":"5"},{"id":11,"name":"total_polling_stations","value":"107"}]

StatisticsDataResponse statisticsDataResponseFromJson(String str) => StatisticsDataResponse.fromJson(json.decode(str));
String statisticsDataResponseToJson(StatisticsDataResponse data) => json.encode(data.toJson());
class StatisticsDataResponse {
  StatisticsDataResponse({
      num? count, 
      String? message, 
      List<Statistics>? statistics,}){
    _count = count;
    _message = message;
    _statistics = statistics;
}

  StatisticsDataResponse.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
    if (json['statistics'] != null) {
      _statistics = [];
      json['statistics'].forEach((v) {
        _statistics?.add(Statistics.fromJson(v));
      });
    }
  }
  num? _count;
  String? _message;
  List<Statistics>? _statistics;
StatisticsDataResponse copyWith({  num? count,
  String? message,
  List<Statistics>? statistics,
}) => StatisticsDataResponse(  count: count ?? _count,
  message: message ?? _message,
  statistics: statistics ?? _statistics,
);
  num? get count => _count;
  String? get message => _message;
  List<Statistics>? get statistics => _statistics;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    if (_statistics != null) {
      map['statistics'] = _statistics?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "ac_name"
/// value : "Khairatabad"

Statistics statisticsFromJson(String str) => Statistics.fromJson(json.decode(str));
String statisticsToJson(Statistics data) => json.encode(data.toJson());
class Statistics {
  Statistics({
      num? id, 
      String? name, 
      String? value,}){
    _id = id;
    _name = name;
    _value = value;
}

  Statistics.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _value = json['value'];
  }
  num? _id;
  String? _name;
  String? _value;
Statistics copyWith({  num? id,
  String? name,
  String? value,
}) => Statistics(  id: id ?? _id,
  name: name ?? _name,
  value: value ?? _value,
);
  num? get id => _id;
  String? get name => _name;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['value'] = _value;
    return map;
  }

}