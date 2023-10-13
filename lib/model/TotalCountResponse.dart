import 'dart:convert';
/// count : 304
/// message : "Success"

TotalCountResponse totalCountResponseFromJson(String str) => TotalCountResponse.fromJson(json.decode(str));
String totalCountResponseToJson(TotalCountResponse data) => json.encode(data.toJson());
class TotalCountResponse {
  TotalCountResponse({
      int? count, 
      String? message,}){
    _count = count;
    _message = message;
}

  TotalCountResponse.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
  }
  int? _count;
  String? _message;
TotalCountResponse copyWith({  int? count,
  String? message,
}) => TotalCountResponse(  count: count ?? _count,
  message: message ?? _message,
);
  int? get count => _count;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    return map;
  }

}