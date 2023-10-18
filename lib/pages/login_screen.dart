import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:congress_app/pages/sync_data_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/LoginResponse.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import 'VerifyOTPScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController _mobileController = TextEditingController();
  FocusNode inputNode = FocusNode();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool isOnline = true;
  final dbHelper = DbHelper.instance;

  @override
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      openKeyboard();
    });

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
      }));
    });
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

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/ic_logo.jpg', width: 200, height: 250),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            cursorColor: black,
                            controller: _mobileController,
                            autofocus:true,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: editTextStyle(),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset('assets/images/ic_call_new.png', width: 22, height: 22, color: darOrange,),
                                ),
                                hintText: 'Mobile Number',
                                counterText: '',
                                contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 35, left: 8, right: 8),
                          width: double.infinity,
                          child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kButton1CornerRadius),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(darOrange)),
                              onPressed: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                String mobileNumber = _mobileController.text.toString().trim();
                                if (mobileNumber.isEmpty) {
                                  showSnackBar("Please enter a mobile number", context);
                                }else  if (mobileNumber.toString().trim().length !=10) {
                                  showSnackBar("Please enter a valid mobile number", context);
                                }
                                else {
                                  if (isOnline) {
                                    logInRequest(mobileNumber.toString().trim());
                                  } else {
                                    noInterNet(context);
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6),
                                child: ! _isLoading
                                    ? const Text("Log In",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                                ) : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle,
                                                border: Border.all(color: black, width: 1,)),
                                            child: const Padding(padding: EdgeInsets.all(4.0),
                                              child: CircularProgressIndicator(color: white, strokeWidth: 2),
                                            ))),
                                    const Text("   Please wait..",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }

  //API Call func...
  void logInRequest(String mobileNumber) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse("${API_URL}auth/worker/$mobileNumber");
    Map<String, String> jsonBody = {
      'token': Token
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = LoginResponse.fromJson(user);

    if (statusCode == 200 && checkValidString(dataResponse.message) == "Success") {
      try {
        if(dataResponse.workers !=null)
        {
            if(dataResponse.workers!.isNotEmpty)
            {
               if(dataResponse.workers![0].isActive == true)
               {
                 redirectToHome(dataResponse.workers![0]);
               }
               else
               {
                 showSnackBar("You are not allow to access the application.", context);
               }
            }
        }
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  void redirectToHome(Workers workers) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VerifyOTPScreen(workers)), (Route<dynamic> route) => false);
  }
}
