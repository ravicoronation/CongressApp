import 'dart:convert';
/// count : 1
/// message : "Success"
/// voters : [{"id":4,"status":"Success","message":"Voter Data Saved"}]

AddVoterResponseModel addVoterResponseModelFromJson(String str) => AddVoterResponseModel.fromJson(json.decode(str));
String addVoterResponseModelToJson(AddVoterResponseModel data) => json.encode(data.toJson());
class AddVoterResponseModel {
  AddVoterResponseModel({
      num? count, 
      String? message, 
      List<Voters>? voters,}){
    _count = count;
    _message = message;
    _voters = voters;
}

  AddVoterResponseModel.fromJson(dynamic json) {
    _count = json['count'];
    _message = json['message'];
    if (json['voters'] != null) {
      _voters = [];
      json['voters'].forEach((v) {
        _voters?.add(Voters.fromJson(v));
      });
    }
  }
  num? _count;
  String? _message;
  List<Voters>? _voters;
AddVoterResponseModel copyWith({  num? count,
  String? message,
  List<Voters>? voters,
}) => AddVoterResponseModel(  count: count ?? _count,
  message: message ?? _message,
  voters: voters ?? _voters,
);
  num? get count => _count;
  String? get message => _message;
  List<Voters>? get voters => _voters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['message'] = _message;
    if (_voters != null) {
      map['voters'] = _voters?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 4
/// status : "Success"
/// message : "Voter Data Saved"

Voters votersFromJson(String str) => Voters.fromJson(json.decode(str));
String votersToJson(Voters data) => json.encode(data.toJson());
class Voters {
  Voters({
      num? id, 
      String? status, 
      String? message,}){
    _id = id;
    _status = status;
    _message = message;
}

  Voters.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _message = json['message'];
  }
  num? _id;
  String? _status;
  String? _message;
Voters copyWith({  num? id,
  String? status,
  String? message,
}) => Voters(  id: id ?? _id,
  status: status ?? _status,
  message: message ?? _message,
);
  num? get id => _id;
  String? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}