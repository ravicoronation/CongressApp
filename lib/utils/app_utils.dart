import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:congress_app/utils/session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';


/*show message to user*/
showSnackBar(String? message, BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: black,
        content: Text(message!, style: const TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w400)),
        duration: const Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

showSnackBarLong(String? message, BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 3),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getPrice(String text) {
  if (text.isNotEmpty) {
    try {
      var formatter = NumberFormat('#,##,###');
      return "₹ ${formatter.format(double.parse(text))}";
    } catch (e) {
      return "₹ $text";
    }
  } else {
    return "₹ $text";
  }
}


getCommonCard() {
  return BoxDecoration(
    color: white,
   // borderRadius: BorderRadius.circular(kButtonCornerRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), //color of shadow
        spreadRadius: 4, //spread radius
        blurRadius: 9, // blur radius
        offset: const Offset(0, 2), // changes position of shadow
        //first paramerter of offset is left-right
        //second parameter is top to down
      )
    ],
  );
}

getCommonCardBasic() {
  return BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(kButtonCornerRadius),
  );
}

getCommonCardBasicBottom() {
  return const BoxDecoration(
    color: darOrange,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
  );
}

getCommonCardBasicNew() {
  return BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(kButtonCornerRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), //color of shadow
        spreadRadius: 3, //spread radius
        blurRadius: 6, // blur radius
        offset: const Offset(0, 2), // changes position of shadow
        //first paramerter of offset is left-right
        //second parameter is top to down
      )
    ],
  );
}

extension StringCasingExtensionNew on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension DateTimeExtensionForWeek on DateTime {
  DateTime next(int day, bool isForWeek) {
    if (isForWeek) {
      if (day == weekday) {
        return add(const Duration(days: 7));
      } else {
        return add(
          Duration(
            days: (day - weekday) % DateTime.daysPerWeek,
          ),
        );
      }
    } else {
      return add(Duration(days: day));
    }
  }

  DateTime previous(int day) {
    return subtract(Duration(days: day));
  }
}

editTextStyle() {
  return TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: textFiledSize);
}

editTextStyleSmall() {
  return TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: contentSize);
}

getClickableIcons(String icon, Color color) {
  return SizedBox(
    width: 48,
    height: 48,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Image.asset(icon, width: 16, height: 16, color: color),
    ),
  );
}

getCommonMarginCard() {
  return const EdgeInsets.fromLTRB(24, 18, 24, 0);
}

getCommonMarginCardBasic() {
  return const EdgeInsets.fromLTRB(2, 12, 2, 12);
}

getCommonMarginCardNew() {
  return const EdgeInsets.fromLTRB(24, 9, 24, 9);
}

getCommonMarginCardInnerList() {
  return const EdgeInsets.fromLTRB(10, 9, 10, 9);
}

getFormatedNumber(int numberToFormat) {
  var _formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
  ).format(numberToFormat);

  print('Formatted Number is: $_formattedNumber');

  return _formattedNumber;
}

noInterNet(BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Please check your internet connection!"),
        duration: Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}


apiFailed(BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Something is not right from API, Please try again!"),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getInitials({required String string, required int limitTo}) {
  var buffer = StringBuffer();
  var split = string.split(' ');
  for (var i = 0; i < (limitTo ?? split.length); i++) {
    buffer.write(split[i][0]);
  }

  return buffer.toString();
}

String getSortName(String text) {
  String sortname = "";

  if (checkValidString(text).toString().isNotEmpty) {
    var splited = text.split(" ");
    if (splited.isNotEmpty) {
      if (splited.length == 1) {
        var temp = splited[0].toString();
        sortname = temp[0];
      } else {
        var temp1 = splited[0].toString();
        var temp2 = splited[1].toString();
        sortname = temp1[0] + temp2[0];
      }
    }
  }
  return sortname.toUpperCase();
}

