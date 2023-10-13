import 'dart:convert';

import 'package:congress_app/utils/app_utils.dart';
/// count : 929
/// message : "Success"
/// voters : [{"id":1,"acNo":72,"partNo":1,"sectionNo":3,"slnoinpart":765,"fullNameEn":"C Konda Jamuna -H- Srinivas","fullNameV1":"సీ కొండ జమున -H- శ్రీనివాస్","fmNameEn":"C Konda Jamuna","lastnameEn":"","fmNameV1":"సీ కొండ జమున","lastnameV1":"","rlnType":"H","rlnFmNmEn":"Srinivas","rlnLNmEn":"","rlnFmNmV1":"శ్రీనివాస్","rlnLNmV1":"","epicNo":"ZUE1141688","gender":"F","age":"44","dob":"1979-01-01","mobileNo":"+918790412964","pcNo":11,"pcnameEn":"Mahabubnagar","pcnameV1":"మహబూబ్ నగర్","acNameEn":"Kodangal","acNameV1":"కొడంగల్","sectionNameV1":"య సి కాలనీ","sectionNameEn":"S C Colony","villageNameEn":"0","villageNameV1":"0","postoffNameEn":"Nagasar","postoffNameV1":"నాగాసార్","postoffPin":"509336","partNameEn":"Nagsar","partNameV1":"నాగాసార్","psbuildingNameEn":"Mandal Parishat Primary School","psbuildingNo":170,"psbuildingNameV1":"మండల పరిషత్ ప్రాధమిక పాఠశాల","tahsilNameEn":"Doulatabad","tahsilNameV1":"దౌల్తాబాద్","policestNameEn":"Doulatabad","policestNameV1":"దౌల్తాబాద్","isDuplicate":false,"whatsappNo":"","newAddress":"","aadhaarNo":"","isDead":false,"isVisited":false,"hasVoted":false,"email":"","referenceName":"","bloodGroup":"","profession":"","facebookUrl":"","instagramUrl":"","twitterUrl":"","otherDetails":"","chouseNo":"1-182A","chouseNoV1":"1-182ఏ"}]

VoterListResponse voterListResponseFromJson(String str) => VoterListResponse.fromJson(json.decode(str));
String voterListResponseToJson(VoterListResponse data) => json.encode(data.toJson());
class VoterListResponse {
  VoterListResponse({
      num? count, 
      String? message, 
      List<Voters>? voters,}){
    _count = count;
    _message = message;
    _voters = voters;
}

