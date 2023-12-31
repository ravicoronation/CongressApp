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
import '../local_storage/db_helper.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading_home.dart';
import '../utils/voter_color.dart';

class AgeWiseVoterListScreen extends StatefulWidget {
   const AgeWiseVoterListScreen({Key? key}) : super(key: key);

  @override
  _AgeWiseVoterListScreen createState() => _AgeWiseVoterListScreen();
}

class _AgeWiseVoterListScreen extends BaseState<AgeWiseVoterListScreen> {
  bool _isLoading = false;
  var listVoters = List<Voters>.empty(growable: true);
  var listBooth = List<Voters>.empty(growable: true);
  var listFromAge = List<String>.empty(growable: true);
  var listToAge = List<String>.empty(growable: true);

  final dbHelper = DbHelper.instance;
  DateTime preBackPressTime = DateTime.now();
  ScrollController _scrollViewController = ScrollController();
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 200;
  bool _isLastPage = false;
  bool isScrollingDown = false;

  String filterBoothName = "All Booth";
  String filterBoothNameTitle = isLanguageEnglish() ? "All Booth" : "అన్ని బూత్";
  String filterBoothPartNo = "";
  String searchHint = isLanguageEnglish() ? "Search by name..." : "పేరు ద్వారా శోధించండి...";
  String searchParam = "";
  String fromAge = "From";
  String toAge = "To";