/*check email validation*/
bool isValidEmail(String? input) {
  try {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

bool isValidUrl(String? input) {
  bool isValid = false;
  try
  {
      if(validator.url(input.toString()))
      {
        isValid = true;
      }
      return isValid;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return isValid;
  }
}

textFieldPadding(TextEditingController controller) {
  return EdgeInsets.fromLTRB(6, controller.value.text.isEmpty ? 6 : 12, 6, controller.value.text.isEmpty ? 8 : 0);
}

textFieldPaddingForDialog(TextEditingController controller) {
  return EdgeInsets.fromLTRB(10, controller.value.text.isEmpty ? 10 : 10, 10, controller.value.text.isEmpty ? 10 : 0);
}

textFieldPaddingNew(TextEditingController controller) {
  return EdgeInsets.fromLTRB(6, controller.value.text.isEmpty ? 6 : 10, 6, controller.value.text.isEmpty ? 4 : 0);
}

String convertToAgo(String dateTime) {
  if (dateTime != null) {
    if (dateTime.isNotEmpty) {
      DateTime input = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime, false);
      Duration diff = DateTime.now().difference(input);
      if (diff.inDays >= 1) {
        return universalDateConverter("yyyy-MM-dd HH:mm:ss", "MMM dd", dateTime);
      } else if (diff.inHours >= 1) {
        return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
      } else if (diff.inSeconds >= 1) {
        return '${diff.inSeconds} sec${diff.inSeconds == 1 ? '' : 's'} ago';
      } else {
        return 'just now';
      }
    } else {
      return '';
    }
  } else {
    return '';
  }
}

String toDisplayCase(String value) {
  if (value.isNotEmpty) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else if (value[i - 1] == "  ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  } else {
    return "";
  }
}

showToast(String? message, BuildContext? context) {
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: black,
      textColor: white,
      fontSize: 16.0);
}

startActivity(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

closeAndStartActivity(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);
}

convertCommaSeparatedAmount(String value) {
  try {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(value);
  } catch (e) {
    return value;
  }
}

/*generate hex color into material color*/
MaterialColor createMaterialColor(Color color) {
  try {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return const MaterialColor(0xFFFFFFFF, <int, Color>{});
  }
}

Future<void> shareFileWithText(String text, String filePath) async {
  try {
    Share.shareFiles([filePath], text: text);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<void> setOrientation(List<DeviceOrientation> orientations) async {
  SystemChrome.setPreferredOrientations(orientations);
}

checkValidString(String? value) {
  if (value == null || value == "null" || value == "<null>") {
    value = "";
  } else if (value.isEmpty) {
    value = "";
  }

  return value.trim();
}

checkValidStringNew(String? value) {
  if (value == null || value == "null" || value == "<null>") {
    value = "";
  }
  return value.trim();
}

checkValidStringWithToDisplayCase(String? value) {
  if (value == null || value == "null" || value == "<null>") {
    value = "";
  } else if (value.isEmpty) {
    value = "--";
  }

  if (value.isEmpty || value == "--") {
    return value.trim();
  } else {
    return toDisplayCase(value.trim());
  }
}

checkValidStringWithToDisplayCaseNew(String? value) {
  if (value == null || value == "null" || value == "<null>") {
    value = "";
  } else if (value.isEmpty) {
    value = "";
  }

  if (value.isEmpty) {
    return value.trim();
  } else {
    return toDisplayCase(value.trim());
  }
}

String getDateFromTimeStamp(int timeStamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch((timeStamp * 1000).toInt());
  var formatedDate = DateFormat('dd/MM/yyyy').format(dt);
  return formatedDate;
}

String base64Encode(String value) {
  return base64.encode(utf8.encode(value));
}

String getTimeStampDate(String value, String dateFormat) {
  int timestamp = 0;
  if (value.isNotEmpty) {
    DateTime datetime = DateFormat(dateFormat).parse(value);
    timestamp = datetime.millisecondsSinceEpoch ~/ 1000;
  }

  return timestamp.toString();
}

String getBirthDate(String bDate) {
  String dateValue = "";

  try {
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(int.parse(bDate) * 1000);
    String startDateFormat = DateFormat('dd MMM yyyy').format(date1);
    dateValue = startDateFormat;
  } catch (e) {
    print(e);
  }
  return dateValue;
}

String universalDateConverter(String inputDateFormat, String outputDateFormat, String date) {
  var inputFormat = DateFormat(inputDateFormat);
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format
  var outputFormat = DateFormat(outputDateFormat);
  var outputDate = outputFormat.format(inputDate);
  print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
  return outputDate;
}

openMail(String email) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: email,
  );
  var url = params.toString();
  await launch(url);
}



