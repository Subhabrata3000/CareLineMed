// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller/lab_category_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/lab/lab_list_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/widget/custom_title.dart';

class LabCategoryScreen extends StatefulWidget {
  const LabCategoryScreen({super.key});

  @override
  State<LabCategoryScreen> createState() => _LabCategoryScreenState();
}

class _LabCategoryScreenState extends State<LabCategoryScreen> {

  int selectIndexSlider = 0;

  LabCategoryController labCategoryController = Get.put(LabCategoryController());

  @override
  void initState() {
    labCategoryController.labApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: SvgPicture.asset(
            "assets/bottomIcons/test_tube.svg",
            color: WhiteColor,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          "Lab Tests".tr,
          style: TextStyle(
            color: WhiteColor,
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
      ),
      body: GetBuilder<LabCategoryController>(
        builder: (labCategoryController) {
          return labCategoryController.isLoding
          ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  if(labCategoryController.labCategoryApiModel!.bannerList!.isNotEmpty)...[
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        viewportFraction: 0.8,
                        clipBehavior: Clip.none,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: labCategoryController.labCategoryApiModel!.bannerList!.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            selectIndexSlider = index;
                          });
                        },
                      ),
                      items: labCategoryController.labCategoryApiModel!.bannerList!.map((item) => GestureDetector(
                          child: Container(
                            width: Get.size.width,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/ezgif.com-crop.gif",
                                image: "${Config.imageBaseurlDoctor}$item",
                                fit: BoxFit.cover,
                                width: Get.width,
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                  SizedBox(height: 10),
                  titlebar(title: "Popular health checkups".tr),
                  SizedBox(height: 10),
                  GridView.builder(
                    itemCount: labCategoryController.labCategoryApiModel!.categoryList!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: Get.height / 11),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 130,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Get.to(
                          LabListScreen(
                            categoryId: "${labCategoryController.labCategoryApiModel!.categoryList![index].id}",
                            category: "${labCategoryController.labCategoryApiModel!.categoryList![index].name}",
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Changed to transparent
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: greycolor.withOpacity(0.3)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: "assets/ezgif.com-crop.gif",
                                  placeholderFit: BoxFit.cover,
                                  placeholderCacheWidth: 60,
                                  placeholderCacheHeight: 60,
                                  image: "${Config.imageBaseurlDoctor}${labCategoryController.labCategoryApiModel!.categoryList![index].image}",
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "${labCategoryController.labCategoryApiModel!.categoryList![index].name}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontSize: 13,
                                    fontFamily: FontFamily.gilroyMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
        }
      ),
    );
  }
}