  String fromAgeTitle = isLanguageEnglish() ? "From" : "నుండి";
  String toAgeTitle = isLanguageEnglish() ? "To" : "కు";

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
    Timer(const Duration(milliseconds: 300), () =>  getFirstPage(true));
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
              getTitle(isLanguageEnglish() ? "Age Wise" : "వయస్సు వారీగా"),
            ],
          ),
          actions: [
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
          Row(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      isLanguageEnglish() ? "Select Age" : "వయస్సును ఎంచుకోండి",
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
                  child: Row(
                    children: [
                      Expanded(child: GestureDetector(
                        onTap: (){
                          if(listFromAge.isNotEmpty)
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
                                        fromAgeTitle,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                      )),
                                      Image.asset(
                                        'assets/images/ic_arrow_down.png',
                                        width: 14,
                                        height: 14,
                                        color: white,
                                      ),
                                      Gap(10)
                                    ],
                                  )),
                              const Divider(
                                height: 0.5,
                                color: white,
                              ),
                            ],
                          ),
                        ),
                      )),
                      Expanded(child: GestureDetector(
                        onTap: (){
                          if(listToAge.isNotEmpty)
                          {
                            _showSelectionDialog(4);
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
                                        toAgeTitle,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                      )),
                                      Image.asset(
                                        'assets/images/ic_arrow_down.png',
                                        width: 14,
                                        height: 14,
                                        color: white,
                                      ),
                                      Gap(10)
                                    ],
                                  )),
                              const Divider(
                                height: 0.5,
                                color: white,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
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
                          "${listVoters[index].slnoinpart.toString()}.",//"${toDisplayCase(listVoters[index].id.toString().trim())}.",
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
                              toDisplayCase(isLanguageEnglish() ? listVoters[index].fullNameEn.toString().trim() : listVoters[index].fullNameV1.toString().trim()),
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
                        Column(
                          children: [
                            Visibility(
                                visible: checkValidString(listVoters[index].mobileNo).toString().isNotEmpty,
                                child: GestureDetector(
                                    onTap: () {
                                      makePhoneCall(checkValidString(listVoters[index].mobileNo).toString().trim());
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Image.asset(
                                        'assets/images/ic_call_new.png',
                                        width: 18,
                                        height: 18,
                                        color: darOrange,
                                      ),
                                    ))),
                            VoterColorWidget(colorCode: listVoters[index].colorCode)
                          ],
                        )
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
          final boothListData = await dbHelper.getAllBooth();
          if (boothListData != null)
          {
            if (boothListData.isNotEmpty)
            {
              setState(() {
                listBooth.addAll(boothListData);
                filterBoothName = listBooth[0].partNameEn.toString().trim();
                filterBoothPartNo = listBooth[0].partNo.toString().trim();
                filterBoothNameTitle = isLanguageEnglish() ? listBooth[0].partNameEn.toString().trim() : listBooth[0].partNameV1.toString().trim();
              });
            }
          }
        }

      final voterListData = await dbHelper.getAllVotersFilterTypeAge(_pageResult,_pageIndex,filterBoothName == "All Booth" ? "" : filterBoothName,searchParam,fromAge == "From" ? "" : fromAge,toAge == "To" ? "" : toAge);

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
        final voterListData = await dbHelper.getAllVotersFilterTypeAge(_pageResult,_pageIndex*_pageResult,filterBoothName == "All Booth" ? "" : filterBoothName,searchParam,fromAge == "From" ? "" : fromAge,toAge == "To" ? "" : toAge);
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
    if (isFor == 2) {
      title = "Select Booth";
    }
    else if (isFor == 3) {
      title = "Select From Age";
    }
    else if (isFor == 4) {
      title = "Select To Age";
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
                                  FocusScope.of(context).unfocus();
                                  if (isFor == 2)
                                  {
                                    if (listBooth[index].partNameEn.toString() != filterBoothName)
                                    {
                                      filterBoothName = checkValidString(listBooth[index].partNameEn.toString());
                                      filterBoothPartNo = checkValidString(listBooth[index].partNo.toString().trim());
                                      filterBoothNameTitle = isLanguageEnglish() ? listBooth[index].partNameEn.toString().trim() : listBooth[index].partNameV1.toString().trim();
                                      Navigator.pop(context);
                                      Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                    }
                                  }
                                  else  if (isFor == 3)
                                  {
                                    if (listFromAge[index].toString() != fromAge)
                                    {
                                      fromAge = checkValidString(listFromAge[index].toString());
                                      fromAgeTitle = checkValidString(listFromAge[index].toString());
                                      toAge = "To";
                                      toAgeTitle = "To";
                                      Navigator.pop(context);
                                      Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                    }
                                  }
                                  else  if (isFor == 4)
                                  {
                                    if (listToAge[index].toString() != toAge)
                                    {
                                      if(fromAge != "From")
                                        {
                                          if(int.parse(listToAge[index].toString()) >= int.parse(fromAge))
                                          {
                                            toAge = checkValidString(listToAge[index].toString());
                                            toAgeTitle = checkValidString(listToAge[index].toString());
                                            Navigator.pop(context);
                                            Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                          }
                                          else{
                                            showToast("Please select valid To age.", context);
                                          }
                                        }
                                      else
                                        {
                                          toAge = checkValidString(listToAge[index].toString());
                                          toAgeTitle = checkValidString(listToAge[index].toString());
                                          Navigator.pop(context);
                                          Timer(const Duration(milliseconds: 300), () =>  getFirstPage(false));
                                        }
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
    else if (isFor == 3) {
      return listFromAge.length;
    }
    else if (isFor == 4) {
      return listToAge.length;
    }
  }

  setTextData(int isFor, int index) {
    if (isFor == 2) {
      return Text(
          "${checkValidString(listBooth[index].partNo.toString())}. " +checkValidString(listBooth[index].partNameEn),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listBooth[index].partNameEn.toString() == filterBoothName.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listBooth[index].partNameEn.toString() == filterBoothName.toString() ? darOrange : black),
      );
    }
    else  if (isFor == 3) {
      return Text(
        checkValidString(listFromAge[index]),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listFromAge[index] == fromAge.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listFromAge[index] == fromAge.toString() ? darOrange : black),
      );
    }
    else  if (isFor == 4) {
      return Text(
        checkValidString(listToAge[index]),
        style: TextStyle(
            fontSize: 16,
            fontWeight: listToAge[index] == toAge.toString() ? FontWeight.w600 : FontWeight.w400,
            color: listToAge[index] == toAge.toString() ? darOrange : black),
      );
    }
  }


  @override
  void castStatefulWidget() {
    widget is AgeWiseVoterListScreen;
  }


  void setStaticListData() {
    for(int i=18; i<= 100 ;i++)
      {
        listFromAge.add(i.toString());
      }

    for(int i=18; i<= 100 ;i++)
    {
      listToAge.add(i.toString());
    }
  }
}
