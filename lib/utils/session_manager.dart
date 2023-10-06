import 'package:congress_app/utils/session_manager_new.dart';

class SessionManager {

  final String isLoggedIn = "isLoggedIn";
  final String id = "id";
  final String workerName = "workerName";
  final String workerPhone = "workerPhone";
  final String assemblyNumber = "assemblyNumber";
  final String boothAssigned = "boothAssigned";
  final String isActive = "isActive";
  final String deviceToken = "deviceToken";
  final String accessToken = "access_token";

  Future createLoginSession(String idParam, String workerNameParam, String workerPhoneParam,
      String assemblyNumberParam, String boothAssignedParam, bool isActiveParam) async {
    await SessionManagerNew.setBool(isLoggedIn, true);
    await SessionManagerNew.setString(id, idParam);
    await SessionManagerNew.setString(workerName, workerNameParam);
    await SessionManagerNew.setString(workerPhone, workerPhoneParam);
    await SessionManagerNew.setString(assemblyNumber, assemblyNumberParam);
    await SessionManagerNew.setString(boothAssigned, boothAssignedParam);
    await SessionManagerNew.setBool(isActive, isActiveParam);
  }

  Future<void> setIsLoggedIn(bool isLoginIn)
  async {
    await SessionManagerNew.setBool(isLoggedIn, isLoginIn);
  }

  bool? checkIsLoggedIn() {
    return SessionManagerNew.getBool(isLoggedIn);
  }

  Future<void> setDeviceToken(String apiDeviceToken)
  async {
    await SessionManagerNew.setString(deviceToken, apiDeviceToken);
  }

  String? getDeviceToken() {
    return SessionManagerNew.getString(deviceToken);
  }

  String? getAcNo() {
    return SessionManagerNew.getString(assemblyNumber);
  }

  String? getPart() {
    return SessionManagerNew.getString(boothAssigned);
  }

  String? getAccessToken() {
    return SessionManagerNew.getString(accessToken);
  }

}