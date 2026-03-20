// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/package_details_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';

class PackgeDetailScreen extends StatefulWidget {
  final String packageId;
  const PackgeDetailScreen({super.key, required this.packageId});

  @override
  State<PackgeDetailScreen> createState() => _PackgeDetailScreenState();
}

class _PackgeDetailScreenState extends State<PackgeDetailScreen> {
  PackageDetailsController packageDetailsController = Get.put(PackageDetailsController());

  @override
  void initState() {
    packageDetailsController.isLoading = true;
    debugPrint("------------ packageID ------------- ${widget.packageId}");
    setState(() {
      packageDetailsController.currency = "${getData.read("currency")}";
    });
    packageDetailsController.packageDetailsApi(packageId: widget.packageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: BlackColor),
        title: Text(
          "Package Details".tr,
          maxLines: 1,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: GetBuilder<PackageDetailsController>(
        builder: (packageDetailsController) {
          return packageDetailsController.isLoading
          ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
          : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
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
                                  image: "${Config.imageBaseurlDoctor}${packageDetailsController.packgeDetailApiModel!.packageData!.logo}",
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [ 
                                  Text(
                                    "${packageDetailsController.packgeDetailApiModel!.packageData!.title}",
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontSize: 18,
                                      fontFamily: FontFamily.gilroyBold,
                                    ),
                                  ), 
                                  SizedBox(height: 10),
                                  Text(
                                    " ${packageDetailsController.packgeDetailApiModel!.packageData!.subtitle}",
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  details(image: "assets/bottomIcons/Home.svg", title: "Home Collect Extra Price".tr, text: "${packageDetailsController.currency} ${packageDetailsController.packgeDetailApiModel!.packageData!.homeExtraPrice}"),
                  details(image: "assets/bottomIcons/test_tube.svg", title: "Sample Type".tr, text: packageDetailsController.packgeDetailApiModel!.packageData!.sampleType!.join(", ")),
                  details(image: "assets/restaurant.svg", title: "Fasting Required".tr, text: "${packageDetailsController.packgeDetailApiModel!.packageData!.fastingRequire}"),
                  details(image: "assets/clock-circle.svg", title: "Test Report Time".tr, text: "${packageDetailsController.packgeDetailApiModel!.packageData!.testReportTime}"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/package-box.svg",
                        color: BlackColor,
                        height: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Package Includes".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${packageDetailsController.currency} ${packageDetailsController.packgeDetailApiModel!.packageData!.totPrice}",
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for(int i = 0; i < packageDetailsController.packgeDetailApiModel!.packageData!.packageName!.length; i++)...[
                          i < 3
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: BlackColor,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    packageDetailsController.packgeDetailApiModel!.packageData!.packageName![i],
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                  Spacer(), 
                                  Text(
                                    "${packageDetailsController.currency} ${packageDetailsController.packgeDetailApiModel!.packageData!.packagePrice![i]}",
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                ],
                              ),
                          )
                          : SizedBox(),
                        ],
                        packageDetailsController.packgeDetailApiModel!.packageData!.packageName!.length < 3
                        ? SizedBox()
                        : InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: WhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/package-box.svg",
                                            color: BlackColor,
                                            height: 25,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Package Includes".tr,
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            physics: BouncingScrollPhysics(),
                                            itemCount: packageDetailsController.packgeDetailApiModel!.packageData!.packageName!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    height: 8,
                                                    width: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: gradient.defoultColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    packageDetailsController.packgeDetailApiModel!.packageData!.packageName![index],
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily: FontFamily.gilroyRegular,
                                                    ),
                                                  ),
                                                  Spacer(), 
                                                  Text(
                                                    "${packageDetailsController.currency} ${packageDetailsController.packgeDetailApiModel!.packageData!.packagePrice![index]}",
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily: FontFamily.gilroyRegular,
                                                    ),
                                                  ), 
                                                ],
                                              );
                                            }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "Show More".tr,
                            style: TextStyle(
                              color: gradient.defoultColor,
                              fontSize: 16,
                              fontFamily: FontFamily.gilroyBold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/note-text.png",
                        color: BlackColor,
                        height: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Package Description".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${packageDetailsController.packgeDetailApiModel!.packageData!.description}",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyRegular,
                    ),
                  ), 
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

Widget details({
  required String image,
  required String title,
  required String text,
  String? fontFamily,
}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          height: 20,
          color: textcolor,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: textcolor,
            fontFamily: fontFamily ?? FontFamily.gilroyBold,
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: blueColor.withOpacity(0.1),
              border: Border.all(color: greyColor),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
