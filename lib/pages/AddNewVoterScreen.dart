import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/common_widget.dart';

class AddNewVoterScreen extends StatefulWidget {
  const AddNewVoterScreen({Key? key}) : super(key: key);

  _AddNewVoterScreen createState() => _AddNewVoterScreen();
}

class _AddNewVoterScreen extends BaseState<AddNewVoterScreen> {

  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharCardController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referanceNameController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController twitterController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            automaticallyImplyLeading: false,
            backgroundColor: appBg,
            elevation: 3,
            titleSpacing: 12,
            centerTitle: false,
            leading: Image.asset(
              'assets/images/ic_logo.jpg',
              width: 42,
              height: 42,
            ),
            title: getTitle("Congress Party"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(16),
                        TextField(
                          cursorColor: black,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: genderController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          readOnly: true,
                          onTap: () {
                            _selectGender();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Gender',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Age',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: mobNoController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          maxLength: 10,
                          decoration: const InputDecoration(
                            hintText: 'Mob No',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: whatsAppController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'WhatsApp No',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Address',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: houseNoController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'House No',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: dobController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Birthdate',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: aadharCardController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Aadhar Card',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'E-Mail Id',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: referanceNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Reference Name',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: bloodGroupController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          readOnly: true,
                          onTap: () {
                            _selectBloodGroup();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Blood Group',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: professionController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          readOnly: true,
                          onTap: () {
                            _selectProfession();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Profession',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: facebookController,
                          keyboardType: TextInputType.url,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Facebook Link',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: instagramController,
                          keyboardType: TextInputType.url,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Instagram Link',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          cursorColor: black,
                          controller: twitterController,
                          keyboardType: TextInputType.url,
                          textCapitalization: TextCapitalization.words,
                          style: editTextStyle(),
                          decoration: const InputDecoration(
                            hintText: 'Twitter Link',
                            counterText: '',
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8,bottom: 32),
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
                      if (nameController.value.text.isEmpty)
                        {
                          showToast("Please enter name", context);
                        }
                      else if (genderController.value.text.isEmpty)
                        {
                          showToast("Please select gender", context);
                        }
                      else if (ageController.value.text.isEmpty)
                        {
                          showToast("Please enter age", context);
                        }
                      else if (mobNoController.value.text.isEmpty)
                        {
                          showToast("Please enter mobile number", context);
                        }
                      else if (mobNoController.value.text.length != 10)
                        {
                          showToast("Please enter valid number", context);
                        }
                      else if (whatsAppController.value.text.isEmpty)
                      {
                        showToast("Please enter whatsapp number", context);
                      }
                      else if (whatsAppController.value.text.length != 10)
                      {
                        showToast("Please enter valid whatsapp number", context);
                      }
                      else if (addressController.value.text.isEmpty)
                        {
                          showToast("Please enter address", context);
                        }
                      else if (houseNoController.value.text.isEmpty)
                      {
                        showToast("Please enter house no", context);
                      }
                      else if (dobController.value.text.isEmpty)
                        {
                          showToast("Please enter birthdate", context);
                        }
                      else if (aadharCardController.value.text.isEmpty)
                        {
                          showToast("Please enter aadharcard number", context);
                        }
                      else if (aadharCardController.value.text.length != 12)
                        {
                          showToast("Please enter valid aadharcard number", context);
                        }
                      else if (emailController.value.text.isEmpty)
                        {
                          showToast("Please enter email address", context);
                        }
                      else if (!isValidEmail(emailController.value.text))
                        {
                          showToast("Please enter email id", context);
                        }
                      else if (referanceNameController.value.text.isEmpty)
                        {
                          showToast("Please enter reference name", context);
                        }
                      else if (bloodGroupController.value.text.isEmpty)
                        {
                          showToast("Please select blood group", context);
                        }
                      else if (professionController.value.text.isEmpty)
                        {
                          showToast("Please select profession", context);
                        }
                      else
                        {
                          //Save
                        }


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: ! _isLoading
                          ? const Text("Submit",
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
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
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
                                if (NavigationService.bloodGroupList[index] != bloodGroupController.value.text) {
                                  setState(() {
                                    bloodGroupController.text = checkValidString(NavigationService.bloodGroupList[index]);
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
                                          color: NavigationService.bloodGroupList[index] != bloodGroupController.value.text ? black : darOrange),
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
                                if (NavigationService.professions[index].professionNameEn != professionController.value.text) {
                                  setState(() {
                                    professionController.text = checkValidString(NavigationService.professions[index].professionNameEn);
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
                                              color: NavigationService.professions[index].professionNameEn != professionController.value.text
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
                                                color: NavigationService.professions[index].professionNameEn != professionController.value.text
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

  void _selectGender() {
    String title = "Select Gender";

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
                          itemCount: NavigationService.genderList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (NavigationService.genderList[index] != genderController.value.text) {
                                  setState(() {
                                    genderController.text = checkValidString(NavigationService.genderList[index]);
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
                                          checkValidString(NavigationService.genderList[index]),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: NavigationService.genderList[index] != genderController.value.text
                                                  ? black
                                                  : darOrange),
                                        ),
                                        Visibility(
                                          visible: NavigationService.genderList[index] != null &&
                                              NavigationService.genderList[index].isNotEmpty,
                                          child: Text(
                                            " - " + checkValidString(NavigationService.genderList[index]),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: NavigationService.genderList[index] != genderController.value.text
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
        dobController.text = formattedDate;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget is AddNewVoterScreen;
  }
}