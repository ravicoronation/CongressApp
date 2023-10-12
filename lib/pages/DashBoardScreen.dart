import 'dart:async';
import 'package:congress_app/pages/VoterDetailsPage.dart';
import 'package:congress_app/pages/login_screen.dart';
import 'package:congress_app/utils/no_data.dart';
import 'package:congress_app/utils/session_manager_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading_home.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreen createState() => _DashBoardScreen();
}

class _DashBoardScreen extends BaseState<DashBoardScreen> {
  bool _isLoading = false;
  var listVoters = List<Voters>.empty(growable: true);
  var listMandal = List<String>.empty(growable: true);
  var listBooth = List<String>.empty(growable: true);
  var listSearchBy = List<String>.empty(growable: true);

  final dbHelper = DbHelper.instance;
  DateTime preBackPressTime = DateTime.now();
  ScrollController _scrollViewController = ScrollController();
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 200;
  bool _isLastPage = false;
  bool isScrollingDown = false;

  String filterMandal = "All Mandal";
  String filterBoothName = "All Booth";
  String filterSearchBy = "Name-Regular Search";
  String searchHint = "Search by name...";
  String searchParam = "";

  final TextEditingController _searchController = TextEditingController();
  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    setStaticListData();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
      pagination();
    });
    getFirstPage(true);
    super.initState();
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          if (listVoters.isNotEmpty) {
            _pageIndex += 1;
          }
          getDataFromLocalPagination();
        });
      }
    }
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
              Image.asset(
                'assets/images/ic_logo.png',
                width: 42,
                height: 42,
              ),
              const Gap(12),
              getTitle("All Voter List"),
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
            filterData(),
            _isLoading ? const Expanded(child: LoadingHomeWidget()) : Expanded(child: listVoters.isEmpty ? const MyNoDataWidget(msg: "No Voters Found.") : SingleChildScrollView(
                controller: _scrollViewController,
                child: setData())),
            Visibility(
                visible: _isLoadingMore,
                child: Container(
                  color: dashboardBg,
                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: Lottie.asset('assets/images/loader.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                      const Text(' Loading more...', style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16))
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container filterData() {
    return Container(
      decoration: getCommonCardBasicBottom(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Select Mandal",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8),
                child: Text(
                  ":",
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: textFiledSize),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: (){
                      if(listMandal.isNotEmpty)
                      {
                        _showSelectionDialog(1);
                      }
                      else
                      {
                        showToast("Data not found.", context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10,top: 6,bottom: 6),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 6,bottom: 6),
                              child: Row(
                                children: [
                                  Gap(10),
                                  Expanded(child: Text(
                                    filterMandal,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                  )),
                                  Image.asset(
                                    'assets/images/ic_arrow_down.png',
                                    width: 14,
                                    height: 14,
                                    color: black,
                                  ),
                                  Gap(10)
                                ],
                              )),
                          const Divider(
                            height: 0.5,
                            color: black,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Select Booth",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8),
                child: Text(
                  ":",
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: textFiledSize),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: (){
                      if(listBooth.isNotEmpty)
                      {
                        _showSelectionDialog(2);
                      }
                      else
                      {
                        showToast("Data not found.", context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10,top: 6,bottom: 6),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 6,bottom: 6),
                              child: Row(
                                children: [
                                  Gap(10),
                                  Expanded(child: Text(
                                    filterBoothName,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                  )),
                                  Image.asset(
                                    'assets/images/ic_arrow_down.png',
                                    width: 14,
                                    height: 14,
                                    color: black,
                                  ),
                                  Gap(10)
                                ],
                              )),
                          const Divider(
                            height: 0.5,
                            color: black,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Search By",
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8),
                child: Text(
                  ":",
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: textFiledSize),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: (){
                      if(listSearchBy.isNotEmpty)
                      {
                        _showSelectionDialog(3);
                      }
                      else
                      {
                        showToast("Data not found.", context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10,top: 6,bottom: 6),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 6,bottom: 6),
                              child: Row(
                                children: [
                                  Gap(10),
                                  Expanded(child: Text(
                                    filterSearchBy,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                  )),
                                  Image.asset(
                                    'assets/images/ic_arrow_down.png',
                                    width: 14,
                                    height: 14,
                                    color: black,
                                  ),
                                  Gap(10)
                                ],
                              )),
                          const Divider(
                            height: 0.5,
                            color: black,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 8),
            height: 42,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Row(
              children: [
                Expanded(child: TextField(
                  cursorColor: black,
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.words,
                  style: editTextStyleSmall(),
                  onSubmitted: (text) {
                    if (text.isNotEmpty && text.length > 2) {
                      searchParam = text;
                      getFirstPage(false);
                    } else {
                      setState(() {
                        searchParam = "";
                        _searchController.clear();
                        getFirstPage(false);
                      });
                    }
                  },
                  onChanged: (value) {
                    /* setState(() {
                      searchParam = value;
                    });*/
                  },
                  decoration: InputDecoration(
                      hintText: searchHint,
                      contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                      hintStyle: const TextStyle(color: black, fontSize: 14,fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kButtonCornerRadius),
                          borderSide:  const BorderSide(width: 0.5, style: BorderStyle.solid, color: white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kButtonCornerRadius),
                          borderSide: const BorderSide(width: 0.5, style: BorderStyle.solid, color: white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kButtonCornerRadius),
                          borderSide: const BorderSide(width:0.5, style: BorderStyle.solid, color: white)),
                      suffixIcon: GestureDetector(
                        onTap: ()
                        {
                          if(searchParam.isNotEmpty)
                          {
                            setState(() {
                              searchParam = "";
                              _searchController.clear();
                            });

                            getFirstPage(false);
                          }
                          else
                          {
                            setState(() {
                              searchParam = "";
                              _searchController.clear();
                            });
                          }
                        },
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/ic_close_new.png',
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      )
                  ),
                )),
              ],
            ),
          )
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
      itemCount: listVoters.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              startActivity(context, VoterDetailsPage(listVoters[index]));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}.",//"${toDisplayCase(listVoters[index].id.toString().trim())}.",
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: contentSizeSmall),
                        ),
                        const Gap(6),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              toDisplayCase(listVoters[index].fullNameEn.toString().trim()),
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSizeSmall),
                            ),
                            Text(
                              "${toDisplayCase(listVoters[index].gender.toString().trim())} - ${toDisplayCase(listVoters[index].age.toString().trim())}",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: contentSizeSmall),
                            )
                          ],
                        )),
                        const Gap(10),
                        Visibility(
                            visible: checkValidString(listVoters[index].mobileNo).toString().isNotEmpty,
                            child: GestureDetector(
                                onTap: () {
                                  makePhoneCall(checkValidString(listVoters[index].mobileNo).toString().trim());
                                },
                                child: Image.asset(
                                  'assets/images/ic_call_new.png',
                                  width: 18,
                                  height: 18,
                                  color: darOrange,
                                )))
                      ],
                    )),
                const Divider(
                  height: 0.5,
                  color: grayLight,
                )
              ],
            ));
      },
    );
  }

  Future<void> getFirstPage([bool isFromInit = false]) async {
    try {
      setState(() {
        _pageIndex = 0;
        _isLastPage = false;
        _isLoading = true;
      });

      if(isFromInit)
        {
          final mandalListData = await dbHelper.getAllMandal();
          if (mandalListData != null)
          {
            if (mandalListData.isNotEmpty)
            {
              setState(() {
                listMandal.addAll(mandalListData);
              });
            }
          }

          final boothListData = await dbHelper.getAllBooth('');
          if (boothListData != null)
          {
            if (boothListData.isNotEmpty)
            {
              setState(() {
                listBooth.addAll(boothListData);
                filterBoothName = listBooth[0].toString().trim();
              });
            }
          }
        }

      final voterListData = await dbHelper.getAllVoters(_pageResult,_pageIndex,filterMandal == "All Mandal" ? "" :filterMandal ,filterBoothName == "All Booth" ? "" : filterBoothName,searchParam,filterSearchBy);

      listVoters = [];
      if (voterListData != null)
      {
        if (voterListData.isNotEmpty)
        {
          setState(() {
            listVoters.addAll(voterListData);
            _isLoading = false;
          });
        }
        else
        {
          setState(() {
            listVoters = [];
            _isLoading = false;
          });

        }
      }
      else
      {
        setState(() {
          listVoters = [];
          _isLoading = false;
        });
      }

    } catch (e) {
      print(e);
    }
  }

  Future<void> getDataFromLocalPagination() async {
    try {
      setState(() {
        _isLoadingMore = true;
      });
      int? count = await dbHelper.getCount();
      if (count! > 0) {
        final voterListData = await dbHelper.getAllVoters(_pageResult,_pageIndex*_pageResult,filterMandal == "All Mandal" ? "" :filterMandal ,filterBoothName == "All Booth" ? "" : filterBoothName,searchParam,filterSearchBy);
        if (voterListData != null) {
          if (voterListData.isNotEmpty)
          {
            setState(() {
              if (voterListData.isNotEmpty) {
                if (voterListData.isEmpty || voterListData.length % _pageResult != 0) {
                  _isLastPage = true;
                }
              }
              listVoters.addAll(voterListData);
              _isLoadingMore = false;
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _showSelectionDialog(int isFor) {
    String title = "";
    if (isFor == 1) {
      title = "Select Mandal";
    }
    else if (isFor == 2) {
      title = "Select Booth";
    }
    else if (isFor == 3) {
      title = "Select Search By";
    }

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
            return SizedBox(
              height:
              getItemCount(isFor) <= 5 ? MediaQuery.of(context).size.height * 0.35 :
              getItemCount(isFor) > 10 ? MediaQuery.of(context).size.height * 0.85 :
              MediaQuery.of(context).size.height * 0.60,
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
                        child:  ListView.builder(
                            itemCount: getItemCount(isFor),
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (isFor == 1)
                                  {
                                    if (listMandal[index] != filterMandal)
                                    {
                                      filterMandal = checkValidString(listMandal[index]);
                                      filterBoothName = "All Booth";
                                      Navigator.pop(context);
                                      Timer(const Duration(milliseconds: 300), () => getBoothFromMandal());
                                    }
                                  }
                                  else if (isFor == 2)
                                  {
                                    if (listBooth[index].toString() != filterBoothName)
                                    {
                                      filterBoothName = checkValidString(listBooth[index].toString());
                                      Navigator.pop(context);
                                      Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                    }
                                  }
                                  else if (isFor == 3)
                                  {
                                    setState(() {
                                      if (listSearchBy[index] != filterSearchBy)
                                      {
                                        filterSearchBy = checkValidString(listSearchBy[index]);
                                        Navigator.pop(context);
                                        if(searchParam.isNotEmpty)
                                        {
                                          searchParam = "";
                                          _searchController.clear();
                                          Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                        }

                                        if(filterSearchBy == "Name-Regular Search")
                                        {
                                          searchHint = "Search by name...";
                                        }
                                        else  if(filterSearchBy == "SRNO")
                                        {
                                          searchHint = "Search by srno...";
                                        }
                                        else  if(filterSearchBy == "CardNo")
                                        {
                                          searchHint = "Search by card no...";
                                        }
                                        else  if(filterSearchBy == "MobileNo")
                                        {
                                          searchHint = "Search by mobile no...";
                                        }
                                        else  if(filterSearchBy == "Name-Match Case")
                                        {
                                          searchHint = "Search by name match case...";
                                        }

                                      }
                                    });
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
    if (isFor == 1) {
      return listMandal.length;
    }
    else if (isFor == 2) {
      return listBooth.length;
    }
    else if (isFor == 3) {
      return listSearchBy.length;
    }
  }

  setTextData(int isFor, int index) {
    if (isFor == 1) {
      return Text(
        "${index + 1}. " +checkValidString(listMandal[index]),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listMandal[index] == filterMandal.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listMandal[index] == filterMandal.toString() ? darOrange : black),
      );
    }
    else if (isFor == 2) {
      return Text(
          "${index + 1}. " +checkValidString(listBooth[index]),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listBooth[index].toString() == filterBoothName.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listBooth[index].toString() == filterBoothName.toString() ? darOrange : black),
      );
    }
    else  if (isFor == 3) {
      return Text(
        "${index + 1}. " +checkValidString(listSearchBy[index]),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listSearchBy[index] == filterSearchBy.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listSearchBy[index] == filterSearchBy.toString() ? darOrange : black),
      );
    }
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
    widget is DashBoardScreen;
  }

  Future<void> getBoothFromMandal() async {
    listBooth = [];
    final boothListData = await dbHelper.getAllBooth(filterMandal);
    if (boothListData != null)
    {
      if (boothListData.isNotEmpty)
      {
        listBooth.addAll(boothListData);
        filterBoothName = listBooth[0].toString().trim();
        getFirstPage(false);
      }
    }
    else
    {
        getFirstPage(false);
    }
  }

  void setStaticListData() {
    listMandal.add("All Mandal");
    listSearchBy.add("Name-Regular Search");
    listSearchBy.add("SRNO");
    listSearchBy.add("CardNo");
    listSearchBy.add("MobileNo");
    listSearchBy.add("Name-Match Case");
  }



}
