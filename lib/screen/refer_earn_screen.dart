// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/refer_earn_controller.dart';
import 'package:carelinemed/utils/customwidget.dart';
import 'package:carelinemed/widget/button.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:share_plus/share_plus.dart';
import '../model/font_family_model.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getPackage();
    fun();
  }

  String currency = "";

  fun() async {
    currency = getData.read("currency");
    referCodeController.referCodeApi();
    setState(() {});
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  ReferCodeController referCodeController = Get.put(ReferCodeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: bgcolor,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(12),
        child: button(
          text: "Refer a Friend".tr,
          color: primeryColor,
          borderRadius: BorderRadius.circular(15),
          onPress: () async {
            await share();
          },
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Refer a Friend".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
      ),
      body: GetBuilder<ReferCodeController>(
        builder: (referCodeController) {
          return referCodeController.isLoading
              ? Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Lottie.asset(
                      "assets/lotties/referandearn.json",
                      height: 240,
                    ),
                    SizedBox(
                      width: Get.width / 2,
                      child: Text(
                        "${"Earn".tr} $currency${referCodeController.referEarnModel!.fererralData!.signupCredit} ${"for Each Friend you refer".tr}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: FontFamily.gilroyBold,
                          color: BlackColor,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(text: "Share the referral link with your friends".tr),
                          SizedBox(height: 15),
                          customText(text: "${"Friend get".tr} $currency${referCodeController.referEarnModel!.fererralData!.referCredit} ${"on their first complete transaction".tr}"),
                          SizedBox(height: 15),
                          customText(text: "${"You get".tr} $currency${referCodeController.referEarnModel!.fererralData!.signupCredit} ${"on your wallet".tr}"),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: Get.size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 30),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "${referCodeController.referEarnModel!.fererralData!.referralCode}",
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: "${referCodeController.referEarnModel!.fererralData!.referralCode}",
                                ),
                              );
                              showToastMessage("Copy".tr);
                            },
                            child: Image.asset(
                              "assets/copy.png",
                              height: 20,
                              width: 20,
                              color: gradient.defoultColor,
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Center(child:CircularProgressIndicator(color: gradient.defoultColor));
        },
      ),
    );
  }

  customText({required String text}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/lovef.png",
          height: 28,
          width: 28,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: FontFamily.gilroyMedium,
              fontSize: 16,
              color: BlackColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> share() async {
    debugPrint("============ App Name ============ $appName");
    debugPrint("========== PackageName =========== $packageName");

    final String text =
        'Hey! Now use our app to share with your family or friends. '
        'User will get wallet amount on your 1st successful transaction. '
        'Enter my referral code & Enjoy your shopping !!!';

    final String linkUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    await Share.share(
      '$text\n$linkUrl',
      subject: appName,
    );
  }
}
