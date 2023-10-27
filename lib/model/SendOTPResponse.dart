import 'dart:convert';
/// msg : "success"
/// code : 200
/// msg_text : "SMS campaign has been submitted successfully"
/// data : [{"campaign_id":129688,"number":"9898009898","message_id":"129688_2_9898009898_1"}]

SendOtpResponse sendOtpResponseFromJson(String str) => SendOtpResponse.fromJson(json.decode(str));
String sendOtpResponseToJson(SendOtpResponse data) => json.encode(data.toJson());
class SendOtpResponse {
  SendOtpResponse({
      String? msg, 
      num? code, 
      String? msgText, 
      List<Data>? data,}){
    _msg = msg;
    _code = code;
    _msgText = msgText;
    _data = data;
}

  SendOtpResponse.fromJson(dynamic json) {
    _msg = json['msg'];
    _code = json['code'];
    _msgText = json['msg_text'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _msg;
  num? _code;
  String? _msgText;
  List<Data>? _data;
SendOtpResponse copyWith({  String? msg,
  num? code,
  String? msgText,
  List<Data>? data,
}) => SendOtpResponse(  msg: msg ?? _msg,
  code: code ?? _code,
  msgText: msgText ?? _msgText,
  data: data ?? _data,
);
  String? get msg => _msg;
  num? get code => _code;
  String? get msgText => _msgText;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = _msg;
    map['code'] = _code;
    map['msg_text'] = _msgText;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// campaign_id : 129688
/// number : "9898009898"
/// message_id : "129688_2_9898009898_1"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? campaignId, 
      String? number, 
      String? messageId,}){
    _campaignId = campaignId;
    _number = number;
    _messageId = messageId;
}

  Data.fromJson(dynamic json) {
    _campaignId = json['campaign_id'];
    _number = json['number'];
    _messageId = json['message_id'];
  }
  num? _campaignId;
  String? _number;
  String? _messageId;
Data copyWith({  num? campaignId,
  String? number,
  String? messageId,
}) => Data(  campaignId: campaignId ?? _campaignId,
  number: number ?? _number,
  messageId: messageId ?? _messageId,
);
  num? get campaignId => _campaignId;
  String? get number => _number;
  String? get messageId => _messageId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['campaign_id'] = _campaignId;
    map['number'] = _number;
    map['message_id'] = _messageId;
    return map;
  }

}