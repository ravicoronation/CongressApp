import 'dart:async';
import 'package:congress_app/pages/DashBoardScreen.dart';
import 'package:congress_app/pages/login_screen.dart';
import 'package:congress_app/pages/sync_data_screen.dart';
import 'package:congress_app/utils/app_utils.dart';
import 'package:congress_app/utils/session_manager.dart';
import 'package:congress_app/utils/session_manager_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManagerNew.init();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 2000 << 40; // for increase the cache memory
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Congress App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: createMaterialColor(white),
          platform: TargetPlatform.iOS,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: white,
            contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide:  const BorderSide(width: 0.5, style: BorderStyle.solid, color: gray)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 0.5, style: BorderStyle.solid, color: darOrange)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 0.5, color: gray)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width:0.5, color: gray)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width:0.5, style: BorderStyle.solid, color: gray)),
            labelStyle: const TextStyle(
              color: black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: const TextStyle(color: black,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false ;
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    doSomeAsyncStuff();
  }

  Future<void> doSomeAsyncStuff() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
      if(isLoggedIn)
      {
          if(sessionManager.checkIsDataSync() == true)
          {
            Timer(const Duration(seconds:1),
                    () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const DashBoardScreen()), (Route<dynamic> route) => false));
          }
          else
            {
              Timer(const Duration(seconds:1),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const SyncDataScreen()), (Route<dynamic> route) => false));
            }
      }
      else
      {
        Timer(
            const Duration(milliseconds:5),
                () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const LoginScreen()), (Route<dynamic> route) => false));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: white),
        child: Center(
          child:  Container(
              height: MediaQuery.of(context).size.height,
              color: white,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/ic_logo.png',
                    height: 300,
                    width: 300),
              )
          ,
        ),
      ),
    ));
  }
}
