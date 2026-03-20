import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/utils/custom_colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({required context,required String text}){
  return  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text,style: const TextStyle(
      fontFamily: "Gilroy Bold",
      fontSize: 14,
    ),),backgroundColor: primeryColor,behavior: SnackBarBehavior.floating,elevation: 0, duration: const Duration(seconds: 3),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
  );
}

showToastMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: BlackColor,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

Future<void> initPlatformState() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Config.oneSignel);
  OneSignal.Notifications.requestPermission(true).then((value) {
    debugPrint("Signal value:- $value");
  },);
}
