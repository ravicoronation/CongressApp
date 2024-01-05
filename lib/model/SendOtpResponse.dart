import 'dart:convert';
/// campid : "7f0eed709e2d38bf8223"

SendOtpResponse sendOtpResponseFromJson(String str) => SendOtpResponse.fromJson(json.decode(str));
String sendOtpResponseToJson(SendOtpResponse data) => json.encode(data.toJson());
class SendOtpResponse {
  SendOtpResponse({
      String? campid,}){
    _campid = campid;
}

  SendOtpResponse.fromJson(dynamic json) {
    _campid = json['campid'];
  }
  String? _campid;
SendOtpResponse copyWith({  String? campid,
}) => SendOtpResponse(  campid: campid ?? _campid,
);
  String? get campid => _campid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['campid'] = _campid;
    return map;
  }

}