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
      String? colorCodeHEX,
      String? colorNameV1, 
      num? colorCode,
      num? count}){
    _id = id;
    _colorNameEn = colorNameEn;
    _colorCodeHEX = colorCodeHEX;
    _colorNameV1 = colorNameV1;
    _colorCode = colorCode;
    _count = count;
}

  Colorcode.fromJson(dynamic json) {
    _id = json['id'];
    _colorNameEn = json['colorNameEn'];
    _colorCodeHEX = json['colorCodeHEX'];
    _colorNameV1 = json['colorNameV1'];
    _colorCode = json['colorCode'];
    _count = json['count'];
  }
  num? _id;
  String? _colorNameEn;
  String? _colorCodeHEX;
  String? _colorNameV1;
  num? _colorCode;
  num? _count;
Colorcode copyWith({  num? id,
  String? colorNameEn,
  String? colorCodeHEX,
  String? colorNameV1,
  num? colorCode,
  num? count,
}) => Colorcode(  id: id ?? _id,
  colorNameEn: colorNameEn ?? _colorNameEn,
  colorCodeHEX : colorCodeHEX ?? _colorCodeHEX,
  colorNameV1: colorNameV1 ?? _colorNameV1,
  colorCode: colorCode ?? _colorCode,
    count : count ?? _count,
);
  num? get id => _id;
  String? get colorNameEn => _colorNameEn;
  String? get colorCodeHEX => _colorCodeHEX;
  String? get colorNameV1 => _colorNameV1;
  num? get colorCode => _colorCode;
  num? get count => _count;

  set colorCodeHEX(String? value) {
    _colorCodeHEX = value;
  }

  set count(num? value) {
    _count = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['colorNameEn'] = _colorNameEn;
    map['colorCodeHEX'] = _colorCodeHEX;
    map['colorNameV1'] = _colorNameV1;
    map['colorCode'] = _colorCode;
    map['count'] = _count;
    return map;
  }

}