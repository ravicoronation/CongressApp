import 'dart:convert';
/// count : 7
/// message : "Success"
/// professions : [{"id":1,"professionNameEn":"Job","professionNameV1":""}]

ProfessionListResponse professionListResponseFromJson(String str) => ProfessionListResponse.fromJson(json.decode(str));
String professionListResponseToJson(ProfessionListResponse data) => json.encode(data.toJson());
class ProfessionListResponse {
  ProfessionListResponse({
      num? count, 
      String? message, 
      List<Professions>? professions,}){
    _count = count;
    _message = message;
    _professions = professions;
}

  ProfessionListResponse.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
    if (json['colorcode'] != null) {
      _professions = [];
      json['colorcode'].forEach((v) {
        _professions?.add(Professions.fromJson(v));
      });
    }
  }
  num? _count;
  String? _message;
  List<Professions>? _professions;
ProfessionListResponse copyWith({  num? count,
  String? message,
  List<Professions>? professions,
}) => ProfessionListResponse(  count: count ?? _count,
  message: message ?? _message,
  professions: professions ?? _professions,
);
  num? get count => _count;
  String? get message => _message;
  List<Professions>? get professions => _professions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    if (_professions != null) {
      map['colorcode'] = _professions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// professionNameEn : "Job"
/// professionNameV1 : ""

Professions professionsFromJson(String str) => Professions.fromJson(json.decode(str));
String professionsToJson(Professions data) => json.encode(data.toJson());
class Professions {
  Professions({
      num? id, 
      String? professionNameEn, 
      String? professionNameV1,}){
    _id = id;
    _professionNameEn = professionNameEn;
    _professionNameV1 = professionNameV1;
}

  Professions.fromJson(dynamic json) {
    _id = json['id'];
    _professionNameEn = json['professionNameEn'];
    _professionNameV1 = json['professionNameV1'];
  }
  num? _id;
  String? _professionNameEn;
  String? _professionNameV1;
Professions copyWith({  num? id,
  String? professionNameEn,
  String? professionNameV1,
}) => Professions(  id: id ?? _id,
  professionNameEn: professionNameEn ?? _professionNameEn,
  professionNameV1: professionNameV1 ?? _professionNameV1,
);
  num? get id => _id;
  String? get professionNameEn => _professionNameEn;
  String? get professionNameV1 => _professionNameV1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['professionNameEn'] = _professionNameEn;
    map['professionNameV1'] = _professionNameV1;
    return map;
  }

}