import 'dart:async';
import 'package:congress_app/pages/login_screen.dart';
import 'package:congress_app/utils/session_manager_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../local_storage/db_helper.dart';
import '../model/menu_model.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import 'VoterListScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends BaseState<HomePage> {
  List<MenuGetSet> menuList = List<MenuGetSet>.empty(growable: true);
  DateTime preBackPressTime = DateTime.now();
  final dbHelper = DbHelper.instance;
  String titledata = "";
  String constNo = "";

  @override
  void initState() {
    menuList = [
      MenuGetSet(nameStatic: "Search", itemIconStatic: "assets/images/ic_search_home.png"),
      MenuGetSet(nameStatic: "Voter List", itemIconStatic: "assets/images/ic_voters.png"),
      MenuGetSet(nameStatic: "Distribution", itemIconStatic: "assets/images/ic_distribution.png"),
      MenuGetSet(nameStatic: "Language", itemIconStatic: "assets/images/ic_language.png"),
    ];

    String acNo = "";
    String acName = "";
    if (NavigationService.statisticsData.isNotEmpty) {
      for (int i = 0; i < NavigationService.statisticsData.length; i++) {
        if (NavigationService.statisticsData[i].name == "ac_no") {
          acNo = NavigationService.statisticsData[i].value.toString().trim();
        }

        if (NavigationService.statisticsData[i].name == "ac_name") {
          acName = NavigationService.statisticsData[i].value.toString().trim();
        }
      }

      titledata = "$acNo $acName General Election 2023";
      constNo = acNo;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final timeGap = DateTime.now().difference(preBackPressTime);
        final cantExit = timeGap >= const Duration(seconds: 2);
        preBackPressTime = DateTime.now();
        if (cantExit) {
          showSnackBar('Press back button again to exit', context);
          return Future.value(false);
        } else {
          SystemNavigator.pop();
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: dashboardBg,
        appBar: AppBar(
          toolbarHeight: 48,
          automaticallyImplyLeading: false,
          backgroundColor: appBg,
          elevation: 3,
          titleSpacing: 12,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset(
                'assets/images/ic_logo.jpg',
                width: 42,
                height: 42,
              ),
              const Gap(12),
              getTitle("Congress Party"),
            ],
          ),
          actions: [
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                showActionDialog();
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Padding(padding: const EdgeInsets.all(10.0), child: Image.asset('assets/images/ic_more.png', width: 24, height: 24)),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Visibility(
              visible: titledata.isNotEmpty,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(6),
                  decoration: getCommonCardBasicBottom(),
                  child: Column(
                    children: [
                      Text(
                        titledata,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSize),
                      ),
                      Visibility(
                          visible: constNo.isNotEmpty,
                          child: Text(
                            "Const No.$constNo",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSize),
                          ))
                    ],
                  )),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(15),
              child: setProjectList(),
            ))
          ],
        ),
      ),
    );
  }

  setProjectList() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 120, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: menuList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          hoverColor: Colors.white.withOpacity(0.0),
          onTap: () async {
            if (menuList[index].name.toString() == "Voter List") {
              startActivity(context, VoterListScreen());
            }
          },
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 6, bottom: 10, top: 10),
            width: double.infinity,
            decoration: getCommonCardBasicNew(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(menuList[index].itemIcon, height: 36, width: 36,color: darOrange),
                const Gap(12),
                Text(menuList[index].name.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: darOrange, //Color(int.parse(analysisList[index].arrowColor.replaceAll('#', '0x'))),
                        fontWeight: FontWeight.w700,
                        fontSize: 16))
              ],
            ),
          ),
        );
      },
    );
  }

  void showActionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(height: 15),
                    Container(height: 2, width: 40, color: darOrange, margin: const EdgeInsets.only(bottom: 12)),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "My Profile",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: grayLight,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        logoutFromApp();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Logout",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 20)
                  ],
                ))
          ],
        );
      },
    );
  }

  void logoutFromApp() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              decoration:
                  const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: black,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: kButtonHeight,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(kBorderRadius), side: const BorderSide(width: 1, color: black)),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: black)),
                                ))),
                        const Gap(20),
                        Expanded(
                          child: SizedBox(
                            height: kButtonHeight,
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(kBorderRadius),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(black)),
                              onPressed: () async {
                                dbHelper.deleteAllTableData();
                                Navigator.pop(context);
                                SessionManagerNew.clear();
                                Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                              },
                              child: const Text("Yes", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void castStatefulWidget() {
    widget is HomePage;
  }
}
