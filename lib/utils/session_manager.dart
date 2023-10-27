import 'dart:convert';

import 'package:congress_app/model/StatisticsDataResponse.dart';
import 'package:congress_app/utils/session_manager_new.dart';

import '../model/ColorCodeResponseModel.dart';
import '../model/ProfessionListResponse.dart';
import 'app_utils.dart';

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
  final String isDataSync = "isDataSync";
  final String staticData = "staticData";
  final String colorData = "colorData";
  final String professionData = "professionData";
  final String language = "language";

  Future createLoginSession(String idParam, String workerNameParam, String workerPhoneParam,
      String assemblyNumberParam, String boothAssignedParam, bool isActiveParam) async {
    await SessionManagerNew.setBool(isLoggedIn, true);
    await SessionManagerNew.setString(id, idParam);
    await SessionManagerNew.setString(workerName, workerNameParam);
    await SessionManagerNew.setString(workerPhone, workerPhoneParam);
    await SessionManagerNew.setString(assemblyNumber, assemblyNumberParam);
    await SessionManagerNew.setString(boothAssigned, boothAssignedParam);
    await SessionManagerNew.setBool(isActive, isActiveParam);
    await SessionManagerNew.setBool(language, true);
  }

  Future<void> setIsLoggedIn(bool isLoginIn)
  async {
    await SessionManagerNew.setBool(isLoggedIn, isLoginIn);
  }

  bool? checkIsLoggedIn() {
    return SessionManagerNew.getBool(isLoggedIn);
  }

  Future<void> setIsDataSync(bool data)
  async {
    await SessionManagerNew.setBool(isDataSync, data);
  }

  bool? checkIsDataSync() {
    return SessionManagerNew.getBool(isDataSync);
  }

  Future<void> setDeviceToken(String apiDeviceToken)
  async {
    await SessionManagerNew.setString(deviceToken, apiDeviceToken);
  }

  String? getDeviceToken() {
    return SessionManagerNew.getString(deviceToken);
  }

  Future<void> setLanguage(bool data)
  async {
    await SessionManagerNew.setBool(language, data);
  }

  bool? isLanguageEnglish() {
    return SessionManagerNew.getBool(language);
  }

  String? getWorkerName() {
    return SessionManagerNew.getString(workerName);
  }

  String? getWorkerPhone() {
    return SessionManagerNew.getString(workerPhone);
  }

  String? getAcNo() {
    return SessionManagerNew.getString(assemblyNumber);
  }

  String? getPart() {
    return SessionManagerNew.getString(boothAssigned);
  }

  String? getId() {
    return SessionManagerNew.getString(id);
  }

  Future<void> setPart(String part)
  async {
    await SessionManagerNew.setString(boothAssigned, part);
  }

  String? getAccessToken() {
    return SessionManagerNew.getString(accessToken);
  }

  Future<void> setStaticData(List<Statistics> listItems) async {
    var json = jsonEncode(listItems);
    await SessionManagerNew.setString(staticData, json);
  }

  List<Statistics> getStaticData() {
    List<Statistics> listJsonData = [];
    String jsonString = checkValidString(SessionManagerNew.getString(staticData));
    if (jsonString.isNotEmpty)
    {
      List<dynamic> jsonDataList = jsonDecode(jsonString);
      listJsonData = jsonDataList.map((jsonData) => Statistics.fromJson(jsonData)).toList();
    }
    return listJsonData;
  }

  Future<void> setColorData(List<Colorcode> listItems) async {
    var json = jsonEncode(listItems);
    await SessionManagerNew.setString(colorData, json);
  }

  List<Colorcode> getColorData() {
    List<Colorcode> listJsonData = [];
    String jsonString = checkValidString(SessionManagerNew.getString(colorData));
    if (jsonString.isNotEmpty)
    {
      List<dynamic> jsonDataList = jsonDecode(jsonString);
      listJsonData = jsonDataList.map((jsonData) => Colorcode.fromJson(jsonData)).toList();
    }
    return listJsonData;
  }

  Future<void> setProfessionData(List<Professions> listItems) async {
    var json = jsonEncode(listItems);
    await SessionManagerNew.setString(professionData, json);
  }

  List<Professions> getProfessionData() {
    List<Professions> listJsonData = [];
    String jsonString = checkValidString(SessionManagerNew.getString(professionData));
    if (jsonString.isNotEmpty)
    {
      List<dynamic> jsonDataList = jsonDecode(jsonString);
      listJsonData = jsonDataList.map((jsonData) => Professions.fromJson(jsonData)).toList();
    }
    return listJsonData;
  }
}