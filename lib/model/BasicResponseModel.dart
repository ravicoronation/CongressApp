import 'dart:convert';
/// count : 2
/// message : "Success"

BasicResponseModel basicResponseModelFromJson(String str) => BasicResponseModel.fromJson(json.decode(str));
String basicResponseModelToJson(BasicResponseModel data) => json.encode(data.toJson());
class BasicResponseModel {
  BasicResponseModel({
      num? count, 
      String? message,}){
    _count = count;
    _message = message;
}

  BasicResponseModel.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
  }
  num? _count;
  String? _message;
BasicResponseModel copyWith({  num? count,
  String? message,
}) => BasicResponseModel(  count: count ?? _count,
  message: message ?? _message,
);
  num? get count => _count;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    return map;
  }

}