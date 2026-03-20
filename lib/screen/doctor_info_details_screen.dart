// ignore_for_file: deprecated_member_use

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller_doctor/doctor_detail_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/full_screen_image.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DoctorInfoDetailsScreen extends StatefulWidget {
  const DoctorInfoDetailsScreen({super.key});

  @override
  State<DoctorInfoDetailsScreen> createState() => _DoctorInfoDetailsScreenState();
}

class _DoctorInfoDetailsScreenState extends State<DoctorInfoDetailsScreen>  with TickerProviderStateMixin {

  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());

  late TabController tabController;

  int data = 0;

  int selectIndex = 0;

  List bottom = [
    "About".tr,
    "Review".tr,
    "Awards".tr,
    "Photos".tr,
    "FAQ's".tr,
    "Cancel Policy".tr,
  ];

  List icon = [
    "assets/info-circle1.png",
    "assets/star.svg",
    "assets/bottomIcons/doctor.svg",
    "assets/image-gallery.png",
    "assets/question-circle.png",
    "assets/info-circle1.png",
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: bottom.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        titleSpacing: 0,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "${doctorDetailController.doctorDetailModel!.doctor!.title}",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: BlackColor,
          ),
        ),
      ),
      body: Column(
        children: [
         Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: WhiteColor,
            ),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  unselectedLabelColor: greyColor,
                  labelStyle: const TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: WhiteColor,
                  ),
                  labelColor: gradient.defoultColor,
                  onTap: (value) {
                    setState(() {
                      selectIndex = value;
                      data = value;
                      debugPrint("++++++selectIndex+++++++ $selectIndex");
                      debugPrint("++++++data+++++++ $data");
                      debugPrint("++++++value+++++++ $value");
                    });
                  },
                  tabs: [
                    for(int i = 0; i < bottom.length; i++)...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getImageExtention("${icon[i]}") == ".svg"
                          ? SvgPicture.asset(
                              icon[i],
                              color: data == i
                                  ? primeryColor
                                  : Colors.grey,
                              height: 15,
                              width: 15,
                            )
                          : Image.asset(
                              icon[i],
                              color: data == i
                                  ? primeryColor
                                  : Colors.grey,
                              height: 15,
                              width: 15,
                            ),
                          SizedBox(width: 3),
                          Text(
                            bottom[i],
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: data == i
                                  ? primeryColor
                                  : Colors.grey,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: selectIndex == 0
                ? overViewWidget()
                : selectIndex == 1
                    ? reviewWidget()
                    : selectIndex == 2
                        ? petsWidget()
                        : selectIndex == 3
                            ? photoWidget()
                            : selectIndex == 4
                                ? faqWidget()
                                : cancelPolicyWidget(),
            ),
          ),
        ],
      ),
    );
  }

    Widget photoWidget() {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: doctorDetailController.doctorDetailModel!.galleryList!.isNotEmpty
                ? GridView.builder(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  itemCount: doctorDetailController.doctorDetailModel!.galleryList!.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 120,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        debugPrint("--------------- image url -------------- ${Config.imageBaseurlDoctor}${doctorDetailController.imagePaths}");
                        Get.to(
                          FullScreenImage(
                            imageUrl: "${Config.imageBaseurlDoctor}${doctorDetailController.imagePaths[index]}",
                            tag: "generate_a_unique_tag",
                          ),
                        );
                      },
                      child: Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/ezgif.com-crop.gif",
                            placeholderCacheWidth: 110,
                            placeholderCacheHeight: 110,
                            image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.galleryList![index].image}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Center(
                    child: SizedBox(
                      width: Get.width / 1.3,
                      child: Text(
                        "Sorry, there are no photos available to display at this time".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget overViewWidget() {
    return GetBuilder<DoctorDetailController>(
        builder: (doctorDetailController) {
      return doctorDetailController.doctorDetailModel!.aboutData!.isEmpty
          ? Center(
              child: SizedBox(
                width: Get.width / 1.5,
                child: Text(
                  "Sorry, there are no about to display at this time".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          : Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${doctorDetailController.doctorDetailModel!.doctor!.address}",
                          maxLines: 1,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: doctorDetailController.doctorDetailModel!.aboutData!.length,
                itemBuilder: (context, index1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${index1 + 1}. ${doctorDetailController.doctorDetailModel!.aboutData![index1].head}",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyExtraBold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${doctorDetailController.doctorDetailModel!.aboutData![index1].description}",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "${doctorDetailController.doctorDetailModel!.aboutData![index1].title}",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: doctorDetailController.doctorDetailModel!.aboutData![index1].about!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].subtitle!.isNotEmpty
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                     image: DecorationImage(
                                       fit: BoxFit.cover,
                                       image: NetworkImage("${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].icon}"),
                                     ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      "${doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].subtitle}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                    ),
                                  ),
                                ],
                              ) : SizedBox(),
                              SizedBox(height: 5),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget petsWidget() {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: doctorDetailController.doctorDetailModel!.awardData!.isNotEmpty
            ? GridView.builder(
                itemCount: doctorDetailController.doctorDetailModel!.awardData!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 190,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(65),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(65),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/ezgif.com-crop.gif",
                            placeholderCacheWidth: 110,
                            placeholderCacheHeight: 110,
                            image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.awardData![index].image}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${doctorDetailController.doctorDetailModel!.awardData![index].title}",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                          color: BlackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                    ],
                  );
                },
              )
            : Center(
                child: SizedBox(
                  width: Get.width / 1.4,
                  child: Text(
                    "Sorry, there are no award available to display at this time".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget reviewWidget() {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: doctorDetailController.doctorDetailModel!.reviewData!.isNotEmpty
            ? ListView.builder(
                itemCount: doctorDetailController.doctorDetailModel!.reviewData!.length,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: Text(
                            doctorDetailController.doctorDetailModel!.reviewData![index].cusName![0],
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${doctorDetailController.doctorDetailModel!.reviewData![index].cusName}",
                              style: TextStyle(
                                color: BlackColor,
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${doctorDetailController.doctorDetailModel!.reviewData![index].hospitalName}",
                              style: TextStyle(
                                color: BlackColor,
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                        subtitle: Text(
                          doctorDetailController.doctorDetailModel!.reviewData![index].date.toString().split(" ").first,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                            color: greycolor,
                            fontFamily: FontFamily.gilroyMedium,
                          ),
                        ),
                        trailing: Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: gradient.defoultColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/reviewStar.png",
                                height: 15,
                                width: 15,
                                color: gradient.defoultColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${doctorDetailController.doctorDetailModel!.reviewData![index].starNo}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: FontFamily.gilroyBold,
                                  color: gradient.defoultColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "${doctorDetailController.doctorDetailModel!.reviewData![index].review}",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                            color: greycolor,
                            fontFamily: FontFamily.gilroyMedium,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
              )
            : Center(
                child: SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    "Sorry, there are no reviews to display at this time".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget faqWidget() {
    const contentStyle = TextStyle(
      color: Color(0xff999999),
      fontSize: 14,
      fontFamily: FontFamily.gilroyMedium,
    );
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: doctorDetailController.doctorDetailModel!.faqData!.isNotEmpty
            ? Accordion(
                disableScrolling: true,
                flipRightIconIfOpen: true,
                contentVerticalPadding: 0,
                scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                contentBorderColor: Colors.transparent,
                maxOpenSections: 1,
                headerBackgroundColorOpened: Colors.grey.shade100,
                headerPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                children: [
                  for (var j = 0; j < doctorDetailController.doctorDetailModel!.faqData!.length; j++)...[
                    AccordionSection(
                      rightIcon: Image.asset(
                        "assets/Arrow - Down.png",
                        height: 20,
                        width: 20,
                        color: gradient.defoultColor,
                      ),
                      headerPadding: const EdgeInsets.all(15),
                      headerBackgroundColor: Colors.grey.shade100,
                      contentBackgroundColor: Colors.grey.shade100,
                      header: Text(
                        "${doctorDetailController.doctorDetailModel!.faqData![j].title}",
                        style: TextStyle(
                          color: BlackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        "${doctorDetailController.doctorDetailModel!.faqData![j].description}",
                        style: contentStyle,
                      ),
                      contentHorizontalPadding: 20,
                      contentVerticalPadding: 10,
                      contentBorderWidth: 1,
                    ),
                  ],
                ],
              )
            : Center(
                child: SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    "Sorry, there are no faq available to display at this time".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                      color: BlackColor,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget cancelPolicyWidget() {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: doctorDetailController.doctorDetailModel!.doctor!.cancelPolicy != ""
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          HtmlWidget(
                            "${doctorDetailController.doctorDetailModel!.doctor!.cancelPolicy}",
                            textStyle: TextStyle(
                              color: BlackColor,
                              fontSize: 15,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      width: Get.width / 1.2,
                      child: Text(
                        "Sorry, there are no Cancel Policy available to display at this time".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 15,
                          color: BlackColor,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}



class PhotoViewPage extends StatefulWidget {
  final List<String> photos;
  final int index;

  const PhotoViewPage({
    super.key,
    required this.photos,
    required this.index,
  });

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: doctorDetailController.doctorDetailModel!.galleryList!.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: CachedNetworkImage(
            height: Get.height,
            width: Get.width,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            imageUrl: "${Config.imageBaseurlDoctor}${widget.photos[index]}",
            placeholder: (context, url) => Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: WhiteColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/ezgif.com-crop.gif",
                fit: BoxFit.cover,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.white,
              child: Center(child: Text(error.toString(),style: TextStyle(color: Colors.black),)),
            ),
          ),
          minScale: PhotoViewComputedScale.covered,
          heroAttributes: PhotoViewHeroAttributes(tag: "${Config.imageBaseurlDoctor}${widget.photos[index]}"),
        ),
        pageController: PageController(initialPage: widget.index),
        enableRotation: false,
      ),
    );
  }
}
