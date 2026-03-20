import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/packages_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/lab/packge_detail_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PopularTestsTab extends StatefulWidget {
  const PopularTestsTab({super.key, required this.categoryId, required this.labId});
  final String categoryId;
  final String labId;

  @override
  State<PopularTestsTab> createState() => _PopularTestsTabState();
}

class _PopularTestsTabState extends State<PopularTestsTab> {
  
  String currency = "";

  PackagesController packagesController = Get.put(PackagesController());

  @override
  void initState() {
    setState(() {
      currency = "${getData.read("currency")}";
    });
    debugPrint("--------- populer categoryId -------- ${widget.categoryId}");
    debugPrint("----------- populer labId ----------- ${widget.labId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            titlebar(
              title: "Recommended Packages".tr,
            ),
            SizedBox(height: 10),
            Expanded(
              child: packagesController.packagesApiModel!.individual!.isEmpty
              ? Center(
                  child: Image.asset(
                    "assets/emptyOrder.png",
                    height: Get.height / 5,
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: packagesController.packagesApiModel!.individual!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return packageDetailsCustom(
                      onBook: () {
                        if (getData.read("UserLogin") == null) {
                          Get.offAll(BoardingPage());
                        } else {
                          packagesController.cartPopularTestsLoding[index] = true;
                          setState(() {});
                          packagesController.packageAddinCartApi(
                            labId: widget.labId,
                            pacakgeId: "${packagesController.packagesApiModel!.individual![index].id}",
                          ).then((value) {
                            debugPrint("--------- value --------- $value");
                            if (value["Result"] == true) {
                              packagesController.packagesApi(
                                categoryId: widget.categoryId,
                                labId: widget.labId,
                              ).then((value1) {
                                if (value1["Result"] == true) {
                                  packagesController.cartPopularTestsLoding[index] = false;
                                  setState(() {});
                                } 
                              });
                            }
                          });
                        }
                      },
                      isLoding: packagesController.cartPopularTestsLoding[index],
                      buttonColor: packagesController.packagesApiModel!.individual![index].exist == 1 ? RedColor : gradient.defoultColor,
                      buttontext: packagesController.packagesApiModel!.individual![index].exist == 1 ? "Remove".tr : "Book".tr ,
                      onTap: () => Get.to(PackgeDetailScreen(packageId: "${packagesController.packagesApiModel!.individual![index].id}")),
                      image: "${packagesController.packagesApiModel!.individual![index].logo}",
                      title: "${packagesController.packagesApiModel!.individual![index].title}",
                      tests: "${packagesController.packagesApiModel!.individual![index].packageName}",
                      price: "${packagesController.packagesApiModel!.individual![index].packagePrice}",
                      fastingRequired: "${packagesController.packagesApiModel!.individual![index].fastingRequire}",
                      testReportTime: "${packagesController.packagesApiModel!.individual![index].testReportTime}",
                    );
                  }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget packageDetailsCustom({
  required VoidCallback onTap,
  required VoidCallback onBook,
  required String image,
  required String title,
  required String tests,
  required String price,
  required String fastingRequired,
  required String testReportTime,
  required String buttontext,
  required Color buttonColor,
  required bool isLoding,
}){
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: greycolor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: Get.height / 8,
                width: Get.height / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: greyColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage.assetNetwork(
                    height: Get.height / 8,
                    width: Get.height / 8,
                    fit: BoxFit.cover,
                    placeholder: "assets/ezgif.com-crop.gif",
                    placeholderFit: BoxFit.cover,
                    placeholderCacheWidth: 60,
                    placeholderCacheHeight: 60,
                    image: "${Config.imageBaseurlDoctor}$image",
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: BlackColor,
                        fontFamily: FontFamily.gilroyRegular,
                      ),
                    ), 
                    SizedBox(height: 10),
                    Text(
                      "${"Includes".tr} $tests ${"tests".tr}",
                      style: TextStyle(
                        decorationThickness: 2,
                        decoration: TextDecoration.underline,
                        color: BlackColor,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${getData.read("currency")} $price ",
                style: TextStyle(
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 18,
                ),
              ),
              InkWell(
                onTap: isLoding == true ? (() {}) : onBook,
                child: Container(
                  height: 45,
                  width: Get.width / 3.5,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child : isLoding == true
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: WhiteColor,
                        size: 30,
                      )
                    : Text(
                        buttontext,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamily.gilroyBold,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: greycolor),
          Row(
            children: [
              SvgPicture.asset(
                "assets/restaurant.svg",
                height: 20,
              ),
              SizedBox(width: 5),
              Text(
                fastingRequired,
                style: TextStyle(
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyRegular,
                ),
              ),
              SizedBox(width: 15),
              Image.asset(
                "assets/note-text.png",
                height: 20,
              ),
              SizedBox(width: 5),
              Text(
                "${"Reports in".tr} $testReportTime ${"Hours".tr}",
                style: TextStyle(
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyRegular,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}