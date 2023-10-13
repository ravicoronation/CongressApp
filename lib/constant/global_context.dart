import 'package:flutter/material.dart';

import '../model/StatisticsDataResponse.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> navigatorKeyHome = GlobalKey<NavigatorState>();
  static String notif_type = "";
  static List<Statistics> statisticsData = List<Statistics>.empty(growable: true);
}