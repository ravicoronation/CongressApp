import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constant/colors.dart';

class LoadingHomeWidget extends StatelessWidget {
  const LoadingHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBg,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/loader.json',width: 80,height: 80),
          const Text("Please wait we are fetching voters data..",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
