import 'dart:convert';
/// count : 5
/// message : "Success"
/// colorcode : [{"id":1,"colorNameEn":"Congress","colorNameV1":"","colorCode":1}]

ColorCodeResponseModel colorCodeResponseModelFromJson(String str) => ColorCodeResponseModel.fromJson(json.decode(str));
String colorCodeResponseModelToJson(ColorCodeResponseModel data) => json.encode(data.toJson());
class ColorCodeResponseModel {
  ColorCodeResponseModel({
      num? count, 
      String? message, 
      List<Colorcode>? colorcode,}){
    _count = count;
    _message = message;
    _colorcode = colorcode;
}

  ColorCodeResponseModel.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
    if (json['colorcode'] != null) {
      _colorcode = [];
      json['colorcode'].forEach((v) {
        _colorcode?.add(Colorcode.fromJson(v));
      });
    }
  }
  num? _count;
  String? _message;
  List<Colorcode>? _colorcode;
ColorCodeResponseModel copyWith({  num? count,
  String? message,
  List<Colorcode>? colorcode,
}) => ColorCodeResponseModel(  count: count ?? _count,
  message: message ?? _message,
  colorcode: colorcode ?? _colorcode,
);
  num? get count => _count;
  String? get message => _message;
  List<Colorcode>? get colorcode => _colorcode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    if (_colorcode != null) {
      map['colorcode'] = _colorcode?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// colorNameEn : "Congress"
/// colorNameV1 : ""
/// colorCode : 1

Colorcode colorcodeFromJson(String str) => Colorcode.fromJson(json.decode(str));
String colorcodeToJson(Colorcode data) => json.encode(data.toJson());
class Colorcode {
  Colorcode({
      num? id, 
      String? colorNameEn, 
      String? colorNameV1, 
      num? colorCode,}){
    _id = id;
    _colorNameEn = colorNameEn;
    _colorNameV1 = colorNameV1;
    _colorCode = colorCode;
}

  Colorcode.fromJson(dynamic json) {
    _id = json['id'];
    _colorNameEn = json['colorNameEn'];
    _colorNameV1 = json['colorNameV1'];
    _colorCode = json['colorCode'];
  }
  num? _id;
  String? _colorNameEn;
  String? _colorNameV1;
  num? _colorCode;
Colorcode copyWith({  num? id,
  String? colorNameEn,
  String? colorNameV1,
  num? colorCode,
}) => Colorcode(  id: id ?? _id,
  colorNameEn: colorNameEn ?? _colorNameEn,
  colorNameV1: colorNameV1 ?? _colorNameV1,
  colorCode: colorCode ?? _colorCode,
);
  num? get id => _id;
  String? get colorNameEn => _colorNameEn;
  String? get colorNameV1 => _colorNameV1;
  num? get colorCode => _colorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['colorNameEn'] = _colorNameEn;
    map['colorNameV1'] = _colorNameV1;
    map['colorCode'] = _colorCode;
    return map;
  }

}