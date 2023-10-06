import 'dart:convert';
/// count : 929
/// message : "Success"
/// voters : [{"id":1,"acNo":"72","partNo":"1","sectionNo":"3","slnoinpart":"765","fullNameEn":"C Konda Jamuna -H- Srinivas","fullNameV1":"సీ కొండ జమున -H- శ్రీనివాస్","fmNameEn":"C Konda Jamuna","lastnameEn":"","fmNameV1":"సీ కొండ జమున","lastnameV1":"","rlnType":"H","rlnFmNmEn":"Srinivas","rlnLNmEn":"","rlnFmNmV1":"శ్రీనివాస్","rlnLNmV1":"","epicNo":"ZUE1141688","gender":"F","age":"44","dob":"1979-01-01","mobileNo":"+918790412964","pcNo":"11","pcnameEn":"Mahabubnagar","pcnameV1":"మహబూబ్ నగర్","acNameEn":"Kodangal","acNameV1":"కొడంగల్","sectionNameV1":"య సి కాలనీ","sectionNameEn":"S C Colony","villageNameEn":"0","villageNameV1":"0","postoffNameEn":"Nagasar","postoffNameV1":"నాగాసార్","postoffPin":"509336","partNameEn":"Nagsar","partNameV1":"నాగాసార్","psbuildingNameEn":"Mandal Parishat Primary School","psbuildingNo":"170","psbuildingNameV1":"మండల పరిషత్ ప్రాధమిక పాఠశాల","tahsilNameEn":"Doulatabad","tahsilNameV1":"దౌల్తాబాద్","policestNameEn":"Doulatabad","policestNameV1":"దౌల్తాబాద్","isDuplicate":false,"chouseNo":"1-182A","chouseNoV1":"1-182ఏ"}]

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
/// acNo : "72"
/// partNo : "1"
/// sectionNo : "3"
/// slnoinpart : "765"
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
/// pcNo : "11"
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
/// psbuildingNo : "170"
/// psbuildingNameV1 : "మండల పరిషత్ ప్రాధమిక పాఠశాల"
/// tahsilNameEn : "Doulatabad"
/// tahsilNameV1 : "దౌల్తాబాద్"
/// policestNameEn : "Doulatabad"
/// policestNameV1 : "దౌల్తాబాద్"
/// isDuplicate : false
/// chouseNo : "1-182A"
/// chouseNoV1 : "1-182ఏ"

Voters votersFromJson(String str) => Voters.fromJson(json.decode(str));
String votersToJson(Voters data) => json.encode(data.toJson());
class Voters {
  Voters({
      num? id, 
      String? acNo, 
      String? partNo, 
      String? sectionNo, 
      String? slnoinpart, 
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
      String? pcNo, 
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
      String? psbuildingNo, 
      String? psbuildingNameV1, 
      String? tahsilNameEn, 
      String? tahsilNameV1, 
      String? policestNameEn, 
      String? policestNameV1, 
      bool? isDuplicate, 
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
    _isDuplicate = json['isDuplicate'];
    _chouseNo = json['chouseNo'];
    _chouseNoV1 = json['chouseNoV1'];
  }
  num? _id;
  String? _acNo;
  String? _partNo;
  String? _sectionNo;
  String? _slnoinpart;
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
  String? _pcNo;
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
  String? _psbuildingNo;
  String? _psbuildingNameV1;
  String? _tahsilNameEn;
  String? _tahsilNameV1;
  String? _policestNameEn;
  String? _policestNameV1;
  bool? _isDuplicate;
  String? _chouseNo;
  String? _chouseNoV1;
Voters copyWith({  num? id,
  String? acNo,
  String? partNo,
  String? sectionNo,
  String? slnoinpart,
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
  String? pcNo,
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
  String? psbuildingNo,
  String? psbuildingNameV1,
  String? tahsilNameEn,
  String? tahsilNameV1,
  String? policestNameEn,
  String? policestNameV1,
  bool? isDuplicate,
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
  chouseNo: chouseNo ?? _chouseNo,
  chouseNoV1: chouseNoV1 ?? _chouseNoV1,
);
  num? get id => _id;
  String? get acNo => _acNo;
  String? get partNo => _partNo;
  String? get sectionNo => _sectionNo;
  String? get slnoinpart => _slnoinpart;
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
  String? get mobileNo => _mobileNo;
  String? get pcNo => _pcNo;
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
  String? get psbuildingNo => _psbuildingNo;
  String? get psbuildingNameV1 => _psbuildingNameV1;
  String? get tahsilNameEn => _tahsilNameEn;
  String? get tahsilNameV1 => _tahsilNameV1;
  String? get policestNameEn => _policestNameEn;
  String? get policestNameV1 => _policestNameV1;
  bool? get isDuplicate => _isDuplicate;
  String? get chouseNo => _chouseNo;
  String? get chouseNoV1 => _chouseNoV1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['acNo'] = _acNo;
    map['partNo'] = _partNo;
    map['sectionNo'] = _sectionNo;
    map['slnoinpart'] = _slnoinpart;
    map['fullNameEn'] = _fullNameEn;
    map['fullNameV1'] = _fullNameV1;
    map['fmNameEn'] = _fmNameEn;
    map['lastnameEn'] = _lastnameEn;
    map['fmNameV1'] = _fmNameV1;
    map['lastnameV1'] = _lastnameV1;
    map['rlnType'] = _rlnType;
    map['rlnFmNmEn'] = _rlnFmNmEn;
    map['rlnLNmEn'] = _rlnLNmEn;
    map['rlnFmNmV1'] = _rlnFmNmV1;
    map['rlnLNmV1'] = _rlnLNmV1;
    map['epicNo'] = _epicNo;
    map['gender'] = _gender;
    map['age'] = _age;
    map['dob'] = _dob;
    map['mobileNo'] = _mobileNo;
    map['pcNo'] = _pcNo;
    map['pcnameEn'] = _pcnameEn;
    map['pcnameV1'] = _pcnameV1;
    map['acNameEn'] = _acNameEn;
    map['acNameV1'] = _acNameV1;
    map['sectionNameV1'] = _sectionNameV1;
    map['sectionNameEn'] = _sectionNameEn;
    map['villageNameEn'] = _villageNameEn;
    map['villageNameV1'] = _villageNameV1;
    map['postoffNameEn'] = _postoffNameEn;
    map['postoffNameV1'] = _postoffNameV1;
    map['postoffPin'] = _postoffPin;
    map['partNameEn'] = _partNameEn;
    map['partNameV1'] = _partNameV1;
    map['psbuildingNameEn'] = _psbuildingNameEn;
    map['psbuildingNo'] = _psbuildingNo;
    map['psbuildingNameV1'] = _psbuildingNameV1;
    map['tahsilNameEn'] = _tahsilNameEn;
    map['tahsilNameV1'] = _tahsilNameV1;
    map['policestNameEn'] = _policestNameEn;
    map['policestNameV1'] = _policestNameV1;
    map['isDuplicate'] = _isDuplicate;
    map['chouseNo'] = _chouseNo;
    map['chouseNoV1'] = _chouseNoV1;
    return map;
  }



}