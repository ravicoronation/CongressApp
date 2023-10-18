import 'package:flutter/material.dart';

import '../constant/colors.dart';

Widget getBackArrow(BuildContext? context){
  return GestureDetector(
    onTap: (){
      Navigator.pop(context!);
    },
    child: Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 10,top: 10,bottom: 10),
        child: Image.asset('assets/images/ic_arrow_left.png', width: 22, height: 22),
      ),
    ),
  );
}

Widget getTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w800),
  );
}

screenPadding() => const EdgeInsets.fromLTRB(16, 12, 16, 12);