import 'package:flutter/material.dart';
import '../model/ColorCodeResponseModel.dart';
import '../model/ProfessionListResponse.dart';
import '../model/StatisticsDataResponse.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> navigatorKeyHome = GlobalKey<NavigatorState>();
  static String notif_type = "";
  static List<Statistics> statisticsData = List<Statistics>.empty(growable: true);
  static List<Professions> professions = List<Professions>.empty(growable: true);
  static List<Colorcode> colorCodeList = List<Colorcode>.empty(growable: true);
  static List<String> bloodGroupList = ["A +ve" , "A -ve", "B +ve", "B -ve","AB +ve","AB -ve", "O +ve", "O -ve"];
  static List<String> genderList = ["Male" , "Female",];
}