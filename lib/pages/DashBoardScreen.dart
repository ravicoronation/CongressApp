import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:congress_app/constant/api_end_point.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading.dart';
import '../utils/no_data.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreen createState() => _DashBoardScreen();
}

class _DashBoardScreen extends BaseState<DashBoardScreen> {
  bool _isLoading = false;
  var listVoters = List<Voters>.empty(growable: true);
  final dbHelper = DbHelper.instance;
  @override
  void initState() {
    getDataFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        backgroundColor: appBg,
        elevation: 0,
        titleSpacing: 22,
        centerTitle: false,
        title: getTitle("Dashboard"),
        actions: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () async {

              },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Padding(padding: const EdgeInsets.all(10.0), child: Image.asset('assets/images/ic_notification.png', width: 24, height: 24)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: blue,
        child: Column(
          children: [
            Expanded(child:
            _isLoading ? const LoadingWidget()
                : SingleChildScrollView(child: setData())),
          ],
        ),
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
        return Container(
          margin: EdgeInsets.all(15),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkValidStringWithToDisplayCase(listVoters[index].fullNameEn.toString().trim()),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: textFiledSize),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getDataFromLocal() async
  {
    try {
      setState(() {
        _isLoading = true;
      });
      int? count = await dbHelper.getCount();
      if(count! > 0)
      {
        final feedListData = await dbHelper.getAllFeeds();
        print("<><>> DATA BASE AISe" + feedListData.length.toString() + " <><>");
        if (feedListData.isNotEmpty)
        {
          setState(() {
            listVoters.addAll(feedListData);
            _isLoading = false;
          });
        }
        else
        {
          getAllApiData();
        }
      }
      else
        {
          getAllApiData();
        }
    } catch (e) {
      print(e);
      getAllApiData();
    }
  }

  Future<bool> _refresh() {
    print("refresh......");
   // getAllApiData();
    return Future.value(true);
  }

  //API Call func...
  void getAllApiData() async {
    setState(() {
      _isLoading = true;
    });

    var urlCreate = API_URL + sessionManager.getAcNo().toString().trim() + "/voters/part/" + sessionManager.getPart().toString().trim();
    final url = Uri.parse(urlCreate);
    var request = http.MultipartRequest('GET', url);
    request.fields.addAll({
      'token': Token
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200)
    {
      final body = await response.stream.bytesToString();
      Map<String, dynamic> user = jsonDecode(body);
      final statusCode = response.statusCode;
      var dataResponse = VoterListResponse.fromJson(user);
      if (statusCode == 200 && checkValidString(dataResponse.message) == "Success") {
        try {
            if(dataResponse.voters !=null)
            {
              if(dataResponse.voters!.isNotEmpty)
              {
                var wait = await dbHelper.deleteFeedData();
                var listData = List<Voters>.empty(growable: true);
                listData.addAll(dataResponse.voters!);
                await addDataInDB(listData);
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
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void castStatefulWidget() {
    widget is DashBoardScreen;
  }

  addDataInDB(List<Voters> listData) {

    for (final voterItem in listData) {
      dbHelper.insertFeeds(voterItem);
    }
  }
}
