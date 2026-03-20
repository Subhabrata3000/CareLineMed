// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/screen/doctor_info_screen.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';
import '../controller_doctor/category_doctor_controller.dart';
import '../widget/button.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final String image;
  final String departmentId;
  const CategoryScreen({
    super.key,
    required this.name,
    required this.image,
    required this.departmentId,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  funApi() async {
    categoryDoctorController.categoryDoctorApi(departmentId: widget.departmentId.toString());
    setState(() {});
  }

  int selectTab = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    funApi();
    _tabController?.index == 0;
    if (_tabController?.index == 0) {}
  }

  @override
  void dispose() {
    super.dispose();
    categoryDoctorController.isLoading = false;
    _tabController?.dispose();
  }

  final double expandedHeight = 180;

  CategoryDoctorController categoryDoctorController = Get.put(CategoryDoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 35,
            width: 35,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF000000).withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: WhiteColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.name,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 0.4,
            fontFamily: FontFamily.gilroyBold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: greyColor,
                  labelStyle: const TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: WhiteColor,
                  ),
                  onTap: (value) {
                    selectTab = value;
                    setState(() {});
                  },
                  labelColor: gradient.defoultColor,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/user-rectangle.svg",
                            color: selectTab == 0 ? primeryColor : greyColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "In Person".tr,
                            style: TextStyle(
                              color: selectTab == 0 ? primeryColor : greyColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/camera_video.svg",
                            color: selectTab == 1 ? primeryColor : greyColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Video Visit".tr,
                            style: TextStyle(
                              color: selectTab == 1 ? primeryColor : greyColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                inPerson(),
                videoVisit(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inPerson() {
    return GetBuilder<CategoryDoctorController>(
      builder: (categoryDoctorController) {
        return Stack(
          children: [
            ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: categoryDoctorController.isLoading ? categoryDoctorController.categoryTypeDoctorModel!.clinicVisit.length : 3,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      if (categoryDoctorController.isLoading) {
                      save("changeIndex", true);
                        Get.to(
                          DoctorInfoScreen(
                            doctorid: categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].id,
                            departmentId: widget.departmentId,
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Row
                          Row(
                            children: [
                              // Profile Image
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage("assets/ezgif.com-crop.gif"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: categoryDoctorController.isLoading
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(65),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/ezgif.com-crop.gif",
                                            placeholderCacheHeight: 60,
                                            placeholderCacheWidth: 60,
                                            image: "${Config.imageBaseurlDoctor}${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].logo}",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox(),
                                  ),
                                  // Online Indicator
                                  if(categoryDoctorController.isLoading)...[
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(width: 12),
                              // Doctor Info
                              Flexible(
                                child: categoryDoctorController.isLoading
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].title,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 18,
                                            color: BlackColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].subtitle,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 14,
                                            color: BlackColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/star.svg",
                                              color: yelloColor,
                                              height: 18,
                                            ),
                                            SizedBox(width: 4),
                                            // Display avgStar value
                                            Text(
                                              categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].avgStar.toStringAsFixed(1),
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyMedium,
                                                fontSize: 15,
                                                color: greycolor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        "assets/ezgif.com-crop.gif",
                                        height: 65,
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                      ),
                                  ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade200,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: categoryDoctorController.isLoading
                                ? customListTile(
                                    iconImage: "assets/briefcase_01.svg",
                                    title: "Total Experience".tr,
                                    subTitle: "${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].yearOfExperience}+ Years",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ),
                              Container(
                                width: 0.8,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                color: Colors.grey.shade200,
                              ),
                              Expanded(
                                child: categoryDoctorController.isLoading
                                  ? customListTile(
                                      iconImage: "assets/star.svg",
                                      title: "Rating".tr,
                                      subTitle: "${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].avgStar.toStringAsFixed(1)} (${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].totReview})",
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/ezgif.com-crop.gif",
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: categoryDoctorController.isLoading
                                  ? customListTile(
                                      iconImage: "assets/coin-dollar.svg",
                                      title: "Consultation fee".tr,
                                      subTitle: "${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].minInpPrice} - ${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].maxInpPrice}",
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/ezgif.com-crop.gif",
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ),
                              Container(
                                width: 0.8,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                color: Colors.grey.shade200,
                              ),
                              Expanded(
                                child: categoryDoctorController.isLoading
                                  ? customListTile(
                                      iconImage: "assets/camera_video.svg",
                                      title: "Video Visit".tr,
                                      subTitle: "${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].minVidPrice} - ${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.clinicVisit[index].maxVidPrice}",
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/ezgif.com-crop.gif",
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          categoryDoctorController.isLoading
                            ? button(
                                text: "Book Appointment".tr,
                                color: gradient.defoultColor,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  "assets/ezgif.com-crop.gif",
                                  height: 45,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
              ),
            if(categoryDoctorController.isLoading)...[
              if(categoryDoctorController.categoryTypeDoctorModel!.clinicVisit.isEmpty)...[
                Container(
                  height: Get.height,
                  width: Get.width,
                  color: WhiteColor,
                  child: Center(
                    child: Text(
                      'No Doctor available in your area.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 15,
                        color: BlackColor,
                      ),
                    ),
                  ),
                ),
              ]
            ]
          ],
        );
      },
    );
  }

  Widget customListTile({
    required String iconImage,
    required String title,
    required String subTitle,
  }) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: SvgPicture.asset(iconImage),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 12.5,
                    color: greytext,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 12.5,
                    color: BlackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget videoVisit() {
    return GetBuilder<CategoryDoctorController>(
      builder: (categoryDoctorController) {
        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: categoryDoctorController.isLoading ? categoryDoctorController.categoryTypeDoctorModel!.videoConsult.length : 3,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    if (categoryDoctorController.isLoading) {
                      save("changeIndex", true);
                      Get.to(
                        DoctorInfoScreen(
                          doctorid: categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].id,
                          departmentId: widget.departmentId,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Row
                        Row(
                          children: [
                            // Profile Image
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage("assets/ezgif.com-crop.gif"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: categoryDoctorController.isLoading
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(65),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: "assets/ezgif.com-crop.gif",
                                          placeholderCacheHeight: 60,
                                          placeholderCacheWidth: 60,
                                          image: "${Config.imageBaseurlDoctor}${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].logo}",
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SizedBox(),
                                ),
                                // Online Indicator
                                if(categoryDoctorController.isLoading)...[
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(width: 12),
  
                            // Doctor Info
                            Flexible(
                              child: categoryDoctorController.isLoading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].title,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 18,
                                        color: BlackColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].subtitle,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                        color: BlackColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/star.svg",
                                          color: yelloColor,
                                          height: 18,
                                        ),
                                        SizedBox(width: 4),
                                        // Display avgStar value
                                        Text(
                                          categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].avgStar.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 15,
                                            color: greycolor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/ezgif.com-crop.gif",
                                    height: 65,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ),
                          ],
                        ),
  
                        SizedBox(height: 8),
  
                        Divider(
                          thickness: 0.8,
                          color: Colors.grey.shade200,
                        ),
  
                        SizedBox(height: 8),
  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: categoryDoctorController.isLoading
                                ? customListTile(
                                    iconImage: "assets/briefcase_01.svg",
                                    title: "Total Experience".tr,
                                    subTitle: "${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].yearOfExperience}+ ${"Years".tr}",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                            Container(
                              width: 0.8,
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              color: Colors.grey.shade200,
                            ),
                            Expanded(
                              child: categoryDoctorController.isLoading
                                ? customListTile(
                                    iconImage: "assets/star.svg",
                                    title: "Rating".tr,
                                    subTitle: "${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].avgStar.toStringAsFixed(1)}(${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].totReview})",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                          ],
                        ),
  
                        SizedBox(height: 20),
  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: categoryDoctorController.isLoading
                                ? customListTile(
                                    iconImage: "assets/coin-dollar.svg",
                                    title: "Consultation fee".tr,
                                    subTitle: "${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].minInpPrice} - ${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].maxInpPrice}",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                            Container(
                              width: 0.8,
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              color: Colors.grey.shade200,
                            ),
                            Expanded(
                              child: categoryDoctorController.isLoading
                                ? customListTile(
                                    iconImage: "assets/camera_video.svg",
                                    title: "Video Visit".tr,
                                    subTitle: "${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].minVidPrice} - ${getData.read("currency")}${categoryDoctorController.categoryTypeDoctorModel!.videoConsult[index].maxVidPrice}",
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                          ],
                        ),
  
                        SizedBox(height: 12),
  
                        categoryDoctorController.isLoading
                          ? button(
                              text: "Book Appointment".tr,
                              color: gradient.defoultColor,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "assets/ezgif.com-crop.gif",
                                height: 45,
                                width: Get.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
            ),
            if(categoryDoctorController.isLoading)...[
              if(categoryDoctorController.categoryTypeDoctorModel!.clinicVisit.isEmpty)...[
                Container(
                  height: Get.height,
                  width: Get.width,
                  color: WhiteColor,
                  child: Center(
                    child: Text(
                      'No Doctor available in your area.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 15,
                        color: BlackColor,
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ],
        );
      },
    );
  }
}
