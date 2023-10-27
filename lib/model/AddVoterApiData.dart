import 'dart:convert';
/// workerId : 1
/// voters : [{"id":0,"assemblyNo":30,"voterName":"Rakesh","gender":"M","age":50,"dob":"1973-09-15","mobileNo":"9885099971","whatsappNo":"","address":"test address","houseNo":"1-45","aadhaarNo":"","email":"","referenceName":"","bloodGroup":"","profession":1,"colorCode":2,"facebookUrl":"","instagramUrl":"","twitterUrl":"","otherDetails":""}]

AddVoterApiData addVoterApiDataFromJson(String str) => AddVoterApiData.fromJson(json.decode(str));
String addVoterApiDataToJson(AddVoterApiData data) => json.encode(data.toJson());
class AddVoterApiData {
  AddVoterApiData({
      num? workerId, 
      List<VoterAdd>? voters,}){
    _workerId = workerId;
    _voters = voters;
}

  AddVoterApiData.fromJson(dynamic json) {
    _workerId = json['workerId'];
    if (json['voters'] != null) {
      _voters = [];
      json['voters'].forEach((v) {
        _voters?.add(VoterAdd.fromJson(v));
      });
    }
  }
  num? _workerId;
  List<VoterAdd>? _voters;
AddVoterApiData copyWith({  num? workerId,
  List<VoterAdd>? voters,
}) => AddVoterApiData(  workerId: workerId ?? _workerId,
  voters: voters ?? _voters,
);
  num? get workerId => _workerId;
  List<VoterAdd>? get voters => _voters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerId'] = _workerId;
    if (_voters != null) {
      map['voters'] = _voters?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 0
/// assemblyNo : 30
/// voterName : "Rakesh"
/// gender : "M"
/// age : 50
/// dob : "1973-09-15"
/// mobileNo : "9885099971"
/// whatsappNo : ""
/// address : "test address"
/// houseNo : "1-45"
/// aadhaarNo : ""
/// email : ""
/// referenceName : ""
/// bloodGroup : ""
/// profession : 1
/// colorCode : 2
/// facebookUrl : ""
/// instagramUrl : ""
/// twitterUrl : ""
/// otherDetails : ""

VoterAdd votersFromJson(String str) => VoterAdd.fromJson(json.decode(str));
String votersToJson(VoterAdd data) => json.encode(data.toJson());
class VoterAdd {
  VoterAdd({
      num? id, 
      num? assemblyNo, 
      String? voterName, 
      String? gender, 
      num? age, 
      String? dob, 
      String? mobileNo, 
      String? whatsappNo, 
      String? address, 
      String? houseNo, 
      String? aadhaarNo, 
      String? email, 
      String? referenceName, 
      String? bloodGroup, 
      num? profession, 
      num? colorCode, 
      String? facebookUrl, 
      String? instagramUrl, 
      String? twitterUrl, 
      String? otherDetails,}){
    _id = id;
    _assemblyNo = assemblyNo;
    _voterName = voterName;
    _gender = gender;
    _age = age;
    _dob = dob;
    _mobileNo = mobileNo;
    _whatsappNo = whatsappNo;
    _address = address;
    _houseNo = houseNo;
    _aadhaarNo = aadhaarNo;
    _email = email;
    _referenceName = referenceName;
    _bloodGroup = bloodGroup;
    _profession = profession;
    _colorCode = colorCode;
    _facebookUrl = facebookUrl;
    _instagramUrl = instagramUrl;
    _twitterUrl = twitterUrl;
    _otherDetails = otherDetails;
}

  VoterAdd.fromJson(dynamic json) {
    _id = json['id'];
    _assemblyNo = json['assemblyNo'];
    _voterName = json['voterName'];
    _gender = json['gender'];
    _age = json['age'];
    _dob = json['dob'];
    _mobileNo = json['mobileNo'];
    _whatsappNo = json['whatsappNo'];
    _address = json['address'];
    _houseNo = json['houseNo'];
    _aadhaarNo = json['aadhaarNo'];
    _email = json['email'];
    _referenceName = json['referenceName'];
    _bloodGroup = json['bloodGroup'];
    _profession = json['profession'];
    _colorCode = json['colorCode'];
    _facebookUrl = json['facebookUrl'];
    _instagramUrl = json['instagramUrl'];
    _twitterUrl = json['twitterUrl'];
    _otherDetails = json['otherDetails'];
  }
  num? _id;
  num? _assemblyNo;
  String? _voterName;
  String? _gender;
  num? _age;
  String? _dob;
  String? _mobileNo;
  String? _whatsappNo;
  String? _address;
  String? _houseNo;
  String? _aadhaarNo;
  String? _email;
  String? _referenceName;
  String? _bloodGroup;
  num? _profession;
  num? _colorCode;
  String? _facebookUrl;
  String? _instagramUrl;
  String? _twitterUrl;
  String? _otherDetails;
VoterAdd copyWith({  num? id,
  num? assemblyNo,
  String? voterName,
  String? gender,
  num? age,
  String? dob,
  String? mobileNo,
  String? whatsappNo,
  String? address,
  String? houseNo,
  String? aadhaarNo,
  String? email,
  String? referenceName,
  String? bloodGroup,
  num? profession,
  num? colorCode,
  String? facebookUrl,
  String? instagramUrl,
  String? twitterUrl,
  String? otherDetails,
}) => VoterAdd(  id: id ?? _id,
  assemblyNo: assemblyNo ?? _assemblyNo,
  voterName: voterName ?? _voterName,
  gender: gender ?? _gender,
  age: age ?? _age,
  dob: dob ?? _dob,
  mobileNo: mobileNo ?? _mobileNo,
  whatsappNo: whatsappNo ?? _whatsappNo,
  address: address ?? _address,
  houseNo: houseNo ?? _houseNo,
  aadhaarNo: aadhaarNo ?? _aadhaarNo,
  email: email ?? _email,
  referenceName: referenceName ?? _referenceName,
  bloodGroup: bloodGroup ?? _bloodGroup,
  profession: profession ?? _profession,
  colorCode: colorCode ?? _colorCode,
  facebookUrl: facebookUrl ?? _facebookUrl,
  instagramUrl: instagramUrl ?? _instagramUrl,
  twitterUrl: twitterUrl ?? _twitterUrl,
  otherDetails: otherDetails ?? _otherDetails,
);
  num? get id => _id;
  num? get assemblyNo => _assemblyNo;
  String? get voterName => _voterName;
  String? get gender => _gender;
  num? get age => _age;
  String? get dob => _dob;
  String? get mobileNo => _mobileNo;
  String? get whatsappNo => _whatsappNo;
  String? get address => _address;
  String? get houseNo => _houseNo;
  String? get aadhaarNo => _aadhaarNo;
  String? get email => _email;
  String? get referenceName => _referenceName;
  String? get bloodGroup => _bloodGroup;
  num? get profession => _profession;
  num? get colorCode => _colorCode;
  String? get facebookUrl => _facebookUrl;
  String? get instagramUrl => _instagramUrl;
  String? get twitterUrl => _twitterUrl;
  String? get otherDetails => _otherDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['assemblyNo'] = _assemblyNo;
    map['voterName'] = _voterName;
    map['gender'] = _gender;
    map['age'] = _age;
    map['dob'] = _dob;
    map['mobileNo'] = _mobileNo;
    map['whatsappNo'] = _whatsappNo;
    map['address'] = _address;
    map['houseNo'] = _houseNo;
    map['aadhaarNo'] = _aadhaarNo;
    map['email'] = _email;
    map['referenceName'] = _referenceName;
    map['bloodGroup'] = _bloodGroup;
    map['profession'] = _profession;
    map['colorCode'] = _colorCode;
    map['facebookUrl'] = _facebookUrl;
    map['instagramUrl'] = _instagramUrl;
    map['twitterUrl'] = _twitterUrl;
    map['otherDetails'] = _otherDetails;
    return map;
  }

}