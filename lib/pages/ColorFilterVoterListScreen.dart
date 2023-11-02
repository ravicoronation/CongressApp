import 'dart:async';
import 'package:congress_app/pages/VoterDetailsPage.dart';
import 'package:congress_app/utils/no_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../local_storage/db_helper.dart';
import '../model/ColorCodeResponseModel.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading_home.dart';
import 'FilterByValueVoterListScreen.dart';

class ColorFilterVoterListScreen extends StatefulWidget {

  const ColorFilterVoterListScreen({Key? key}) : super(key: key);

  @override
  _ColorFilterVoterListScreen createState() => _ColorFilterVoterListScreen();
}

class _ColorFilterVoterListScreen extends BaseState<ColorFilterVoterListScreen> {
  bool _isLoading = false;
  var listBooth = List<Voters>.empty(growable: true);
  var colorCodeList = List<Colorcode>.empty(growable: true);
  final dbHelper = DbHelper.instance;
  DateTime preBackPressTime = DateTime.now();
  ScrollController _scrollViewController = ScrollController();
  bool isScrollingDown = false;
  String filterBoothName = "All Booth";
  String filterBoothNameTitle = isLanguageEnglish() ? "All Booth" : "అన్ని బూత్";
  String filterBoothPartNo = "";

  @override
  void initState() {
    colorCodeList =  NavigationService.colorCodeList;
    super.initState();
    getFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: appBg,
        appBar: AppBar(
          toolbarHeight: 48,
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
              getTitle(isLanguageEnglish() ? "Color Wise" : "రంగు వైజ్"),
            ],
          ),
          actions: [
          ],
        ),
        body: Column(
          children: [
            filterData(),
            _isLoading
                ? const Expanded(child: LoadingHomeWidget())
                : Expanded(
                    child: colorCodeList.isEmpty
                        ? const MyNoDataWidget(msg: "No Voters Found.")
                        : SingleChildScrollView(controller: _scrollViewController, child: setData())),
          ],
        ),
      ),
    );
  }

  Container filterData() {
    return Container(
      decoration: getCommonCardBasicBottom(),
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      listBooth.length == 1
                          ? isLanguageEnglish()
                          ? "Booth Name"
                          : "బూత్ పేరు"
                          : isLanguageEnglish()
                          ? "Select Booth"
                          : "బూత్ ఎంచుకోండి",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  ":",
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: textFiledSize),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      if (listBooth.isNotEmpty) {
                        if (listBooth.length > 1) {
                          _showSelectionDialog(2);
                        }
                      } else {
                        showToast("Data not found.", context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10, top: 6, bottom: 6),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 6, bottom: 6),
                              child: Row(
                                children: [
                                  Gap(10),
                                  Expanded(
                                      child: Text(
                                        "$filterBoothPartNo - $filterBoothNameTitle",
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                      )),
                                  Visibility(
                                      visible: listBooth.length > 1,
                                      child: Image.asset(
                                        'assets/images/ic_arrow_down.png',
                                        width: 14,
                                        height: 14,
                                        color: white,
                                      )),
                                  const Gap(10)
                                ],
                              )),
                          const Divider(
                            height: 0.5,
                            color: white,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              isLanguageEnglish() ? "Color List" : "రంగు జాబితా",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                            ),
                          )),
                      const VerticalDivider(
                        thickness: 0.5,
                        color: gray,
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              isLanguageEnglish() ? "Total Qty" : "మొత్తం క్యూటీ",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                            ),
                          )),
                    ],
                  ),
                )),
            const Divider(
              height: 0.5,
              color: gray,
            )
          ],
        ),
        setProjectList()
      ],
    );
  }

  setProjectList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: colorCodeList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              startActivity(context, FilterByValueVoterListScreen(colorCodeList[index].colorNameEn.toString(),colorCodeList[index].colorCode.toString(),"Color List",filterBoothName));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(int.parse(colorCodeList[index].colorCodeHEX.toString().replaceAll('#', '0x'))),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    checkAndSetColorName(colorCodeList[index]),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                  ),
                                )),
                            const VerticalDivider(
                              thickness: 0.5,
                              color: gray,
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    checkValidString(colorCodeList[index].count.toString()),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                  ),
                                )),
                          ],
                        ),
                      )),
                ),
                const Divider(
                  height: 0.5,
                  color: gray,
                )
              ],
            ));
      },
    );
  }

  Future<void> getFirstPage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final boothListData = await dbHelper.getAllBooth();
      if (boothListData != null) {
        if (boothListData.isNotEmpty) {
          setState(() {
            listBooth.addAll(boothListData);
            filterBoothName = listBooth[0].partNameEn.toString().trim();
            filterBoothPartNo = listBooth[0].partNo.toString().trim();
            filterBoothNameTitle = isLanguageEnglish() ? listBooth[0].partNameEn.toString().trim() : listBooth[0].partNameV1.toString().trim();
          });
        }
      }
      getCountFromCode();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCountFromCode() async {
    try {
      setState(() {
        _isLoading = true;
      });

      for(int i=0; i < colorCodeList.length; i++)
      {
        colorCodeList[i].count = await dbHelper.getAllVotersFilterTypeColor(filterBoothName == "All Booth" ? "" : filterBoothName, colorCodeList[i].colorCode.toString());
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showSelectionDialog(int isFor) {
    String title = "";
    if (isFor == 2) {
      title = "Select Booth";
    }

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
            return SizedBox(
              height: getItemCount(isFor) <= 5
                  ? MediaQuery.of(context).size.height * 0.35
                  : getItemCount(isFor) > 10
                      ? MediaQuery.of(context).size.height * 0.85
                      : MediaQuery.of(context).size.height * 0.60,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 2,
                      width: 28,
                      alignment: Alignment.center,
                      color: black,
                      margin: const EdgeInsets.only(top: 10, bottom: 12),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Text(title, style: const TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: getItemCount(isFor),
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (isFor == 2) {
                                    if (listBooth[index].partNameEn.toString() != filterBoothName) {
                                      filterBoothName = checkValidString(listBooth[index].partNameEn.toString());
                                      filterBoothPartNo = checkValidString(listBooth[index].partNo.toString().trim());
                                      filterBoothNameTitle = isLanguageEnglish() ? listBooth[index].partNameEn.toString().trim() : listBooth[index].partNameV1.toString().trim();
                                      Navigator.pop(context);
                                      Timer(const Duration(milliseconds: 300), () => getCountFromCode());
                                    }
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
                                      alignment: Alignment.centerLeft,
                                      child: setTextData(isFor, index),
                                    ),
                                    Container(height: 0.5, color: grayLight)
                                  ],
                                ),
                              );
                            })),
                  ],
                ),
              ),
            );
          });
        });
  }

  getItemCount(int isFor) {
    if (isFor == 2) {
      return listBooth.length;
    }
  }

  setTextData(int isFor, int index) {
    if (isFor == 2) {
      return Text(
        "${checkValidString(listBooth[index].partNo.toString())}. " + checkValidString(listBooth[index].partNameEn),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listBooth[index].partNameEn.toString() == filterBoothName.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listBooth[index].partNameEn.toString() == filterBoothName.toString() ? darOrange : black),
      );
    }
  }

  @override
  void castStatefulWidget() {
    widget is ColorFilterVoterListScreen;
  }

  String checkAndSetColorName(Colorcode colorCodeList) {

    String data = "";
    if(isLanguageEnglish())
      {
        if(colorCodeList.colorNameV1 == null || checkValidString(colorCodeList.colorNameV1).toString().isEmpty)
          {
            data = checkValidString(colorCodeList.colorNameEn);

          }
        else
          {
            data = checkValidString(colorCodeList.colorNameV1);
          }
      }
    else
      {
        data = checkValidString(colorCodeList.colorNameEn);
      }
    return data;
  }
}
