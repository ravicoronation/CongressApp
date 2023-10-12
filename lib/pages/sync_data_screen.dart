import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:congress_app/pages/DashBoardScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/BoothResponseData.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
      }));
    });

    if(isOnline)
    {
      getAllVotersApiData();
    }
    else
    {
        noInterNet(context);
    }

    super.initState();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
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
                child: Image.asset('assets/images/ic_logo.png', width: 120, height: 120),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/loader.json',width: 80,height: 80),
                  const Text("Please wait we are fetching voters data..",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        )
    );
  }

//API Call func...
  void getAllVotersApiData() async
  {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/voters/part/" + sessionManager.getPart().toString().trim();
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200)
    {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = VoterListResponse.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success")
      {
        try
        {
          if (dataResponse.voters != null)
          {
            if (dataResponse.voters!.isNotEmpty)
            {
              var listData = List<Voters>.empty(growable: true);
              listData.addAll(dataResponse.voters!);
              await addDataInDB(listData);
             // getAllBoothApiData();
              redirectToHome();
            }
          }
        } catch (e)
        {
          print(e);
        }
      }
      else
      {
        apiFailed(context);
      }
    }
    else
    {
      apiFailed(context);
    }
  }

  void getAllBoothApiData() async
  {
    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/parts";
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({'token': Token});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200)
    {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = BoothResponseData.fromJson(user);
      if (checkValidString(dataResponse.message) == "Success")
      {
        try
        {
          if (dataResponse.parts != null)
          {
            if (dataResponse.parts!.isNotEmpty)
            {
              var listData = List<Parts>.empty(growable: true);
              listData.addAll(dataResponse.parts!);
              await addBoothDataInDB(listData);
              redirectToHome();
            }
          }
        } catch (e)
        {
          print(e);
        }
      }
      else
      {
        apiFailed(context);
      }
    }
    else
    {
      apiFailed(context);
    }
  }

  addDataInDB(List<Voters> listData)
  {
    for (final voterItem in listData)
    {
      dbHelper.insertVoters(voterItem);
    }
  }

  addBoothDataInDB(List<Parts> listData)
  {
    for (final voterItem in listData)
    {
      dbHelper.insertBooth(voterItem);
    }
  }

  void redirectToHome() {
    sessionManager.setIsDataSync(true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashBoardScreen()), (Route<dynamic> route) => false);
  }
}
