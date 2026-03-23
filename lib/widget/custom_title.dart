import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/widget/button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Widget titlebar({
  required String title,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: BlackColor,
            fontFamily: FontFamily.gilroyExtraBold,
            fontSize: 20,
          ),
        ),
      ),
    ],
  );
}

Future<void> makingPhoneCall(context,{required String number}) async {
  await Permission.phone.request();
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
  }
  if (status.isGranted) {
    var url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  } else if (status.isPermanentlyDenied) {
    snackBar(context: context, text: "Please allow calls Permission".tr);
    await openAppSettings();
  } else {
    snackBar(context: context, text: "Please allow calls Permission".tr);
    await openAppSettings();
  }
}

billSummaryTextDetaile({
  required String title,
  required String subtitle,
  String? image,
}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
            color: greytext,
          ),
        ),
        Flexible(
          child: Text(
            "$subtitle ",
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        if(image != null)...[
          Image.asset(
            image,
            color: Colors.grey,
            height: 14,
          ),
        ],
      ],
    );
  }


billSummaryTextCart({required String title, required String subtitle, String? fontFamily,String? image,}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: fontFamily ?? FontFamily.gilroyMedium,
            fontSize: 15,
          ),
        ),
        if(image != null)...[
          SizedBox(width: 7),
          Image.asset(
            image,
            color: textcolor,
            height: 14,
          ),
        ],
        Spacer(),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

    String getImageExtention(String input) {
    if (input.length < 4) {
      return input;
    }
    return input.substring(input.length - 4);
  }
