import 'dart:convert';
/// count : 1
/// message : "Success"
/// workers : [{"id":1,"workerName":"Mahesh","workerPhone":"9898009898","assemblyNumber":"ac000","boothAssigned":"1,2,50,70","isActive":true}]

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
class LoginResponse {
  LoginResponse({
      num? count, 
      String? message, 
      List<Workers>? workers,}){
    _count = count;
    _message = message;
    _workers = workers;
}

  LoginResponse.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
    if (json['workers'] != null) {
      _workers = [];
      json['workers'].forEach((v) {
        _workers?.add(Workers.fromJson(v));
      });
    }
  }
  num? _count;
  String? _message;
  List<Workers>? _workers;
LoginResponse copyWith({  num? count,
  String? message,
  List<Workers>? workers,
}) => LoginResponse(  count: count ?? _count,
  message: message ?? _message,
  workers: workers ?? _workers,
);
  num? get count => _count;
  String? get message => _message;
  List<Workers>? get workers => _workers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    if (_workers != null) {
      map['workers'] = _workers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// workerName : "Mahesh"
/// workerPhone : "9898009898"
/// assemblyNumber : "ac000"
/// boothAssigned : "1,2,50,70"
/// isActive : true

Workers workersFromJson(String str) => Workers.fromJson(json.decode(str));
String workersToJson(Workers data) => json.encode(data.toJson());
class Workers {
  Workers({
      num? id, 
      String? workerName, 
      String? workerPhone, 
      String? assemblyNumber, 
      String? boothAssigned, 
      bool? isActive,}){
    _id = id;
    _workerName = workerName;
    _workerPhone = workerPhone;
    _assemblyNumber = assemblyNumber;
    _boothAssigned = boothAssigned;
    _isActive = isActive;
}

  Workers.fromJson(dynamic json) {
    _id = json['id'];
    _workerName = json['workerName'];
    _workerPhone = json['workerPhone'];
    _assemblyNumber = json['assemblyNumber'];
    _boothAssigned = json['boothAssigned'];
    _isActive = json['isActive'];
  }
  num? _id;
  String? _workerName;
  String? _workerPhone;
  String? _assemblyNumber;
  String? _boothAssigned;
  bool? _isActive;
Workers copyWith({  num? id,
  String? workerName,
  String? workerPhone,
  String? assemblyNumber,
  String? boothAssigned,
  bool? isActive,
}) => Workers(  id: id ?? _id,
  workerName: workerName ?? _workerName,
  workerPhone: workerPhone ?? _workerPhone,
  assemblyNumber: assemblyNumber ?? _assemblyNumber,
  boothAssigned: boothAssigned ?? _boothAssigned,
  isActive: isActive ?? _isActive,
);
  num? get id => _id;
  String? get workerName => _workerName;
  String? get workerPhone => _workerPhone;
  String? get assemblyNumber => _assemblyNumber;
  String? get boothAssigned => _boothAssigned;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['workerName'] = _workerName;
    map['workerPhone'] = _workerPhone;
    map['assemblyNumber'] = _assemblyNumber;
    map['boothAssigned'] = _boothAssigned;
    map['isActive'] = _isActive;
    return map;
  }

}