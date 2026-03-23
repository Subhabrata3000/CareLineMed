// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/font_family_model.dart';
import 'package:get/get.dart';


Widget button({
  required String text,
  required Color color,
  void Function()? onPress,
  double? height,
  BorderRadius? borderRadius,
}) {
  return SizedBox(
    height: height ?? 50,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(color),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: FontFamily.gilroyBold,
          color: Color(0xffFFFFFF),
          // letterSpacing: 0.4,
        ),
      ),
    ),
  );
}
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({required context, required String text}){
  return  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text,style: TextStyle(
        fontFamily: FontFamily.gilroyBold,
        fontSize: 14,
        color: WhiteColor
    ),),backgroundColor: BlackColor,behavior: SnackBarBehavior.floating,elevation: 0, duration: const Duration(seconds: 6),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
  );
}


textfield({
  String? type,
  String? type2,
  labelText,
  prefixtext,
  suffix,
  Color? labelcolor,
  prefixcolor,
  floatingLabelColor,
  focusedBorderColor,
  TextDecoration? decoration,
  bool? readOnly,
  double? Width,
  int? max,
  TextEditingController? controller,
  TextInputType? textInputType,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  Height,
}) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              type ?? "",
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async{
                const url = "https://fontawesome.com/v4/icons/";
                if(await canLaunch(url)){
                  await launch(url);
                }
              },
              child: Tooltip(
                message: "fa fa-address-book",
                child: Text(
                  type2 ?? "",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 16,
                    color: primeryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          height: Height,
          width: Width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: WhiteColor),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            cursorColor: BlackColor,
            keyboardType: textInputType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: max,
            readOnly: readOnly ?? false,
            inputFormatters: inputFormatters,
            style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 18),
            decoration: InputDecoration(
              suffixIcon: suffix,
              hintText: labelText,

              hintStyle: TextStyle(
                  color: Colors.grey, fontFamily: "Gilroy Medium", fontSize: 16),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primeryColor),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  },);
}

textfield2({String? type, String? type2, labelText, prefixtext, suffix, Color? labelcolor, prefixcolor, floatingLabelColor, focusedBorderColor, TextDecoration? decoration, bool? readOnly, double? Width, int? max, TextEditingController? controller, TextInputType? textInputType, Function(String)? onChanged, String? Function(String?)? validator, List<TextInputFormatter>? inputFormatters, Height}) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              type ?? "",
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async{
                const url = "https://fontawesome.com/v4/icons/";
                if(await canLaunch(url)){
                  await launch(url);
                }
              },
              child: Tooltip(
                message: "fa fa-address-book",
                child: Text(
                  type2 ?? "",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 16,
                    color: primeryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          height: Height,
          width: Width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: WhiteColor),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            cursorColor: BlackColor,
            keyboardType: textInputType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: max,
            readOnly: readOnly ?? false,
            inputFormatters: inputFormatters,
            style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 18),
            decoration: InputDecoration(
              suffixIcon: suffix,
              hintText: labelText,
              hintStyle: TextStyle(
                  color: Colors.grey, fontFamily: "Gilroy Medium", fontSize: 16),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  },);
}


Widget buttonWhite({required String text, required Color color, void Function()? onPress}) {
  return SizedBox(
    height: 45,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(color),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.gilroyBold,
          color: gradient.defoultColor,
          // letterSpacing: 0.4,
        ),
      ),
    ),
  );
}

Widget buttonGrey({required String text, required Color color, void Function()? onPress}) {
  return SizedBox(
    height: 45,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(color),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.gilroyBold,
          color: greycolor,
        ),
      ),
    ),
  );
}

Widget loaderButton({BorderRadius? borderRadius}){
  return SizedBox(
    height: 45,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(gradient.defoultColor.withOpacity(0.15)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
        ),
      ),
      onPressed: (){},
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: gradient.defoultColor,
        size: 25,
      ),
    ),
  );
}
