import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePage createState() => _MyProfilePage();
}

class _MyProfilePage extends BaseState<MyProfilePage> {

  String titledata = "";

  @override
  void initState() {
    super.initState();
    String acNo = "";
    String acName = "";
    if (NavigationService.statisticsData.isNotEmpty)
    {
      for (int i = 0; i < NavigationService.statisticsData.length; i++)
      {
        if (NavigationService.statisticsData[i].name == "ac_no")
        {
          acNo = NavigationService.statisticsData[i].value.toString().trim();
        }

        if (NavigationService.statisticsData[i].name == "ac_name")
        {
          acName = NavigationService.statisticsData[i].value.toString().trim();
        }
      }
      titledata = "$acNo - $acName";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        backgroundColor: appBg,
        elevation: 3,
        titleSpacing: 12,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/ic_logo.jpg',
                width: 42,
                height: 42,
              ),
            ),
            const Gap(12),
            getTitle("My Profile"),
          ],
        ),
        actions: [
        ],
      ),
      body: Column(
        children: [
          Expanded(child: setData()),
        ],
      ),
    );
  }

  setData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(15),
                decoration: getCommonCard(),
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 5),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Image.asset('assets/images/ic_user_placeholder.png', width: 120, height: 120),
                    const Gap(20),
                    Text(
                      "Full Name",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSize),
                    ),
                    Text(
                      toDisplayCase(sessionManager.getWorkerName().toString().trim()),
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: darOrange, fontWeight: FontWeight.w700, fontSize: textFiledSize),
                    ),
                    const Gap(20),
                    Text(
                      "Mobile Number",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSize),
                    ),
                    Text(
                      toDisplayCase(sessionManager.getWorkerPhone().toString().trim()),
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: darOrange, fontWeight: FontWeight.w700, fontSize: textFiledSize),
                    ),
                    const Gap(20),
                    Text(
                      "Assembly Name",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSize),
                    ),
                    Text(
                       titledata,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: darOrange, fontWeight: FontWeight.w700, fontSize: textFiledSize),
                    ),
                    const Gap(20),
                    Text(
                      "Election Name",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSize),
                    ),
                    Text(
                      "Telangana Assembly Election - 2023",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: darOrange, fontWeight: FontWeight.w700, fontSize: textFiledSize),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void castStatefulWidget() {
    widget is MyProfilePage;
  }
}
