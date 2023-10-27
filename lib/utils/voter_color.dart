import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constant/colors.dart';
import 'app_utils.dart';

class VoterColorWidget extends StatelessWidget {
  final num? colorCode;

  const VoterColorWidget({Key? key, required this.colorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: Color(int.parse(getCodeNameFromId(colorCode).toString().replaceAll('#', '0x'))),
          borderRadius: BorderRadius.circular(kButtonCornerRadius),
        ));
  }
}
