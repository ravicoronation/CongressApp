import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../local_storage/db_helper.dart';
import '../model/BoothResponseData.dart';
import '../model/ColorCodeResponseModel.dart';
import '../model/ProfessionListResponse.dart';
import '../model/StatisticsDataResponse.dart';
import '../model/TotalCountResponse.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import 'package:http/http.dart' as http;
import 'HomePage.dart';

class SyncDataScreen extends StatefulWidget {
  const SyncDataScreen({Key? key}) : super(key: key);

  @override
  _SyncDataScreenState createState() => _SyncDataScreenState();
}

class _SyncDataScreenState extends State<SyncDataScreen> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool isOnline = true;
  final dbHelper = DbHelper.instance;
  SessionManager sessionManager = SessionManager();
  int totalCount = 0;
  int startCount = 1;

  @override
  void initState() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
            isOnline = isConnected;
          }));
    });

    if (isOnline) {
      getStatisticsDataFromAcNo();
      if (sessionManager.getPart().toString().trim() == "0") {
        getCountFromAcNo();
      } else {
        getAllVotersApiData();
      }
    } else {
      noInterNet(context);
    }

    super.initState();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBg,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
        backgroundColor: appBg,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/ic_logo.jpg', width: 120, height: 120),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/loader.json', width: 80, height: 80),
                  const Text(
                    "Please wait we are fetching voters data..",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ));
  }

//API Call func...
  void getAllVotersApiData() async {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/voters/part/" + sessionManager.getPart().toString().trim();
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = VoterListResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.voters != null) {
            if (dataResponse.voters!.isNotEmpty) {
              dbHelper.insertVoters(dataResponse.voters!);
              redirectToHome();
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }
  }

  void getAllBoothApiData() async {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/parts";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = BoothResponseData.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.parts != null) {
            if (dataResponse.parts!.isNotEmpty) {
              var listData = List<Parts>.empty(growable: true);
              listData.addAll(dataResponse.parts!);
              await addBoothDataInDB(listData);
              redirectToHome();
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }
  }

  void getCountFromAcNo() async {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/parts/count";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = TotalCountResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.count != null) {
            totalCount = dataResponse.count!;
            startCount = 1;
            getAllVotersApiDataWithCount(startCount.toString());
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }
  }

  void getAllVotersApiDataWithCount(String count) async {
    print("<><> COUNT START : " + count + " <><>");
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/voters/part/" + count.toString().trim();
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = VoterListResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.voters != null) {
            if (dataResponse.voters!.isNotEmpty) {
              dbHelper.insertVoters(dataResponse.voters!);
              if (startCount == totalCount) {
                redirectToHome();
              } else {
                print("<><> COUNT START : " + count + " <><>");
                startCount++;
                getAllVotersApiDataWithCount(startCount.toString());
              }
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        if (startCount == totalCount) {
          redirectToHome();
        } else {
          startCount++;
          getAllVotersApiDataWithCount(startCount.toString());
        }
      }
    } else {
      if (startCount == totalCount) {
        redirectToHome();
      } else {
        startCount++;
        getAllVotersApiDataWithCount(startCount.toString());
      }
    }
  }

  void getStatisticsDataFromAcNo() async {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/statistics";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = StatisticsDataResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.statistics != null) {
            NavigationService.statisticsData = dataResponse.statistics!;
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }

    getProfessionList();
  }

  void getProfessionList() async {
    var urlCreate = API_URL + "/profession";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = ProfessionListResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.professions != null) {
            NavigationService.professions = dataResponse.professions!;
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }

    getColorCodeList();
  }

  void getColorCodeList() async {
    var urlCreate = API_URL + "/colorcode";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = ColorCodeResponseModel.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success") {
        try {
          if (dataResponse.colorcode != null) {
            NavigationService.colorCodeList = dataResponse.colorcode!;
          }
        } catch (e) {
          print(e);
        }
      } else {
        apiFailed(context);
      }
    } else {
      apiFailed(context);
    }
  }

  addBoothDataInDB(List<Parts> listData) {
    for (final voterItem in listData) {
      dbHelper.insertBooth(voterItem);
    }
  }

  void redirectToHome() {
    sessionManager.setIsDataSync(true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (Route<dynamic> route) => false);
  }
}
