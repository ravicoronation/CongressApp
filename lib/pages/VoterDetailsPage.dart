import 'package:congress_app/pages/login_screen.dart';
import 'package:congress_app/utils/session_manager_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constant/colors.dart';
import '../local_storage/db_helper.dart';
import '../model/VoterListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';
import '../utils/loading_home.dart';

class VoterDetailsPage extends StatefulWidget {
  Voters voterDataItem;

  VoterDetailsPage(this.voterDataItem, {Key? key}) : super(key: key);

  @override
  _VoterDetailsPage createState() => _VoterDetailsPage();
}

class _VoterDetailsPage extends BaseState<VoterDetailsPage> {
  bool _isLoading = false;
  Voters voterDataItem = Voters();
  final dbHelper = DbHelper.instance;

  @override
  void initState() {
    voterDataItem = (widget as VoterDetailsPage).voterDataItem;
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
        Expanded(child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
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
                        padding: EdgeInsets.all(10),
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
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                            "Same As\nMobile",
                                            textAlign: TextAlign.end,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(color: darOrange, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                          ),
                                        )),
                                  ],
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
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                  "Referance Name",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: contentSizeSmall),
                                )),
                            Expanded(
                                flex: 2,
                                child: checkValidString(voterDataItem.referenceName).toString().isNotEmpty
                                    ? Text(
                                  checkValidString(voterDataItem.referenceName),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                                )
                                    : Text(
                                  "Referance Name",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: darOrange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: contentSize,
                                    decoration: TextDecoration.underline,
                                  ),
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Dead",
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                              ),
                              Gap(6),
                              Image.asset(
                                voterDataItem.isDead == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                width: 26,
                                height: 26,
                              )
                            ],
                          ),
                        )),
                        const Divider(
                          thickness: 0.5,
                          color: grayLight,
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Visited",
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                              ),
                              Gap(6),
                              Image.asset(
                                voterDataItem.isVisited == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                width: 26,
                                height: 26,
                              )
                            ],
                          ),
                        )),
                        const Divider(
                          thickness: 0.5,
                          color: grayLight,
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Voted",
                                overflow: TextOverflow.clip,
                                style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: contentSize),
                              ),
                              Gap(6),
                              Image.asset(
                                voterDataItem.hasVoted == true ? 'assets/images/ic_checked.png' : 'assets/images/ic_un_checked.png',
                                width: 26,
                                height: 26,
                              )
                            ],
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
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
                                ))
                          ],
                        )),
                    const Divider(
                      height: 0.5,
                      color: grayLight,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
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
          margin: const EdgeInsets.only(top: 10, left: 8, right: 8,bottom: 20),
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
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: ! _isLoading
                    ? const Text("Save Voter Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w400),
                ) : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle,
                                border: Border.all(color: black, width: 1,)),
                            child: const Padding(padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(color: white, strokeWidth: 2),
                            ))),
                    const Text("   Please wait..",
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


  @override
  void castStatefulWidget() {}
}
