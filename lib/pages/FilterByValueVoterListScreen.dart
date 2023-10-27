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

class FilterByValueVoterListScreen extends StatefulWidget {
   final String filterType;
   final String filterValue;
   final String title;
   final String boothId;
   const FilterByValueVoterListScreen(this.filterType,this.filterValue,this.title,this.boothId,{Key? key}) : super(key: key);

  @override
  _FilterByValueVoterListScreen createState() => _FilterByValueVoterListScreen();
}

class _FilterByValueVoterListScreen extends BaseState<FilterByValueVoterListScreen> {
  bool _isLoading = false;
  var listVoters = List<Voters>.empty(growable: true);
  final dbHelper = DbHelper.instance;
  DateTime preBackPressTime = DateTime.now();
  ScrollController _scrollViewController = ScrollController();
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 200;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  String searchHint = "Search by name...";
  String searchParam = "";
  String filterType = "";
  String filterValue = "";
  String title = "";
  String boothId = "";

  final TextEditingController _searchController = TextEditingController();
  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    filterType = (widget as FilterByValueVoterListScreen).filterType;
    filterValue = (widget as FilterByValueVoterListScreen).filterValue;
    title = (widget as FilterByValueVoterListScreen).title;
    boothId = (widget as FilterByValueVoterListScreen).boothId;
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
              getTitle(filterType),
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
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        children: [
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

      final voterListData = await dbHelper.getAllVoterFormFilterValue(_pageResult,_pageIndex,searchParam,filterType,filterValue,title,boothId);

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
        final voterListData = await dbHelper.getAllVoterFormFilterValue(_pageResult,_pageIndex*_pageResult,searchParam,filterType,filterValue,title,boothId);
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

  @override
  void castStatefulWidget() {
    widget is FilterByValueVoterListScreen;
  }
}