openWhatsApp(String conatctNo, BuildContext? context) async {
  FocusManager.instance.primaryFocus?.unfocus();
  var whatsappUrl = "whatsapp://send?phone=${conatctNo}" + "&text=${Uri.encodeComponent("")}";
  try {
    launchUrl(Uri.parse(whatsappUrl));
  } catch (e) {
    //To handle error and display error message
    showSnackBar("Unable to open whatsapp", context);
  }
}

makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}


whatsapp(String conatctNo,String text,BuildContext? context)
async{
  final bytes = await rootBundle.load(isLanguageEnglish() ? 'assets/images/ic_share_en.jpeg' : 'assets/images/ic_share_te.jpeg');
  final list = bytes.buffer.asUint8List();
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/image.jpeg').create();
  file.writeAsBytesSync(list);
  var xfile  = XFile(file.path);
  shareWhatsapp.share(text: text, file: xfile,phone: conatctNo);

  /* await WhatsappShare.shareFile(
      filePath: [file.path],
      phone: conatctNo,
      text: "er"
  );*/

 /* await WhatsappShare.share(
    text: text,
    phone: conatctNo,
  );*/

 /* final bytes = await rootBundle.load('assets/images/ic_logo.jpg');
  final list = bytes.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/image.jpg').create();
  file.writeAsBytesSync(list);

  await WhatsappShare.shareFile(
    text: text,
    phone: conatctNo,
    filePath: [file.path]
  );*/

  /*var phoneNumber = conatctNo;
  var fileUrl = "https://imasfoundation.org/wp-content/uploads/2020/03/favicon.png"; // Replace with the URL of the file you want to send
  var url = "whatsapp://send?phone=${phoneNumber}" +
      "&text=${Uri.encodeComponent(text)}&file=${list}";

  await launchUrl(Uri.parse(url));*/

  /*
    final bytes = await rootBundle.load('assets/images/ic_logo.jpg');
  final list = bytes.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/image.jpg').create();
  file.writeAsBytesSync(list);*/

 /**/


  /*var androidUrl =
      "whatsapp://send?phone=${conatctNo}" +
          "&text=${Uri.encodeComponent(text)}&file=${file.path}";

  await WhatsappShare.shareFile(
    text: Uri.encodeComponent(text),
    phone: conatctNo,
    filePath: [file.path],
  );

  print(conatctNo);
  var conatctNoNew = conatctNo.replaceAll(" ", "");
  var iosUrl =
      "https://wa.me/$conatctNoNew?text=${Uri.parse('')}";

  try{
    if(Platform.isIOS){
      await launchUrl(Uri.parse(iosUrl));
    }
    else{
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception{
  }*/
}

getRandomOTP () {
  try {
    var r = Random();
    const _chars = '1234567890';
    return List.generate(4, (index) => _chars[r.nextInt(_chars.length)]).join();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

getAcNoWithOutZero()
{
  var sessionManager = SessionManager();
  String temp = sessionManager.getAcNo().toString().replaceAll("ac", "");
  String acNo = temp.replaceFirst(RegExp(r'^0+(?!$)'), "");
  return acNo;
}

isLanguageEnglish()
{
  var sessionManager = SessionManager();
  if(sessionManager.isLanguageEnglish() == true)
    {
      return true;
    }
  else
    {
      return false;
    }
}

getCodeNameFromId(num? code)
{
  if(code !=null)
    {
      for (int i = 0; i < NavigationService.colorCodeList.length; i++)
      {
        if (code == NavigationService.colorCodeList[i].colorCode)
        {
          return NavigationService.colorCodeList[i].colorCodeHEX;
        }
      }
    }
  else
    {
      return "#ffebf0f4";
    }
}

sendSMSCall(String conatctNo,String text,BuildContext? context)
async{
  String uri = 'sms:${conatctNo}?body=${text}';
  if (await canLaunchUrl(Uri.parse(uri))) {
    await launchUrl(Uri.parse(uri));
  } else {
    throw 'Could not launch $uri';
  }
}


