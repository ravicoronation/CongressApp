import 'dart:async';
import 'dart:convert';
import 'package:congress_app/pages/sync_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/LoginResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';

class VerifyOTPScreen extends StatefulWidget {
  final Workers loginData;

  const VerifyOTPScreen(this.loginData, {super.key});

  @override
  BaseState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends BaseState<VerifyOTPScreen> {
  bool _isLoading = false;
  bool _isLoadingResend = false;
  late Timer _timer;
  int _start = 60;
  bool visibilityResend = false;
  String strPin = "";
  FocusNode inputNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  late Workers loginData;

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            visibilityResend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    loginData = (widget as VerifyOTPScreen).loginData;
    startTimer();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        openKeyboard();
      },
    );
    super.initState();
  }

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: appBg,
          appBar: AppBar(
            backgroundColor: appBg,
            elevation: 0,
            titleSpacing: 0,
            centerTitle: false,
            leading: InkWell(
              borderRadius: BorderRadius.circular(52),
              onTap: () {
                Navigator.pop(context, true);
              },
              child: getBackArrow(context),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: screenPadding(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Enter 4 Digit OTP',
                              style: TextStyle(fontSize: 22, color: black, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10, left: 14, top: 14),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                                  const TextSpan(
                                    text: 'We just sent a OTP to your mobile\nnumber',
                                    style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: " ${loginData.workerPhone}",
                                    style: const TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 4, bottom: 4, left: 34, right: 34),
                            child: PinCodeTextField(
                              focusNode: inputNode,
                              autoDisposeControllers: false,
                              controller: otpController,
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: black),
                              length: 4,
                              autoFocus: true,
                              obscureText: false,
                              blinkWhenObscuring: true,
                              autoDismissKeyboard: true,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.circle,
                                borderWidth: 1,
                                fieldHeight: 50,
                                fieldWidth: 50,
                                activeColor: black,
                                selectedColor: Colors.black,
                                disabledColor: grayDark,
                                inactiveColor: grayDark,
                                activeFillColor: Colors.transparent,
                                selectedFillColor: Colors.transparent,
                                inactiveFillColor: Colors.transparent,
                              ),
                              cursorColor: black,
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              onCompleted: (v) {
                                setState(() {
                                  strPin = v;
                                });
                                if (isOnline) {
                                  verifyOTPCall();
                                } else {
                                  noInterNet(context);
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  strPin = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ),
                          !visibilityResend
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(color: blue, strokeWidth: 3),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 10, left: 6, top: 14, right: 44),
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyText1,
                                          children: [
                                            const WidgetSpan(child: Gap(10)),
                                            const TextSpan(
                                              text: '  Waiting For OTP... ',
                                              style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w400),
                                            ),
                                            const TextSpan(
                                              text: "00 :",
                                              style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text: _start < 10 ? " 0$_start Seconds" : " $_start Seconds",
                                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
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
                                        setState(() {
                                          visibilityResend = false;
                                          _isLoadingResend = false;
                                          _start = 60;
                                        });
                                        startTimer();
                                        if (isOnline) {
                                          _makeLogInRequest();
                                        } else {
                                          noInterNet(context);
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 6, bottom: 6),
                                        child: Text(
                                          "Resend OTP",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                                        ),
                                      )),
                                ),
                          const Spacer(flex: 2),
                          Container(
                            margin: const EdgeInsets.only(top: 35, left: 8, right: 8,bottom: 20),
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
                                  String contact = otpController.text.toString().trim();
                                  if (contact.isEmpty) {
                                    showSnackBar("Please enter a OTP", context);
                                  } else if (contact.length != 4) {
                                    showSnackBar("Please enter valid OTP", context);
                                  } else {
                                    if (isOnline) {
                                      verifyOTPCall();
                                    } else {
                                      noInterNet(context);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                                  child: !_isLoading
                                      ? const Text(
                                          "Verify OTP",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                                        )
                                      : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: black,
                                                          width: 1,
                                                        )),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: CircularProgressIndicator(color: white, strokeWidth: 2),
                                                    ))),
                                            const Text(
                                              "   Please wait..",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        onWillPop: () {
          Navigator.pop(context, true);
          return Future.value(true);
        });
  }

  _makeLogInRequest() async {
    /* setState(() {
      _isLoadingResend = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL_SERVICES + loginWithOTP);
    Map<String, String> jsonBody = {
      'contact_no': "${(widget as VerifyOTPScreen).getSet.contactNo}",
      'from_application' : IS_FROM_APP,
      'login_type' : getIsCp() == false ? "sales" : "CP",
      'via_call' : "0",
      "new_user_flow" : "1",
    };

    final response = await http.post(url, body: jsonBody,headers: {'Authorization' : Access_Token_Static});
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = LoginOtpResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1)
    {
      if (dataResponse.data?.loginType == "CP")
      {
        sessionManager.setIsCP(true);
        sessionManager.setMasterUserId(dataResponse.data?.userId.toString() ?? '');
        sessionManager.setContactNo(dataResponse.data?.contactNo.toString() ??'');
        sessionManager.setIsCPNew(dataResponse.data?.cpNew == 1 ? true : false);
      }
      else
      {
        sessionManager.setIsCP(false);
        sessionManager.setMasterUserId(dataResponse.data?.masterUserId.toString() ?? "" );
        sessionManager.setContactNo(dataResponse.data?.contactNo.toString() ?? '');
      }
      sessionManager.setCartSession(dataResponse.data?.cartSession.toString() ?? '');
      sessionManager.setAuthToken(Access_Token_Static);
    }
    else
    {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoadingResend = false;
      });
    }*/
  }

  verifyOTPCall() async {
    if (strPin == "1234") {
      sessionManager.setIsLoggedIn(true);
      await sessionManager.createLoginSession(
          loginData.id.toString(),
          checkValidString(loginData.workerName.toString()),
          checkValidString(loginData.workerPhone.toString()),
          checkValidString(loginData.assemblyNumber.toString()),
          checkValidString(loginData.boothAssigned.toString()),
          loginData.isActive ?? false);
      callIntent();
    } else {
      showToast("In Valid OTP", context);
    }

    /* setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL_SERVICES + verifyOTP);

    Map<String, String> jsonBody = {};
    //6753445789
    if (getIsCp())
    {
        jsonBody = {
          'user_id': sessionManager.getMasterUserId(),
          'contact_no' : sessionManager.getContactNo(),
          'otp' : strPin,
          'from_application' : IS_FROM_APP,
          'from_cp_application' : IS_FROM_CP_APP
        };
    }
    else
      {
        jsonBody = {
          'master_user_id': sessionManager.getMasterUserId(),
          'contact_no' : sessionManager.getContactNo(),
          'otp' : strPin,
          'from_application' : IS_FROM_APP,
        };
      }

    final response = await http.post(url, body: jsonBody, headers: {
      'Authorization' : sessionManager.getAuthToken()
    });

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      try
      {
        sessionManager.setIsLoggedIn(true);
        sessionManager.setAuthToken(Access_Token_Static);

        if(getIsCp() && isWhiteLabel && sessionManager.getUserType() == "B")
        {
            sessionManager.setGoalCount(0);
            sessionManager.setNoGoal("");
        }

        if (getIsCp())
        {
          _getProfileDataForCP();
        }
        else
        {
          _getProfileData();
        }
      }
      catch (e)
      {
        print(e);
      }

      setState(() {
        _isLoading = false;
      });

    } else {

      showSnackBar(dataResponse.message, context);

      setState(() {
        _isLoading = false;
      });
    }*/
  }

  void callIntent() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SyncDataScreen()), (Route<dynamic> route) => false);
  }

  @override
  void castStatefulWidget() {
    widget is VerifyOTPScreen;
  }
}
