import 'package:congress_app/constant/global_context.dart';
import 'dart:convert';

import 'package:congress_app/pages/login_screen.dart';
import 'package:congress_app/utils/session_manager_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/BasicResponseModel.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading_home.dart';
import 'FilterByValueVoterListScreen.dart';

class VoterDetailsPage extends StatefulWidget {
  final Voters voterDataItem;

  const VoterDetailsPage(this.voterDataItem, {Key? key}) : super(key: key);

  @override
  _VoterDetailsPage createState() => _VoterDetailsPage();
}

class _VoterDetailsPage extends BaseState<VoterDetailsPage> {
  bool _isLoading = false;
  Voters voterDataItem = Voters();
  final dbHelper = DbHelper.instance;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    voterDataItem = (widget as VoterDetailsPage).voterDataItem;
    getDataFromDB();
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
            getTitle("Voter Details"),
          ],
        ),
        actions: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () async {
              // showActionDialog();
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
          Expanded(child: _isLoading ? const LoadingHomeWidget() : setData()),
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
        Padding(padding: EdgeInsets.all(5),
         child: Row(
           children: [
             Expanded(child: GestureDetector(
               onTap: () {
                 if(checkValidString(voterDataItem.whatsappNo).toString().trim().isNotEmpty)
                 {
                     whatsapp(voterDataItem.whatsappNo.toString(), getShareTextData(), context);
                 }
                 else
                   {
                     showToast("Whatsapp Not Found", context);
                   }
               },
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_whatsapp.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             )),
             Expanded(child: GestureDetector(
               onTap: () {
                 if(checkValidString(voterDataItem.mobileNo).toString().trim().isNotEmpty)
                 {
                   sendSMSCall(voterDataItem.mobileNo.toString(), getShareTextData(), context);
                 }
                 else
                 {
                   showToast("Mobile No Not Found", context);
                 }
               },
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_sms.png',
                   width: 30,
                   height: 30,
                 ),
               ),
             )),
             Expanded(child: GestureDetector(
               onTap: () {
               },
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_printer.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             )),
             Expanded(child:  GestureDetector(
               onTap: () {
               },
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_fav_unselected.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             )),
             Expanded(child: GestureDetector(
               onTap: () {
                 if(checkValidString(voterDataItem.sectionNameEn).toString().isNotEmpty)
                 {
                   startActivity(context, FilterByValueVoterListScreen(voterDataItem.chouseNo.toString(),voterDataItem.chouseNo.toString(),"House No Wise",voterDataItem.partNameEn.toString()));
                 }
                 else
                 {
                   showToast("House No Not Found", context);
                 }

               },
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_family_wise.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             )),
             Expanded(child: GestureDetector(
               onTap: () {
                 if(checkValidString(voterDataItem.sectionNameEn).toString().isNotEmpty)
                   {
                     startActivity(context, FilterByValueVoterListScreen(voterDataItem.sectionNameEn.toString(),voterDataItem.sectionNameEn.toString(),"Address Wise",voterDataItem.partNameEn.toString()));
                   }
                 else
                 {
                   showToast("Address Not Found", context);
                 }
               },
               child: Padding(
                 padding: const EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_address_wise.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             )),
             Expanded(child: GestureDetector(
               onTap: () {
                 Navigator.pop(context);
               },
               child: Padding(
                 padding: const EdgeInsets.all(5),
                 child:  Image.asset(
                   'assets/images/ic_house_wise.png',
                   width: 28,
                   height: 28,
                 ),
               ),
             ))
           ],
         )),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: getCommonCard(),
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 5),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Image.asset('assets/images/ic_user_placeholder.png', width: 55, height: 55),
                    const Gap(10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          toDisplayCase(voterDataItem.fullNameEn.toString().trim()),
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                        ),
                        Text(
                          "${toDisplayCase(voterDataItem.gender.toString().trim())} - ${toDisplayCase(voterDataItem.age.toString().trim())}",
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  "Const No.",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                ),
                                Text(
                                  toDisplayCase(voterDataItem.acNo.toString().trim()),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  "Booth.",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                ),
                                Text(
                                  toDisplayCase(voterDataItem.partNo.toString().trim()),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  "SrNo.",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                ),
                                Text(
                                  toDisplayCase(voterDataItem.slnoinpart.toString().trim()),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                decoration: getCommonCard(),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Card No ",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  toDisplayCase(checkValidString(voterDataItem.epicNo)),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Mob No ",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if(checkValidString(voterDataItem.mobileNo).toString().isNotEmpty)
                                    {
                                      mobileNumberAction(false);
                                    }
                                    else
                                    {
                                      _showSelectionDialog(1);
                                    }
                                  },
                                  child: checkValidString(voterDataItem.mobileNo).toString().isNotEmpty
                                      ? Text(
                                          toDisplayCase(checkValidString(voterDataItem.mobileNo)),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "No Number",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "WhatsApp No ",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if(checkValidString(voterDataItem.whatsappNo).toString().isNotEmpty)
                                    {
                                      mobileNumberAction(true);
                                    }
                                    else
                                    {
                                      _showSelectionDialog(2);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: checkValidString(voterDataItem.whatsappNo).toString().isNotEmpty
                                              ? Text(
                                                  toDisplayCase(checkValidString(voterDataItem.whatsappNo)),
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                                )
                                              : Text(
                                                  "WhatsApp No",
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: darOrange,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: contentSize,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                )),
                                      Expanded(
                                          child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            voterDataItem.whatsappNo = voterDataItem.mobileNo;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          margin: const EdgeInsets.only(right: 10),
                                          child: Text(
                                            "Same As\nMobile",
                                            textAlign: TextAlign.end,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(color: darOrange, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ))
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                decoration: getCommonCard(),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Address",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "House No.",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                    ),
                                    const Gap(10),
                                    Text(
                                      toDisplayCase(checkValidString(voterDataItem.chouseNo)),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Text(
                              toDisplayCase(checkValidString(voterDataItem.sectionNameEn)) +
                                  ", " +
                                  toDisplayCase(checkValidString(voterDataItem.postoffNameEn)),
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                            )
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Booth Name",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            ),
                            Text(
                              "${toDisplayCase(checkValidString(voterDataItem.partNo.toString()))},${toDisplayCase(checkValidString(voterDataItem.partNameEn.toString()))},${toDisplayCase(checkValidString(voterDataItem.psbuildingNameEn.toString()))}",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                decoration: getCommonCard(),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Color",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (NavigationService.colorCodeList.isNotEmpty) {
                                      _selectColor();
                                    } else {
                                      showToast("List not found.", context);
                                    }
                                  },
                                  child: voterDataItem.colorCode != 0
                                      ? Text(
                                          checkValidString(getColorName()),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Select Color",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "DOB",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: checkValidString(voterDataItem.dob).toString().isNotEmpty
                                      ? Text(
                                          universalDateConverter("yyyy-MM-dd", "dd MMM, yyyy", checkValidString(voterDataItem.dob)),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Set Birthdate",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Ch Add",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(3);
                                  },
                                  child: checkValidString(voterDataItem.newAddress).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.newAddress),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Ch Add",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Aadhar Card",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(4);
                                  },
                                  child: checkValidString(voterDataItem.aadhaarNo).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.aadhaarNo),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Aadhar Card",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Email ID",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(5);
                                  },
                                  child: checkValidString(voterDataItem.email).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.email),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Email ID",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Reference Name",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(10);
                                  },
                                  child: checkValidString(voterDataItem.referenceName).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.referenceName),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Reference Name",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Blood Group",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (NavigationService.colorCodeList.isNotEmpty) {
                                      _selectBloodGroup();
                                    } else {
                                      showToast("List not found.", context);
                                    }
                                  },
                                  child: checkValidString(voterDataItem.bloodGroup).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.bloodGroup),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Select Blood Group",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Profession",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (NavigationService.professions.isNotEmpty) {
                                      _selectProfession();
                                    } else {
                                      showToast("List not found.", context);
                                    }
                                  },
                                  child: checkValidString(voterDataItem.profession).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.profession),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Select Profession",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (voterDataItem.isDead == true) {
                                voterDataItem.isDead = false;
                              } else {
                                voterDataItem.isDead = true;
                                voterDataItem.hasVoted = false;
                              }
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Dead",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                  ),
                                  const Gap(6),
                                  Image.asset(
                                    voterDataItem.isDead == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                    width: 26,
                                    height: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                        const Divider(
                          thickness: 0.5,
                          color: grayLight,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (voterDataItem.isVisited == true) {
                                voterDataItem.isVisited = false;
                              } else {
                                voterDataItem.isVisited = true;
                              }
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Visited",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                  ),
                                  const Gap(6),
                                  Image.asset(
                                    voterDataItem.isVisited == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                    width: 26,
                                    height: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                        const Divider(
                          thickness: 0.5,
                          color: grayLight,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (voterDataItem.isDead == false) {
                                if (voterDataItem.hasVoted == true) {
                                  voterDataItem.hasVoted = false;
                                } else {
                                  voterDataItem.hasVoted = true;
                                }
                              } else {
                                showToast("Dead option selected", context);
                              }
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Voted",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                  ),
                                  const Gap(6),
                                  voterDataItem.isDead == true
                                      ? Image.asset(
                                          'assets/images/ic_un_checked.png',
                                          width: 26,
                                          height: 26,
                                        )
                                      : Image.asset(
                                          voterDataItem.hasVoted == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                          width: 26,
                                          height: 26,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                decoration: getCommonCard(),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Facebook Link",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(6);
                                  },
                                  child: checkValidString(voterDataItem.facebookUrl).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.facebookUrl),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Set Link",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Instagram Link",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(7);
                                  },
                                  child: checkValidString(voterDataItem.instagramUrl).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.instagramUrl),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Set Link",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Twitter Link",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(8);
                                  },
                                  child: checkValidString(voterDataItem.twitterUrl).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.twitterUrl),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Set Link",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Other Details",
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                            )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showSelectionDialog(9);
                                  },
                                  child: checkValidString(voterDataItem.otherDetails).toString().isNotEmpty
                                      ? Text(
                                          checkValidString(voterDataItem.otherDetails),
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                        )
                                      : Text(
                                          "Enter details",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            color: darOrange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: contentSize,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                ))
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        )),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 20),
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
                if (isOnline) {
                  var list = List<Voters>.empty(growable: true);
                  list.add(voterDataItem);
                  Map<String, dynamic> jsonObjMain = <String, dynamic>{};
                  jsonObjMain[jsonEncode("workerId")] = jsonEncode(sessionManager.getId()).toString().trim();
                  jsonObjMain[jsonEncode("voters")] = jsonEncode(list).toString().trim();
                  saveVoterDetails(jsonObjMain.toString());
                } else {
                  noInterNet(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: !_isLoading
                    ? const Text(
                        "Save Voter Details",
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
    );
  }

  void _showSelectionDialog(int isFor) {
    TextEditingController commonController = TextEditingController();
    String title = "";
    if (isFor == 1) {
      title = "Mobile Number";
    } else if (isFor == 2) {
      title = "Whats-App Number";
    } else if (isFor == 3) {
      title = "Address";
    } else if (isFor == 4) {
      title = "Aadhar Card";
    } else if (isFor == 5) {
      title = "Email";
    } else if (isFor == 6) {
      title = "Facebook Link";
    } else if (isFor == 7) {
      title = "Instagram Link";
    } else if (isFor == 8) {
      title = "Twitter Link";
    } else if (isFor == 9) {
      title = "Other Details";
    } else if (isFor == 10) {
      title = "Reference Person Name";
    }

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                child: Wrap(
                  children: [
                    Column(
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
                        Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            cursorColor: black,
                            controller: commonController,
                            keyboardType: getKeyBoardType(isFor),
                            maxLength: getMaxLength(isFor),
                            style: editTextStyle(),
                            decoration: InputDecoration(
                              hintText: getHint(isFor),
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
                                setState(() {
                                  if (isFor == 1) {
                                    if (commonController.value.text.toString().trim().isEmpty) {
                                      showToast("Please enter number.", context);
                                    } else if (commonController.value.text.length != 10) {
                                      showToast("Please enter valid number", context);
                                    } else {
                                      voterDataItem.mobileNo = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 2) {
                                    if (commonController.value.text.toString().trim().isEmpty) {
                                      showToast("Please enter number.", context);
                                    } else if (commonController.value.text.length != 10) {
                                      showToast("Please enter valid number", context);
                                    } else {
                                      voterDataItem.whatsappNo = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 3) {
                                    if (commonController.value.text.toString().trim().isEmpty) {
                                      showToast("Please enter address.", context);
                                    } else {
                                      voterDataItem.newAddress = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 4) {
                                    if (commonController.value.text.toString().trim().isEmpty) {
                                      showToast("Please enter aadhar number.", context);
                                    } else if (commonController.value.text.length != 12) {
                                      showToast("Please enter valid aadhar number", context);
                                    } else {
                                      voterDataItem.aadhaarNo = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 5) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter email id", context);
                                    } else if (!isValidEmail(commonController.value.text)) {
                                      showToast("Please enter valid email id", context);
                                    } else {
                                      voterDataItem.email = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 6) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter url", context);
                                    } else if (!isValidUrl(commonController.value.text.toString().trim())) {
                                      showToast("Please enter valid url", context);
                                    } else {
                                      voterDataItem.facebookUrl = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 7) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter url", context);
                                    } else if (!isValidUrl(commonController.value.text.toString().trim())) {
                                      showToast("Please enter valid url", context);
                                    } else {
                                      voterDataItem.instagramUrl = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 8) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter url", context);
                                    } else if (!isValidUrl(commonController.value.text.toString().trim())) {
                                      showToast("Please enter valid url", context);
                                    } else {
                                      voterDataItem.twitterUrl = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 9) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter other details", context);
                                    } else {
                                      voterDataItem.otherDetails = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  } else if (isFor == 10) {
                                    if (commonController.value.text.isEmpty) {
                                      showToast("Please enter reference person name", context);
                                    } else {
                                      voterDataItem.referenceName = commonController.value.text;
                                      Navigator.pop(context);
                                    }
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6),
                                child: !_isLoading
                                    ? const Text(
                                        "Submit",
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
                  ],
                ),
              );
            }),
          );
        });
  }

  void mobileNumberAction(bool isForWhats) {
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
                    child: const Text('Make a Choice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
                    child: Row(
                      children: [
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
                                      backgroundColor: MaterialStateProperty.all<Color>(darOrange)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if(isForWhats)
                                    {
                                        _showSelectionDialog(2);
                                    }
                                    else
                                    {
                                        _showSelectionDialog(1);
                                    }
                                  },
                                  child: const Text("Update", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: white)),
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
                                  backgroundColor: MaterialStateProperty.all<Color>(darOrange)),
                              onPressed: () async {
                                Navigator.pop(context);
                                if(isForWhats)
                                {
                                 setState(() {
                                   voterDataItem.whatsappNo = "";
                                 });
                                }
                                else
                                {
                                  setState(() {
                                    voterDataItem.mobileNo = "";
                                  });
                                }
                              },
                              child: const Text("Remove", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: white)),
                            ),
                          ),
                        ),
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
                                  backgroundColor: MaterialStateProperty.all<Color>(darOrange)),
                              onPressed: () async {
                                Navigator.pop(context);
                                if(isForWhats)
                                {
                                  makePhoneCall(voterDataItem.whatsappNo.toString());
                                }
                                else
                                {
                                  makePhoneCall(voterDataItem.mobileNo.toString());
                                }
                              },
                              child: const Text("Make a Call", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: white)),
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

  void _selectBloodGroup() {
    String title = "Select Blood Group";

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: Wrap(
                children: [
                  Column(
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
                      ListView.builder(
                          itemCount: NavigationService.bloodGroupList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (NavigationService.bloodGroupList[index] != voterDataItem.bloodGroup) {
                                  setState(() {
                                    voterDataItem.bloodGroup = checkValidString(NavigationService.bloodGroupList[index]);
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      checkValidString(NavigationService.bloodGroupList[index]),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: NavigationService.bloodGroupList[index] != voterDataItem.bloodGroup ? black : darOrange),
                                    ),
                                  ),
                                  Container(height: 0.5, color: grayLight)
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  void _selectProfession() {
    String title = "Select Profession";

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: Wrap(
                children: [
                  Column(
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
                      ListView.builder(
                          itemCount: NavigationService.professions.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (NavigationService.professions[index].professionNameEn != voterDataItem.partNameEn) {
                                  setState(() {
                                    voterDataItem.profession = checkValidString(NavigationService.professions[index].professionNameEn);
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          checkValidString(NavigationService.professions[index].professionNameEn),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: NavigationService.professions[index].professionNameEn != voterDataItem.profession
                                                  ? black
                                                  : darOrange),
                                        ),
                                        Visibility(
                                          visible: NavigationService.professions[index].professionNameV1 != null &&
                                              NavigationService.professions[index].professionNameV1!.isNotEmpty,
                                          child: Text(
                                            " - " + checkValidString(NavigationService.professions[index].professionNameV1),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: NavigationService.professions[index].professionNameEn != voterDataItem.profession
                                                    ? black
                                                    : darOrange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 0.5, color: grayLight)
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  void _selectColor() {
    String title = "Select Color";

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStatenew) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
              child: Wrap(
                children: [
                  Column(
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
                      ListView.builder(
                          itemCount: NavigationService.colorCodeList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (NavigationService.colorCodeList[index].colorCode != voterDataItem.colorCode) {
                                  setState(() {
                                    voterDataItem.colorCode = NavigationService.colorCodeList[index].colorCode;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          checkValidString(NavigationService.colorCodeList[index].colorNameEn),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  NavigationService.colorCodeList[index].colorCode != voterDataItem.colorCode ? black : darOrange),
                                        ),
                                        Visibility(
                                          visible: NavigationService.colorCodeList[index].colorNameV1 != null &&
                                              NavigationService.colorCodeList[index].colorNameV1!.isNotEmpty,
                                          child: Text(
                                            " - " + checkValidString(NavigationService.colorCodeList[index].colorNameV1),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    NavigationService.colorCodeList[index].colorCode != voterDataItem.colorCode ? black : darOrange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 0.5, color: grayLight)
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(seconds: 1)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
      builder: (context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(backgroundColor: black, iconTheme: Theme.of(context).appBarTheme.iconTheme?.copyWith(color: white)),
            scaffoldBackgroundColor: white,
            colorScheme: const ColorScheme.light(onPrimary: white, primary: black)),
        child: child!,
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        voterDataItem.dob = formattedDate;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget is VoterDetailsPage;
  }

  getKeyBoardType(int isFor) {
    if (isFor == 1) {
      return TextInputType.number;
    } else if (isFor == 2) {
      return TextInputType.number;
    } else if (isFor == 3) {
      return TextInputType.text;
    } else if (isFor == 4) {
      return TextInputType.number;
    } else if (isFor == 5) {
      return TextInputType.emailAddress;
    } else if (isFor == 6) {
      return TextInputType.url;
    } else if (isFor == 7) {
      return TextInputType.url;
    } else if (isFor == 8) {
      return TextInputType.url;
    } else {
      return TextInputType.text;
    }
  }

  getMaxLength(int isFor) {
    if (isFor == 1) {
      return 10;
    } else if (isFor == 2) {
      return 10;
    } else if (isFor == 3) {
      return null;
    } else if (isFor == 4) {
      return null;
    } else if (isFor == 5) {
      return null;
    } else if (isFor == 6) {
      return null;
    } else if (isFor == 7) {
      return null;
    } else if (isFor == 8) {
      return null;
    } else {
      return null;
    }
  }

  getHint(int isFor) {
    String title = "";
    if (isFor == 1) {
      title = "Enter Mobile Number";
    } else if (isFor == 2) {
      title = "Enter Whats-App Number";
    } else if (isFor == 3) {
      title = "Enter Address";
    } else if (isFor == 4) {
      title = "Enter Aadhar Number";
    } else if (isFor == 5) {
      title = "Enter EmailAddress";
    } else if (isFor == 6) {
      title = "Enter Facebook Link";
    } else if (isFor == 7) {
      title = "Enter Instagram Link";
    } else if (isFor == 8) {
      title = "Enter Twitter Link";
    } else if (isFor == 9) {
      title = "Enter Other Details";
    } else if (isFor == 10) {
      title = "Reference Person Name";
    }
    return title;
  }

  Future<void> getDataFromDB() async {
    if (voterDataItem.id != null) {
      Voters item = await dbHelper.getVotersWithId(voterDataItem.id!.toInt());
      setState(() {
        if (item.id != null) {
          voterDataItem = item;
        }
      });
    }
  }

  //API Call func...
  void saveVoterDetails(String jsonData) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    var url = Uri.parse("$API_URL${sessionManager.getAcNo().toString().trim()}/voter");
    Map<String, String> jsonBody = {'token': Token, 'voters': jsonData};

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = BasicResponseModel.fromJson(user);

    if (checkValidString(dataResponse.message.toString().trim()) == "Success") {
      try {
        dbHelper.updateVoter(voterDataItem);
        showToast("Voter Details Saved Successfully", context);
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    } else if (checkValidString(dataResponse.message.toString().trim()) == "Worker Access Denied" ||
        checkValidString(dataResponse.message.toString().trim()) == "Worker Not Found") {
      showSnackBarLong("You are not allow to access the application.", context);
      dbHelper.deleteAllTableData();
      Navigator.pop(context);
      SessionManagerNew.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      apiFailed(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  String getColorName() {
    String colorName = "";
    for (int i = 0; i < NavigationService.colorCodeList.length; i++)
    {
      if (voterDataItem.colorCode == NavigationService.colorCodeList[i].colorCode)
      {
        if (checkValidString(NavigationService.colorCodeList[i].colorNameEn).toString().trim().isNotEmpty &&
            checkValidString(NavigationService.colorCodeList[i].colorNameV1).toString().trim().isNotEmpty)
        {
          colorName = NavigationService.colorCodeList[i].colorNameEn.toString() + " - " + NavigationService.colorCodeList[i].colorNameV1.toString();
        } else if (checkValidString(NavigationService.colorCodeList[i].colorNameEn).toString().trim().isNotEmpty){
          colorName = NavigationService.colorCodeList[i].colorNameEn.toString();
        }
        else
        {
            colorName = "";
        }
      }
    }
    return colorName;
  }

  String getShareTextData() {
    String shareText = "";
    shareText = voterDataItem.acNo.toString() + " ";
    if (NavigationService.statisticsData.isNotEmpty)
    {
      for (int i = 0; i < NavigationService.statisticsData.length; i++)
      {
        if (NavigationService.statisticsData[i].name == "ac_name")
        {
          shareText = shareText + "" + NavigationService.statisticsData[i].value.toString().trim();
        }
      }
      shareText = "$shareText General Election 2023\n";
    }

    shareText = shareText + "SrNo-" + voterDataItem.slnoinpart.toString() + "\n";
    shareText = shareText + "Const No-" + voterDataItem.acNo.toString() + "\n\n";
    shareText = shareText + "Name-" + voterDataItem.fullNameEn.toString() + "\n";
    shareText = shareText + "Booth No-" + voterDataItem.partNo.toString() + "\n";
    shareText = shareText + "Booth Name-" + "${toDisplayCase(checkValidString(voterDataItem.partNo.toString()))},${toDisplayCase(checkValidString(voterDataItem.partNameEn.toString()))},${toDisplayCase(checkValidString(voterDataItem.psbuildingNameEn.toString()))}" + "\n";
    shareText = shareText + "Address-" + toDisplayCase(checkValidString(voterDataItem.sectionNameEn)) + ", " + toDisplayCase(checkValidString(voterDataItem.postoffNameEn)) + "\n\n\n";
    shareText = shareText + "From-Congress Party";
    return shareText;
  }
}
