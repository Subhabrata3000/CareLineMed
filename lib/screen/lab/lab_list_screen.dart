// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/lab_list_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/lab/packages_screen.dart';
import 'package:laundry/utils/custom_colors.dart';

class LabListScreen extends StatefulWidget {
  const LabListScreen({super.key, required this.categoryId, required this.category});

  final String category;
  final String categoryId;

  @override
  State<LabListScreen> createState() => _LabListScreenState();
}

class _LabListScreenState extends State<LabListScreen> {
  LabListController labListController = Get.put(LabListController());

  @override
  void initState() {
    labListController.isLoading = true;
    setState(() {});
    labListController.labListApi(categoryId: widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: BlackColor),
        title: Text(
          "Certified Partner Labs".tr,
          maxLines: 1,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<LabListController>(
        builder: (labListController) {
          return labListController.isLoading
              ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
              : labListController.labListApiModel!.labList!.isEmpty
                ? Center(
                    child: SizedBox(
                      width: Get.width / 1.5,
                      child: Text(
                        "${widget.category} testing is not available in your area.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: labListController.labListApiModel!.labList!.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                            PackagesScreen(
                              categoryId: widget.categoryId,
                              labId: "${labListController.labListApiModel!.labList![index].id}",
                              title: widget.category,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FadeInImage.assetNetwork(
                                      height: 85,
                                      width: 70,
                                      // width: Get.height / 12,
                                      fit: BoxFit.cover,
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      placeholderFit: BoxFit.cover,
                                      placeholderCacheWidth: 60,
                                      placeholderCacheHeight: 60,
                                      image: "${Config.imageBaseurlDoctor}${labListController.labListApiModel!.labList![index].logo}",
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "${labListController.labListApiModel!.labList![index].name}",
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            color: BlackColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${labListController.labListApiModel!.labList![index].address}",
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            color: textcolor,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/star.svg",
                                                  color: yelloColor,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 2),
                                                RichText(
                                                  text: TextSpan(
                                                    text: "${labListController.labListApiModel!.labList![index].totReview}",
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily: FontFamily.gilroyBlack,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: " (${labListController.labListApiModel!.labList![index].avgStar})",
                                                        style: TextStyle(
                                                          color: greycolor,
                                                          fontFamily: FontFamily.gilroyRegular,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/location-pin_filled.svg",
                                                  color: textcolor,
                                                  height: 15,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "${labListController.labListApiModel!.labList![index].distance} KM",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.gilroyRegular,
                                                    color: greycolor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                  );
        },
      ),
    );
  }
}