  VoterListResponse.fromJson(dynamic json) {
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
VoterListResponse copyWith({  num? count,
  String? message,
  List<Voters>? voters,
}) => VoterListResponse(  count: count ?? _count,
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

/// id : 1
/// acNo : 72
/// partNo : 1
/// sectionNo : 3
/// slnoinpart : 765
/// fullNameEn : "C Konda Jamuna -H- Srinivas"
/// fullNameV1 : "సీ కొండ జమున -H- శ్రీనివాస్"
/// fmNameEn : "C Konda Jamuna"
/// lastnameEn : ""
/// fmNameV1 : "సీ కొండ జమున"
/// lastnameV1 : ""
/// rlnType : "H"
/// rlnFmNmEn : "Srinivas"
/// rlnLNmEn : ""
/// rlnFmNmV1 : "శ్రీనివాస్"
/// rlnLNmV1 : ""
/// epicNo : "ZUE1141688"
/// gender : "F"
/// age : "44"
/// dob : "1979-01-01"
/// mobileNo : "+918790412964"
/// pcNo : 11
/// pcnameEn : "Mahabubnagar"
/// pcnameV1 : "మహబూబ్ నగర్"
/// acNameEn : "Kodangal"
/// acNameV1 : "కొడంగల్"
/// sectionNameV1 : "య సి కాలనీ"
/// sectionNameEn : "S C Colony"
/// villageNameEn : "0"
/// villageNameV1 : "0"
/// postoffNameEn : "Nagasar"
/// postoffNameV1 : "నాగాసార్"
/// postoffPin : "509336"
/// partNameEn : "Nagsar"
/// partNameV1 : "నాగాసార్"
/// psbuildingNameEn : "Mandal Parishat Primary School"
/// psbuildingNo : 170
/// psbuildingNameV1 : "మండల పరిషత్ ప్రాధమిక పాఠశాల"
/// tahsilNameEn : "Doulatabad"
/// tahsilNameV1 : "దౌల్తాబాద్"
/// policestNameEn : "Doulatabad"
/// policestNameV1 : "దౌల్తాబాద్"
/// isDuplicate : false
/// whatsappNo : ""
/// newAddress : ""
/// aadhaarNo : ""
/// isDead : false
/// isVisited : false
/// hasVoted : false
/// email : ""
/// referenceName : ""
/// bloodGroup : ""
/// profession : ""
/// facebookUrl : ""
/// instagramUrl : ""
/// twitterUrl : ""
/// otherDetails : ""
/// chouseNo : "1-182A"
/// chouseNoV1 : "1-182ఏ"

Voters votersFromJson(String str) => Voters.fromJson(json.decode(str));
String votersToJson(Voters data) => json.encode(data.toJson());
class Voters {
  Voters({
      num? id, 
      num? acNo, 
      num? partNo, 
      num? sectionNo, 
      num? slnoinpart, 
      String? fullNameEn, 
      String? fullNameV1, 
      String? fmNameEn, 
      String? lastnameEn, 
      String? fmNameV1, 
      String? lastnameV1, 
      String? rlnType, 
      String? rlnFmNmEn, 
      String? rlnLNmEn, 
      String? rlnFmNmV1, 
      String? rlnLNmV1, 
      String? epicNo, 
      String? gender, 
      String? age, 
      String? dob, 
      String? mobileNo, 
      num? pcNo, 
      String? pcnameEn, 
      String? pcnameV1, 
      String? acNameEn, 
      String? acNameV1, 
      String? sectionNameV1, 
      String? sectionNameEn, 
      String? villageNameEn, 
      String? villageNameV1, 
      String? postoffNameEn, 
      String? postoffNameV1, 
      String? postoffPin, 
      String? partNameEn, 
      String? partNameV1, 
      String? psbuildingNameEn, 
      num? psbuildingNo, 
      String? psbuildingNameV1, 
      String? tahsilNameEn, 
      String? tahsilNameV1, 
      String? policestNameEn, 
      String? policestNameV1, 
      bool? isDuplicate, 
      String? whatsappNo, 
      String? newAddress, 
      String? aadhaarNo, 
      bool? isDead, 
      bool? isVisited, 
      bool? hasVoted, 
      String? email, 
      String? referenceName, 
      String? bloodGroup, 
      String? profession, 
      String? facebookUrl, 
      String? instagramUrl, 
      String? twitterUrl, 
      String? otherDetails, 
      String? chouseNo, 
      String? chouseNoV1,}){
    _id = id;
    _acNo = acNo;
    _partNo = partNo;
    _sectionNo = sectionNo;
    _slnoinpart = slnoinpart;
    _fullNameEn = fullNameEn;
    _fullNameV1 = fullNameV1;
    _fmNameEn = fmNameEn;
    _lastnameEn = lastnameEn;
    _fmNameV1 = fmNameV1;
    _lastnameV1 = lastnameV1;
    _rlnType = rlnType;
    _rlnFmNmEn = rlnFmNmEn;
    _rlnLNmEn = rlnLNmEn;
    _rlnFmNmV1 = rlnFmNmV1;
    _rlnLNmV1 = rlnLNmV1;
    _epicNo = epicNo;
    _gender = gender;
    _age = age;
    _dob = dob;
    _mobileNo = mobileNo;
    _pcNo = pcNo;
    _pcnameEn = pcnameEn;
    _pcnameV1 = pcnameV1;
    _acNameEn = acNameEn;
    _acNameV1 = acNameV1;
    _sectionNameV1 = sectionNameV1;
    _sectionNameEn = sectionNameEn;
    _villageNameEn = villageNameEn;
    _villageNameV1 = villageNameV1;
    _postoffNameEn = postoffNameEn;
    _postoffNameV1 = postoffNameV1;
    _postoffPin = postoffPin;
    _partNameEn = partNameEn;
    _partNameV1 = partNameV1;
    _psbuildingNameEn = psbuildingNameEn;
    _psbuildingNo = psbuildingNo;
    _psbuildingNameV1 = psbuildingNameV1;
    _tahsilNameEn = tahsilNameEn;
    _tahsilNameV1 = tahsilNameV1;
    _policestNameEn = policestNameEn;
    _policestNameV1 = policestNameV1;
    _isDuplicate = isDuplicate;
    _whatsappNo = whatsappNo;
    _newAddress = newAddress;
    _aadhaarNo = aadhaarNo;
    _isDead = isDead;
    _isVisited = isVisited;
    _hasVoted = hasVoted;
    _email = email;
    _referenceName = referenceName;
    _bloodGroup = bloodGroup;
    _profession = profession;
    _facebookUrl = facebookUrl;
    _instagramUrl = instagramUrl;
    _twitterUrl = twitterUrl;
    _otherDetails = otherDetails;
    _chouseNo = chouseNo;
    _chouseNoV1 = chouseNoV1;
}

  Voters.fromJson(dynamic json) {
    _id = json['id'];
    _acNo = json['acNo'];
    _partNo = json['partNo'];
    _sectionNo = json['sectionNo'];
    _slnoinpart = json['slnoinpart'];
    _fullNameEn = json['fullNameEn'];
    _fullNameV1 = json['fullNameV1'];
    _fmNameEn = json['fmNameEn'];
    _lastnameEn = json['lastnameEn'];
    _fmNameV1 = json['fmNameV1'];
    _lastnameV1 = json['lastnameV1'];
    _rlnType = json['rlnType'];
    _rlnFmNmEn = json['rlnFmNmEn'];
    _rlnLNmEn = json['rlnLNmEn'];
    _rlnFmNmV1 = json['rlnFmNmV1'];
    _rlnLNmV1 = json['rlnLNmV1'];
    _epicNo = json['epicNo'];
    _gender = json['gender'];
    _age = json['age'];
    _dob = json['dob'];
    _mobileNo = json['mobileNo'];
    _pcNo = json['pcNo'];
    _pcnameEn = json['pcnameEn'];
    _pcnameV1 = json['pcnameV1'];
    _acNameEn = json['acNameEn'];
    _acNameV1 = json['acNameV1'];
    _sectionNameV1 = json['sectionNameV1'];
    _sectionNameEn = json['sectionNameEn'];
    _villageNameEn = json['villageNameEn'];
    _villageNameV1 = json['villageNameV1'];
    _postoffNameEn = json['postoffNameEn'];
    _postoffNameV1 = json['postoffNameV1'];
    _postoffPin = json['postoffPin'];
    _partNameEn = json['partNameEn'];
    _partNameV1 = json['partNameV1'];
    _psbuildingNameEn = json['psbuildingNameEn'];
    _psbuildingNo = json['psbuildingNo'];
    _psbuildingNameV1 = json['psbuildingNameV1'];
    _tahsilNameEn = json['tahsilNameEn'];
    _tahsilNameV1 = json['tahsilNameV1'];
    _policestNameEn = json['policestNameEn'];
    _policestNameV1 = json['policestNameV1'];
    _isDuplicate = json['isDuplicate']  == 1 ? true : false;
    _whatsappNo = json['whatsappNo'];
    _newAddress = json['newAddress'];
    _aadhaarNo = json['aadhaarNo'];
    _isDead = json['isDead'] == 1 ? true : false;
    _isVisited = json['isVisited'] == 1 ? true : false;
    _hasVoted = json['hasVoted'] == 1 ? true : false;
    _email = json['email'];
    _referenceName = json['referenceName'];
    _bloodGroup = json['bloodGroup'];
    _profession = json['profession'];
    _facebookUrl = json['facebookUrl'];
    _instagramUrl = json['instagramUrl'];
    _twitterUrl = json['twitterUrl'];
    _otherDetails = json['otherDetails'];
    _chouseNo = json['chouseNo'];
    _chouseNoV1 = json['chouseNoV1'];
  }
  num? _id;
  num? _acNo;
  num? _partNo;
  num? _sectionNo;
  num? _slnoinpart;
  String? _fullNameEn;
  String? _fullNameV1;
  String? _fmNameEn;
  String? _lastnameEn;
  String? _fmNameV1;
  String? _lastnameV1;
  String? _rlnType;
  String? _rlnFmNmEn;
  String? _rlnLNmEn;
  String? _rlnFmNmV1;
  String? _rlnLNmV1;
  String? _epicNo;
  String? _gender;
  String? _age;
  String? _dob;
  String? _mobileNo;
  num? _pcNo;
  String? _pcnameEn;
  String? _pcnameV1;
  String? _acNameEn;
  String? _acNameV1;
  String? _sectionNameV1;
  String? _sectionNameEn;
  String? _villageNameEn;
  String? _villageNameV1;
  String? _postoffNameEn;
  String? _postoffNameV1;
  String? _postoffPin;
  String? _partNameEn;
  String? _partNameV1;
  String? _psbuildingNameEn;
  num? _psbuildingNo;
  String? _psbuildingNameV1;
  String? _tahsilNameEn;
  String? _tahsilNameV1;
  String? _policestNameEn;
  String? _policestNameV1;
  bool? _isDuplicate;
  String? _whatsappNo;
  String? _newAddress;
  String? _aadhaarNo;
  bool? _isDead;
  bool? _isVisited;
  bool? _hasVoted;
  String? _email;
  String? _referenceName;
  String? _bloodGroup;
  String? _profession;
  String? _facebookUrl;
  String? _instagramUrl;
  String? _twitterUrl;
  String? _otherDetails;
  String? _chouseNo;
  String? _chouseNoV1;
Voters copyWith({  num? id,
  num? acNo,
  num? partNo,
  num? sectionNo,
  num? slnoinpart,
  String? fullNameEn,
  String? fullNameV1,
  String? fmNameEn,
  String? lastnameEn,
  String? fmNameV1,
  String? lastnameV1,
  String? rlnType,
  String? rlnFmNmEn,
  String? rlnLNmEn,
  String? rlnFmNmV1,
  String? rlnLNmV1,
  String? epicNo,
  String? gender,
  String? age,
  String? dob,
  String? mobileNo,
  num? pcNo,
  String? pcnameEn,
  String? pcnameV1,
  String? acNameEn,
  String? acNameV1,
  String? sectionNameV1,
  String? sectionNameEn,
  String? villageNameEn,
  String? villageNameV1,
  String? postoffNameEn,
  String? postoffNameV1,
  String? postoffPin,
  String? partNameEn,
  String? partNameV1,
  String? psbuildingNameEn,
  num? psbuildingNo,
  String? psbuildingNameV1,
  String? tahsilNameEn,
  String? tahsilNameV1,
  String? policestNameEn,
  String? policestNameV1,
  bool? isDuplicate,
  String? whatsappNo,
  String? newAddress,
  String? aadhaarNo,
  bool? isDead,
  bool? isVisited,
  bool? hasVoted,
  String? email,
  String? referenceName,
  String? bloodGroup,
  String? profession,
  String? facebookUrl,
  String? instagramUrl,
  String? twitterUrl,
  String? otherDetails,
  String? chouseNo,
  String? chouseNoV1,
}) => Voters(  id: id ?? _id,
  acNo: acNo ?? _acNo,
  partNo: partNo ?? _partNo,
  sectionNo: sectionNo ?? _sectionNo,
  slnoinpart: slnoinpart ?? _slnoinpart,
  fullNameEn: fullNameEn ?? _fullNameEn,
  fullNameV1: fullNameV1 ?? _fullNameV1,
  fmNameEn: fmNameEn ?? _fmNameEn,
  lastnameEn: lastnameEn ?? _lastnameEn,
  fmNameV1: fmNameV1 ?? _fmNameV1,
  lastnameV1: lastnameV1 ?? _lastnameV1,
  rlnType: rlnType ?? _rlnType,
  rlnFmNmEn: rlnFmNmEn ?? _rlnFmNmEn,
  rlnLNmEn: rlnLNmEn ?? _rlnLNmEn,
  rlnFmNmV1: rlnFmNmV1 ?? _rlnFmNmV1,
  rlnLNmV1: rlnLNmV1 ?? _rlnLNmV1,
  epicNo: epicNo ?? _epicNo,
  gender: gender ?? _gender,
  age: age ?? _age,
  dob: dob ?? _dob,
  mobileNo: mobileNo ?? _mobileNo,
  pcNo: pcNo ?? _pcNo,
  pcnameEn: pcnameEn ?? _pcnameEn,
  pcnameV1: pcnameV1 ?? _pcnameV1,
  acNameEn: acNameEn ?? _acNameEn,
  acNameV1: acNameV1 ?? _acNameV1,
  sectionNameV1: sectionNameV1 ?? _sectionNameV1,
  sectionNameEn: sectionNameEn ?? _sectionNameEn,
  villageNameEn: villageNameEn ?? _villageNameEn,
  villageNameV1: villageNameV1 ?? _villageNameV1,
  postoffNameEn: postoffNameEn ?? _postoffNameEn,
  postoffNameV1: postoffNameV1 ?? _postoffNameV1,
  postoffPin: postoffPin ?? _postoffPin,
  partNameEn: partNameEn ?? _partNameEn,
  partNameV1: partNameV1 ?? _partNameV1,
  psbuildingNameEn: psbuildingNameEn ?? _psbuildingNameEn,
  psbuildingNo: psbuildingNo ?? _psbuildingNo,
  psbuildingNameV1: psbuildingNameV1 ?? _psbuildingNameV1,
  tahsilNameEn: tahsilNameEn ?? _tahsilNameEn,
  tahsilNameV1: tahsilNameV1 ?? _tahsilNameV1,
  policestNameEn: policestNameEn ?? _policestNameEn,
  policestNameV1: policestNameV1 ?? _policestNameV1,
  isDuplicate: isDuplicate ?? _isDuplicate,
  whatsappNo: whatsappNo ?? _whatsappNo,
  newAddress: newAddress ?? _newAddress,
  aadhaarNo: aadhaarNo ?? _aadhaarNo,
  isDead: isDead ?? _isDead,
  isVisited: isVisited ?? _isVisited,
  hasVoted: hasVoted ?? _hasVoted,
  email: email ?? _email,
  referenceName: referenceName ?? _referenceName,
  bloodGroup: bloodGroup ?? _bloodGroup,
  profession: profession ?? _profession,
  facebookUrl: facebookUrl ?? _facebookUrl,
  instagramUrl: instagramUrl ?? _instagramUrl,
  twitterUrl: twitterUrl ?? _twitterUrl,
  otherDetails: otherDetails ?? _otherDetails,
  chouseNo: chouseNo ?? _chouseNo,
  chouseNoV1: chouseNoV1 ?? _chouseNoV1,
);
  num? get id => _id;
  num? get acNo => _acNo;
  num? get partNo => _partNo;
  num? get sectionNo => _sectionNo;
  num? get slnoinpart => _slnoinpart;
  String? get fullNameEn => _fullNameEn;
  String? get fullNameV1 => _fullNameV1;
  String? get fmNameEn => _fmNameEn;
  String? get lastnameEn => _lastnameEn;
  String? get fmNameV1 => _fmNameV1;
  String? get lastnameV1 => _lastnameV1;
  String? get rlnType => _rlnType;
  String? get rlnFmNmEn => _rlnFmNmEn;
  String? get rlnLNmEn => _rlnLNmEn;
  String? get rlnFmNmV1 => _rlnFmNmV1;
  String? get rlnLNmV1 => _rlnLNmV1;
  String? get epicNo => _epicNo;
  String? get gender => _gender;
  String? get age => _age;
  String? get dob => _dob;

  set dob(String? value) {
    _dob = value;
  }

  String? get mobileNo => _mobileNo;

  set mobileNo(String? value) {
    _mobileNo = value;
  }

  num? get pcNo => _pcNo;
  String? get pcnameEn => _pcnameEn;
  String? get pcnameV1 => _pcnameV1;
  String? get acNameEn => _acNameEn;
  String? get acNameV1 => _acNameV1;
  String? get sectionNameV1 => _sectionNameV1;
  String? get sectionNameEn => _sectionNameEn;
  String? get villageNameEn => _villageNameEn;
  String? get villageNameV1 => _villageNameV1;
  String? get postoffNameEn => _postoffNameEn;
  String? get postoffNameV1 => _postoffNameV1;
  String? get postoffPin => _postoffPin;
  String? get partNameEn => _partNameEn;
  String? get partNameV1 => _partNameV1;
  String? get psbuildingNameEn => _psbuildingNameEn;
  num? get psbuildingNo => _psbuildingNo;
  String? get psbuildingNameV1 => _psbuildingNameV1;
  String? get tahsilNameEn => _tahsilNameEn;
  String? get tahsilNameV1 => _tahsilNameV1;
  String? get policestNameEn => _policestNameEn;
  String? get policestNameV1 => _policestNameV1;
  bool? get isDuplicate => _isDuplicate;
  String? get whatsappNo => _whatsappNo;

  set whatsappNo(String? value) {
    _whatsappNo = value;
  }

  String? get newAddress => _newAddress;

  set newAddress(String? value) {
    _newAddress = value;
  }

  set aadhaarNo(String? value) {
    _aadhaarNo = value;
  }

  String? get aadhaarNo => _aadhaarNo;
  bool? get isDead => _isDead;
  bool? get isVisited => _isVisited;
  bool? get hasVoted => _hasVoted;
  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get referenceName => _referenceName;

  set referenceName(String? value) {
    _referenceName = value;
  }

  String? get bloodGroup => _bloodGroup;

  set bloodGroup(String? value) {
    _bloodGroup = value;
  }

  String? get profession => _profession;

  set profession(String? value) {
    _profession = value;
  }

  String? get facebookUrl => _facebookUrl;

  set facebookUrl(String? value) {
    _facebookUrl = value;
  }

  String? get instagramUrl => _instagramUrl;
  String? get twitterUrl => _twitterUrl;

  set twitterUrl(String? value) {
    _twitterUrl = value;
  }

  String? get otherDetails => _otherDetails;

  set otherDetails(String? value) {
    _otherDetails = value;
  }

  String? get chouseNo => _chouseNo;
  String? get chouseNoV1 => _chouseNoV1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id ?? 0;
    map['acNo'] = _acNo ?? 0;
    map['partNo'] = _partNo ?? 0;
    map['sectionNo'] = _sectionNo ?? 0;
    map['slnoinpart'] = _slnoinpart ?? 0;
    map['fullNameEn'] = checkValidString(_fullNameEn);
    map['fullNameV1'] = checkValidString(_fullNameV1);
    map['fmNameEn'] = checkValidString(_fmNameEn);
    map['lastnameEn'] = checkValidString(_lastnameEn);
    map['fmNameV1'] = checkValidString(_fmNameV1);
    map['lastnameV1'] = checkValidString(_lastnameV1);
    map['rlnType'] = checkValidString(_rlnType);
    map['rlnFmNmEn'] = checkValidString(_rlnFmNmEn);
    map['rlnLNmEn'] = checkValidString(_rlnLNmEn);
    map['rlnFmNmV1'] = checkValidString(_rlnFmNmV1);
    map['rlnLNmV1'] = checkValidString(_rlnLNmV1);
    map['epicNo'] = checkValidString(_epicNo);
    map['gender'] = checkValidString(_gender);
    map['age'] = checkValidString(_age);
    map['dob'] = checkValidString(_dob);
    map['mobileNo'] = checkValidString(_mobileNo);
    map['pcNo'] = _pcNo ?? 0;
    map['pcnameEn'] = checkValidString(_pcnameEn);
    map['pcnameV1'] = checkValidString(_pcnameV1);
    map['acNameEn'] = checkValidString(_acNameEn);
    map['acNameV1'] = checkValidString(_acNameV1);
    map['sectionNameV1'] = checkValidString(_sectionNameV1);
    map['sectionNameEn'] = checkValidString(_sectionNameEn);
    map['villageNameEn'] = checkValidString(_villageNameEn);
    map['villageNameV1'] = checkValidString(_villageNameV1);
    map['postoffNameEn'] = checkValidString(_postoffNameEn);
    map['postoffNameV1'] = checkValidString(_postoffNameV1);
    map['postoffPin'] = checkValidString(_postoffNameV1);
    map['partNameEn'] = checkValidString(_partNameEn);
    map['partNameV1'] = checkValidString(_partNameV1);
    map['psbuildingNameEn'] = checkValidString(_psbuildingNameEn);
    map['psbuildingNo'] = _psbuildingNo ?? 0;
    map['psbuildingNameV1'] = checkValidString(_psbuildingNameV1);
    map['tahsilNameEn'] = checkValidString(_tahsilNameEn);
    map['tahsilNameV1'] = checkValidString(_tahsilNameV1);
    map['policestNameEn'] = checkValidString(_policestNameEn);
    map['policestNameV1'] = checkValidString(_policestNameV1);
    map['isDuplicate'] = _isDuplicate ?? false;
    map['whatsappNo'] = checkValidString(_whatsappNo);
    map['newAddress'] = checkValidString(_newAddress);
    map['aadhaarNo'] = checkValidString(_aadhaarNo);
    map['isDead'] = _isDead ?? false;
    map['isVisited'] = _isVisited ?? false;
    map['hasVoted'] = _hasVoted ?? false;
    map['email'] = checkValidString(_email);
    map['referenceName'] = checkValidString(_referenceName);
    map['bloodGroup'] = checkValidString(_bloodGroup);
    map['profession'] = checkValidString(_profession);
    map['facebookUrl'] = checkValidString(_facebookUrl);
    map['instagramUrl'] = checkValidString(_instagramUrl);
    map['twitterUrl'] = checkValidString(_twitterUrl);
    map['otherDetails'] = checkValidString(_otherDetails);
    map['chouseNo'] = checkValidString(_chouseNo);
    map['chouseNoV1'] = checkValidString(_chouseNoV1);
    return map;
  }

  set instagramUrl(String? value) {
    _instagramUrl = value;
  }
}