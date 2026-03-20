// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/favorite_add_controller.dart';
import 'package:laundry/controller/send_notification_controller.dart';
import 'package:laundry/controller_doctor/doctor_detail_controller.dart';
import 'package:laundry/controller_doctor/home_controller.dart';
import 'package:laundry/controller_doctor/time_slot_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/chat/chat_screen.dart';
import 'package:laundry/screen/doctor_info_details_screen.dart';
import 'package:laundry/screen/yourcart_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/utils/customwidget.dart';
import 'package:laundry/widget/button.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DoctorInfoScreen extends StatefulWidget {
  final String doctorid;
  final String departmentId;
  const DoctorInfoScreen({super.key, required this.doctorid, required this.departmentId});

  @override
  DoctorInfoScreenState createState() => DoctorInfoScreenState();
}

class DoctorInfoScreenState extends State<DoctorInfoScreen> with SingleTickerProviderStateMixin {
  FavoriteAddController favoriteAddController = Get.put(FavoriteAddController());
  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());
  HomeController homeController = Get.put(HomeController());
  TimeSlotController timeSlotController = Get.put(TimeSlotController());
  SendNotificationController sendNotificationController = Get.put(SendNotificationController());

  late ScrollController _scrollController;
  static const kExpandedHeight = 460.0; // INCREASED HEADER HEIGHT SLIGHTLY

  ScrollController scrollController = ScrollController();

  TabController? _tabController;
  late DateRangePickerController dateRangePickerController;

  int currentIndex = 0;
  bool bottomShow = false;

  int selectIndex = 0;

  int timeIndex = 0;

  int daysIndex = 0;
  bool serviceisLoading = true;

  String? selectedSession; // Track session (Morning, Afternoon, Evening)
  String? selectedTime;
  String? selectedHid;

  String serviceType = "";

  @override
  void initState() {
    super.initState();
    doctorDetailController.isLoading = true;
    setState(() {});
    _tabController = TabController(length: 2, vsync: this);
    dateRangePickerController = DateRangePickerController();
    doctorDetailController.doctorDetailApi(
      doctorId: widget.doctorid,
      departmentId: widget.departmentId,
    ).then((value) async {
      if (value['Result'] == true) {
        await timeSlotController.timeSlotApi(
          doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
          date: "${doctorDetailController.doctorDetailModel!.alldate!.first.date}",
          departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList!.first.departmentId}",
          hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList!.first.hospitalId}",
        );
      } else {
        Fluttertoast.showToast(msg: "${value["message"]}");
      }
    });
    serviceisLoading = false;
    setState(() {});
    _scrollController = ScrollController()..addListener(() {
      setState(() {});
    });
    _tabController?.index == 0;
    if (_tabController?.index == 0) {}
    debugPrint(".............${scrollController.keepScrollOffset}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    doctorDetailController.isLoading = true;
    timeSlotController.isLoading = true;
    _tabController?.dispose();
    super.dispose();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  List iconList = [
    "assets/Call.svg",
    "assets/video.svg",
    "assets/chat-text.svg",
  ];

  List bottomIcon = [
    "assets/briefcase_01.svg",
    "assets/star.svg",
    "assets/coin-dollar.svg",
    "assets/camera_video.svg",
  ];

  List bottomTitle = [
    "Total Experience".tr,
    "Rating".tr,
    "Consultation fee".tr,
    "Video Visit".tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: selectedTime == null
            ? buttonGrey(
          text: "Book Appointment".tr,
          color: greycolor.withOpacity(0.2),
          onPress: () {
            Fluttertoast.showToast(msg: "Select time for your appointment!".tr);
          },
        )
            : button(
          text: "${"Book Appointment".tr} ${getData.read("currency")}${(doctorDetailController.priceChange == "1" || doctorDetailController.priceChange == "3") ? doctorDetailController.inPersonPrice : (doctorDetailController.priceChange == "2" || doctorDetailController.priceChange == "3") ? doctorDetailController.videoPrice : ""}",
          color: primeryColor,
          onPress: () {
            if (getData.read("UserLogin") == null) {
              Get.offAll(BoardingPage());
            } else {
              Get.to(
                YourCartScreen(
                  day: "$selectedSession",
                  doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                  departmentId: widget.departmentId,
                  subDepartmentId: doctorDetailController.subDepartmentId.toString(),
                  hospitalId: hospitalID.toString(),
                  serviceType: (doctorDetailController.priceChange == "1" && doctorDetailController.selectTab == 0)
                      ? "1"
                      : (doctorDetailController.priceChange == "2" && doctorDetailController.selectTab == 1)
                      ? "2"
                      : (doctorDetailController.priceChange == "3" && doctorDetailController.selectTab == 0)
                      ? "1"
                      : "2",
                  date: doctorDetailController.timeSelected,
                  time: "$selectedTime",
                  price: (doctorDetailController.priceChange == "1" || doctorDetailController.priceChange == "3")
                      ? doctorDetailController.inPersonPrice
                      : (doctorDetailController.priceChange == "2" || doctorDetailController.priceChange == "3")
                      ? doctorDetailController.videoPrice
                      : 0,
                ),
              );
            }
          },
        ),
      ),
      body: GetBuilder<DoctorDetailController>(
        builder: (doctorDetailController) {
          return RefreshIndicator(
            color: gradient.defoultColor,
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 2),
                    () {
                  if (doctorDetailController.isLoading == false) {
                    doctorDetailController.doctorDetailApi(
                      doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                      departmentId: widget.departmentId.toString(),
                    );
                  }
                },
              );
            },
            child: GetBuilder<FavoriteAddController>(
                builder: (favoriteAddController) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        slivers: <Widget>[
                          SliverAppBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            iconTheme: IconThemeData(color: BlackColor),
                            elevation: 0,
                            leading: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: greyColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Blur(
                                  borderRadius: BorderRadius.circular(50),
                                  colorOpacity: 0.50,
                                  blurColor: greycolor,
                                  overlay: Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: WhiteColor,
                                    ),
                                  ),
                                  child: SizedBox(),
                                ),
                              ),
                            ),
                            backgroundColor: WhiteColor,
                            // show and hide SliverAppBar Title
                            title: _isSliverAppBarExpanded
                                ? Text(
                              doctorDetailController.isLoading
                                  ? ""
                                  : "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                              style: TextStyle(
                                color: textcolor,
                                fontFamily: FontFamily.gilroyBold,
                              ),
                            )
                                : null,
                            centerTitle: true,
                            actions: [
                              InkWell(
                                onTap: () {
                                  if (favoriteAddController.isLoading == false) {
                                    if (doctorDetailController.isLoading == false) {
                                      favoriteAddController.favoriteAddApi(
                                        doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                                        departmentId: widget.departmentId,
                                      ).then((value) {
                                        debugPrint("============ value ============ $value");
                                        if (value['Result'] == true) {
                                          doctorDetailController.doctorDetailApi(
                                            departmentId: widget.departmentId,
                                            doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                                          ).then((value1) {
                                            if (value1['Result'] == true) {
                                              favoriteAddController.isLoading = false;
                                              setState(() {});
                                            }
                                          });
                                        }
                                        debugPrint("============ timeSlotController.isLoading ============ ${timeSlotController.isLoading}");
                                        homeController.homeApiDoctor(lat: lat.toString(),lon: long.toString());
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: WhiteColor,
                                    shape: BoxShape.circle,
                                    image: doctorDetailController.isLoading || favoriteAddController.isLoading
                                        ? null
                                        : DecorationImage(
                                      image: AssetImage("assets/ezgif.com-crop.gif"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: favoriteAddController.isLoading
                                      ? Center(child: LoadingAnimationWidget.fourRotatingDots(color: gradient.defoultColor,size: 25))
                                      : doctorDetailController.isLoading
                                      ? SizedBox()
                                      : Blur(
                                    borderRadius: BorderRadius.circular(50),
                                    colorOpacity: 0.50,
                                    blurColor: greycolor,
                                    overlay: Center(
                                      child: Image.asset(
                                        doctorDetailController.doctorDetailModel!.doctor!.totFavorite == 0
                                            ? "assets/heartOutlinded.png"
                                            : "assets/heart.png",
                                        height: 20,
                                        width: 20,
                                        color: doctorDetailController.doctorDetailModel!.doctor!.totFavorite == 0
                                            ? WhiteColor
                                            : gradient.defoultColor,
                                      ),
                                    ),
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                            pinned: true,
                            snap: false,
                            floating: false,
                            expandedHeight: kExpandedHeight,
                            flexibleSpace: _isSliverAppBarExpanded
                                ? null
                                : FlexibleSpaceBar(
                              centerTitle: true,
                              title: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                      child: doctorDetailController.isLoading
                                          ? Image.asset(
                                        "assets/ezgif.com-crop.gif",
                                        fit: BoxFit.cover,
                                      )
                                          : FadeInImage.assetNetwork(
                                        placeholder: "assets/ezgif.com-crop.gif",
                                        placeholderCacheWidth: 110,
                                        placeholderCacheHeight: 110,
                                        image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.doctor!.coverLogo}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if( doctorDetailController.isLoading == false)...[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            BlackColor.withOpacity(0.8),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                alignment: Alignment.bottomRight,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: WhiteColor,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: AssetImage("assets/ezgif.com-crop.gif"),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black12,
                                                              blurRadius: 4,
                                                              spreadRadius: 1
                                                          )
                                                        ]
                                                    ),
                                                    child: doctorDetailController.isLoading
                                                        ? SizedBox()
                                                        : ClipOval(
                                                      child: FadeInImage.assetNetwork(
                                                        fadeInCurve: Curves.easeInCirc,
                                                        placeholder: "assets/ezgif.com-crop.gif",
                                                        placeholderCacheHeight: 60,
                                                        placeholderCacheWidth: 60,
                                                        placeholderFit: BoxFit.cover,
                                                        image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.doctor!.logo}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  if(doctorDetailController.isLoading == false)...[
                                                    if(doctorDetailController.doctorDetailModel!.doctor!.verificationStatus != "0")...[
                                                      Positioned(
                                                        bottom: 2,
                                                        right: 2,
                                                        child: Container(
                                                          height: 15,
                                                          width: 15,
                                                          padding: EdgeInsets.all(1),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: WhiteColor,
                                                          ),
                                                          child: SvgPicture.asset(
                                                            "assets/check_seal_verified.svg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              doctorDetailController.isLoading
                                                  ? ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.asset(
                                                  "assets/ezgif.com-crop.gif",
                                                  fit: BoxFit.cover,
                                                  height: 30,
                                                  width: Get.width / 2.5,
                                                ),
                                              )
                                                  : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${doctorDetailController.doctorDetailModel!.doctor!.name}",
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyBold,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontSize: 17,
                                                      color: WhiteColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyMedium,
                                                      fontSize: 12,
                                                      overflow: TextOverflow.ellipsis,
                                                      color: WhiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2),
                                              doctorDetailController.isLoading
                                                  ? ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.asset(
                                                  "assets/ezgif.com-crop.gif",
                                                  fit: BoxFit.cover,
                                                  height: 20,
                                                  width: Get.width / 1.9,
                                                ),
                                              )
                                                  : Text(
                                                "${doctorDetailController.doctorDetailModel!.doctor!.description}",
                                                maxLines: 2,
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontFamily: FontFamily.gilroyLight,
                                                  fontSize: 10,
                                                  color: WhiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // --- FIX START: BLUR CONTAINER HEIGHT INCREASED ---
                                        Container(
                                          width: Get.width,
                                          height: 160, // Changed from 125 to 160 to fix overflow
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Blur(
                                            borderRadius: BorderRadius.circular(15),
                                            colorOpacity: 0.50,
                                            blurColor: greycolor,
                                            overlay: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (doctorDetailController.isLoading == false) {
                                                            Get.to(DoctorInfoDetailsScreen());
                                                          }
                                                        },
                                                        child: Container(
                                                          height: doctorDetailController.isLoading ? 25 : null,
                                                          width: doctorDetailController.isLoading ? 80 : null,
                                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: gradient.defoultColor,
                                                            image: doctorDetailController.isLoading
                                                                ? DecorationImage(
                                                              image: AssetImage("assets/ezgif.com-crop.gif"),
                                                              fit: BoxFit.cover,
                                                            )
                                                                : null,
                                                          ),
                                                          child: doctorDetailController.isLoading
                                                              ? SizedBox()
                                                              : Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/info-circle.png",
                                                                color: WhiteColor,
                                                                height: 10,
                                                              ),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                "View Profile".tr,
                                                                style: TextStyle(
                                                                  color: WhiteColor,
                                                                  fontSize: 10,
                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      for (int i = 0; i < iconList.length; i++) ...[
                                                        InkWell(
                                                          onTap: () {
                                                            if ( doctorDetailController.isLoading == false) {
                                                              if (i == 0) {
                                                                if (doctorDetailController.doctorDetailModel!.doctor!.chatCheck == 1) {
                                                                  makingPhoneCall(context, number: "${doctorDetailController.doctorDetailModel!.doctor!.phone}");
                                                                } else {
                                                                  showToastMessage("Once you’ve booked any appointment, you can use audio calling with the doctor anytime — no need to book again!");
                                                                }
                                                              } else if (i == 1) {
                                                                if (doctorDetailController.doctorDetailModel!.doctor!.ad!.isNotEmpty && doctorDetailController.doctorDetailModel!.doctor!.at!.isNotEmpty) {
                                                                  if (doctorDetailController.doctorDetailModel!.doctor!.timecount! == 0) {
                                                                    sendNotificationController.sendNotificationApi(
                                                                      context: context,
                                                                      doctorId: widget.departmentId,
                                                                    );
                                                                  } else {
                                                                    showToastMessage("To maintain high-quality care, a new video appointment is required each time you want to consult via video.");
                                                                  }
                                                                } else {
                                                                  showToastMessage("To maintain high-quality care, a new video appointment is required each time you want to consult via video.");
                                                                }
                                                              } else if (i == 2) {
                                                                if (doctorDetailController.doctorDetailModel!.doctor!.chatCheck == 1) {
                                                                  Get.to(ChatScreen());
                                                                } else {
                                                                  showToastMessage("Just book once, and chat support with your doctor will always be available for follow-ups or questions.");
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            padding: EdgeInsets.all(5),
                                                            decoration: BoxDecoration(
                                                              color: WhiteColor,
                                                              shape: BoxShape.circle,
                                                              image: doctorDetailController.isLoading
                                                                  ? DecorationImage(
                                                                image: AssetImage("assets/ezgif.com-crop.gif"),
                                                                fit: BoxFit.cover,
                                                              )
                                                                  : null,
                                                            ),
                                                            child: doctorDetailController.isLoading ? SizedBox() : Center(child: SvgPicture.asset(iconList[i])),
                                                          ),
                                                        ),
                                                        if (i != iconList.length - 1) ...[Container(width: 5)],
                                                      ],
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Expanded(
                                                    child: GridView.builder(
                                                      itemCount: bottomIcon.length,
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 5,
                                                        mainAxisSpacing: 5,
                                                        // --- FIX 2: Increased Extent so text fits ---
                                                        mainAxisExtent: doctorDetailController.isLoading ? 29 : 45,
                                                      ),
                                                      itemBuilder:(context, index) {
                                                        return Container(
                                                          padding: EdgeInsets.all(3),
                                                          decoration: BoxDecoration(
                                                            color: WhiteColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                            image: doctorDetailController.isLoading
                                                                ? DecorationImage(
                                                              image: AssetImage("assets/ezgif.com-crop.gif"),
                                                              fit: BoxFit.cover,
                                                            )
                                                                : null,
                                                          ),
                                                          child: doctorDetailController.isLoading
                                                              ? SizedBox()
                                                              : Row(
                                                            children: [
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                padding: EdgeInsets.all(4),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.grey.shade100,
                                                                ),
                                                                child: SvgPicture.asset(bottomIcon[index]),
                                                              ),
                                                              SizedBox(width: 3),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "${bottomTitle[index]}",
                                                                      style: TextStyle(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        fontFamily: FontFamily.gilroyBold,
                                                                        fontSize: 9,
                                                                        color: greytext,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 3),
                                                                    Text(
                                                                      index == 0
                                                                          ? "${doctorDetailController.doctorDetailModel!.doctor!.yearOfExperience}+ ${"Years".tr}"
                                                                          : index == 1
                                                                          ? "${doctorDetailController.doctorDetailModel!.doctor!.avgStar!.toStringAsFixed(1)}(${doctorDetailController.doctorDetailModel!.doctor!.totReview})"
                                                                          : index == 2
                                                                          ? "${getData.read("currency")}${doctorDetailController.doctorDetailModel!.doctor!.minInpPrice} - ${getData.read("currency")}${doctorDetailController.doctorDetailModel!.doctor!.maxInpPrice}"
                                                                          : "${getData.read("currency")}${doctorDetailController.doctorDetailModel!.doctor!.minVidPrice} - ${getData.read("currency")}${doctorDetailController.doctorDetailModel!.doctor!.maxVidPrice}",
                                                                      style: TextStyle(
                                                                        fontFamily: FontFamily.gilroyBold,
                                                                        fontSize: 10,
                                                                        color: BlackColor,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: SizedBox(),
                                          ),
                                        ),
                                        // --- FIX END ---
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              titlePadding: EdgeInsets.zero,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Browse by Specialties".tr,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              clipBehavior: Clip.none,
                                              physics: BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  for (int i = 0; i < (doctorDetailController.isLoading ? 3 : doctorDetailController.doctorDetailModel!.depSubSerList!.length); i++) ...[
                                                    InkWell(
                                                      onTap: () {
                                                        if (doctorDetailController.isLoading == false) {
                                                          setState(() {
                                                            debugPrint("----------index-------- $i");
                                                            currentIndex = i;
                                                            serviceisLoading = true;
                                                            setState(() {});
                                                            daysIndex = 0;
                                                            selectedTime = null;
                                                            selectedSession = null;
                                                            selectedHid = null;
                                                            timeSlotController.timeSlotApi(
                                                              doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                                                              date: "${doctorDetailController.doctorDetailModel!.alldate![currentIndex].date}",
                                                              departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].departmentId}",
                                                              hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].hospitalId}",
                                                            ).then((value) {
                                                              setState(() {
                                                                serviceisLoading = false;
                                                              });
                                                            });
                                                            doctorDetailController.showType = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].showType}";
                                                            doctorDetailController.priceChange = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].showType}";
                                                            doctorDetailController.inPersonPrice = int.parse("${doctorDetailController.doctorDetailModel!.depSubSerList![i].clientVisitPrice}");
                                                            doctorDetailController.videoPrice = int.parse("${doctorDetailController.doctorDetailModel!.depSubSerList![i].videoConsultPrice}");
                                                            doctorDetailController.subDepartmentId = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].id}";
                                                            doctorDetailController.selectTab = doctorDetailController.showType == "1" ? 0 : doctorDetailController.showType == "2" ? 1 : 0;
                                                            debugPrint("---------- inPersonPrice ----------- ${doctorDetailController.inPersonPrice}");
                                                            debugPrint("----------- priceChange ------------ ${doctorDetailController.priceChange}");
                                                            debugPrint("------------ videoPrice ------------ ${doctorDetailController.videoPrice}");
                                                            debugPrint("------------ showType -------------- ${doctorDetailController.showType}");
                                                            debugPrint("--------- subDepartmentId ---------- ${doctorDetailController.subDepartmentId}");
                                                            debugPrint("------------ selectTab ------------- ${doctorDetailController.selectTab}");
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: doctorDetailController.isLoading ? 45 : null,
                                                        width: doctorDetailController.isLoading ? Get.width / 2 : null,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          color: WhiteColor,
                                                          border: Border.all(
                                                            color: doctorDetailController.isLoading
                                                                ? Colors.transparent
                                                                : (currentIndex == i
                                                                ? primeryColor
                                                                : greycolor.withOpacity(0.2)),
                                                          ),
                                                          image: doctorDetailController.isLoading
                                                              ? DecorationImage(
                                                            image: AssetImage("assets/ezgif.com-crop.gif"),
                                                            fit: BoxFit.cover,
                                                          )
                                                              : null,
                                                        ),
                                                        child: doctorDetailController.isLoading
                                                            ? SizedBox()
                                                            : Row(
                                                          children: [
                                                            Container(
                                                              height: 35,
                                                              width: 35,
                                                              decoration: BoxDecoration(
                                                                color: WhiteColor,
                                                                border: Border.all(color: greycolor.withOpacity(0.2)),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(9),
                                                                child: FadeInImage.assetNetwork(
                                                                  placeholder: "assets/ezgif.com-crop.gif",
                                                                  placeholderCacheWidth: 35,
                                                                  placeholderCacheHeight: 35,
                                                                  image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.depSubSerList![i].image}",
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              "${doctorDetailController.doctorDetailModel!.depSubSerList![i].subTitle}",
                                                              style: TextStyle(
                                                                fontFamily: FontFamily.gilroyBold,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (i != (doctorDetailController.isLoading ? 3 : doctorDetailController.doctorDetailModel!.depSubSerList!.length) - 1) ...[SizedBox(width: 10)],
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Availability".tr,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: doctorDetailController.isLoading || serviceisLoading ? WhiteColor : bgcolor,
                                                  border: Border.all(color: doctorDetailController.isLoading || serviceisLoading ? bordercolor : transparent),
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: doctorDetailController.isLoading || serviceisLoading
                                                    ? Row(
                                                  children: [
                                                    for(int i = 0; i < 2; i++)...[
                                                      Expanded(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                              color: WhiteColor,
                                                              borderRadius: BorderRadius.circular(35),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(35),
                                                              child: Image.asset(
                                                                "assets/ezgif.com-crop.gif",
                                                                height: 45,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                      if(i == 0)...[SizedBox(width: 10)],
                                                    ],
                                                  ],
                                                )
                                                    : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    if (doctorDetailController.showType == "1" || doctorDetailController.showType == "3")...[
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              doctorDetailController.selectTab = 0;
                                                              doctorDetailController.priceChange = "1";
                                                              serviceType = "1";
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: doctorDetailController.selectTab == 0
                                                                  ? WhiteColor
                                                                  : bgcolor,
                                                              borderRadius: BorderRadius.circular(35),
                                                            ),
                                                            padding: EdgeInsets.symmetric(vertical: 12),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/user-rectangle.svg",
                                                                  color: doctorDetailController.selectTab == 0
                                                                      ? primeryColor
                                                                      : greyColor,
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "In Person".tr,
                                                                  style: TextStyle(
                                                                    color: doctorDetailController.selectTab == 0
                                                                        ? primeryColor
                                                                        : greyColor,
                                                                    fontFamily: FontFamily.gilroyBold,
                                                                    fontSize:
                                                                    13,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ], // Show only for show_type 1 and 3
                                                    if (doctorDetailController.showType == "2" || doctorDetailController.showType == "3")...[
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              doctorDetailController.selectTab = 1;
                                                              doctorDetailController.priceChange = "2";
                                                              serviceType = "2";
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: doctorDetailController.selectTab == 1
                                                                  ? WhiteColor
                                                                  : bgcolor,
                                                              borderRadius: BorderRadius.circular(35),
                                                            ),
                                                            padding: EdgeInsets.symmetric(vertical: 12),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/camera_video.svg",
                                                                  color: doctorDetailController.selectTab == 1
                                                                      ? primeryColor
                                                                      : greyColor,
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "Video Visit".tr,
                                                                  style: TextStyle(
                                                                    color: doctorDetailController.selectTab == 1
                                                                        ? primeryColor
                                                                        : greyColor,
                                                                    fontFamily: FontFamily.gilroyBold,
                                                                    fontSize: 13,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ], // Show only for show_type 12 and 3
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    physics: BouncingScrollPhysics(),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          for (int i = 0; i < (doctorDetailController.isLoading || serviceisLoading ? 4 : doctorDetailController.doctorDetailModel!.alldate!.length); i++) ...[
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (doctorDetailController.isLoading || serviceisLoading == false) {
                                                                  setState(() {
                                                                    daysIndex = i;
                                                                    doctorDetailController.timeSelected = "${doctorDetailController.doctorDetailModel!.alldate![i].date}";
                                                                  });
                                                                  await timeSlotController.timeSlotApi(
                                                                    doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                                                                    date: "${doctorDetailController.doctorDetailModel!.alldate![i].date}",
                                                                    departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].departmentId}",
                                                                    hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].hospitalId}",
                                                                  );
                                                                  setState(() {});
                                                                }
                                                              },
                                                              child: Container(
                                                                height: doctorDetailController.isLoading || serviceisLoading ? 60 : null,
                                                                width: doctorDetailController.isLoading || serviceisLoading ? 100 : null,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: doctorDetailController.isLoading || serviceisLoading
                                                                        ? transparent
                                                                        : (daysIndex == i
                                                                        ? primeryColor
                                                                        : Colors.grey.shade200),
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: doctorDetailController.isLoading || serviceisLoading
                                                                      ? transparent
                                                                      : (daysIndex == i
                                                                      ? primeryColor
                                                                      : WhiteColor),
                                                                  image: doctorDetailController.isLoading || serviceisLoading
                                                                      ? DecorationImage(
                                                                    image: AssetImage("assets/ezgif.com-crop.gif"),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                      : null,
                                                                ),
                                                                child: doctorDetailController.isLoading || serviceisLoading
                                                                    ? SizedBox()
                                                                    : Padding(
                                                                  padding: EdgeInsets.symmetric( vertical: 8.0, horizontal: 15),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${doctorDetailController.doctorDetailModel!.alldate![i].date}".tr,
                                                                        style: TextStyle(
                                                                          color: daysIndex == i
                                                                              ? WhiteColor
                                                                              : BlackColor,
                                                                          fontFamily: FontFamily.gilroyBold,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 1),
                                                                      Text(
                                                                        "${doctorDetailController.doctorDetailModel!.alldate![i].weekDay}".tr,
                                                                        style: TextStyle(
                                                                          color: daysIndex == i
                                                                              ? WhiteColor
                                                                              : BlackColor,
                                                                          fontFamily: FontFamily.gilroyBold,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (i != (doctorDetailController.isLoading ? 4 : doctorDetailController.doctorDetailModel!.alldate!.length) - 1) ...[SizedBox(width: 8)],
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GetBuilder<TimeSlotController>(
                                          builder: (timeSlotController) {
                                            return timeSlotController.isLoading
                                                ? Container(
                                              width: Get.width,
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: WhiteColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.asset(
                                                        "assets/ezgif.com-crop.gif",
                                                        width: Get.width / 3,
                                                        height: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width: Get.width,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: 15,
                                                      padding: EdgeInsets.zero,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4,
                                                        mainAxisSpacing: 8,
                                                        crossAxisSpacing: 8,
                                                        mainAxisExtent: 50,
                                                      ),
                                                      itemBuilder: (context, index) {
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: Image.asset(
                                                            "assets/ezgif.com-crop.gif",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : inPerson();
                                          }
                                      ),
                                      selectedTime == null
                                          ? SizedBox(height: 0)
                                          : SizedBox(height: 90),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      doctorDetailController.isLoading ? SizedBox() : hospitalDetail(),
                    ],
                  );
                }
            ),
          );
        },
      ),
    );
  }

  Widget inPerson() {
    return Column(
      children: [
        timeSlot(
          day: "Morning".tr,
          image: "assets/cloud-sun.svg",
          color: yelloColor,
          list: timeSlotController.timeSlotModel!.ndatelist.morning,
          session: "Morning",
          selectedSession: selectedSession,
          selectedTime: selectedTime,
          onItemTap: toggleSelection,
        ),
        timeSlot(
          day: "Afternoon".tr,
          image: "assets/sun.svg",
          color: orangeColor,
          list: timeSlotController.timeSlotModel!.ndatelist.afternoon,
          session: "Afternoon",
          selectedSession: selectedSession,
          selectedTime: selectedTime,
          onItemTap: toggleSelection,
        ),
        timeSlot(
          day: "Evening".tr,
          image: "assets/half_moon.svg",
          color: Colors.indigo,
          list: timeSlotController.timeSlotModel!.ndatelist.evening,
          session: "Evening",
          selectedSession: selectedSession,
          selectedTime: selectedTime,
          onItemTap: toggleSelection,
        ),
      ],
    );
  }

  void toggleSelection(String session, String time, String hid) {
    setState(() {
      if (selectedSession == session && selectedTime == time) {
        // Deselect if clicking again
        selectedSession = null;
        selectedTime = null;
        selectedHid = null;
      } else {
        // Update selected values
        selectedSession = session;
        selectedTime = time;
        selectedHid = hid;

        debugPrint(":-------TIME+++++++++++++++ $selectedTime");
        debugPrint("===========DAY++++++++++++++ $selectedSession");
      }
    });

    debugPrint("Selected HID: $selectedHid"); // Debugging purpose
  }

  Widget timeSlot({
    required String day,
    required String image,
    required Color color,
    required List list,
    required String session,
    final String? selectedSession,
    final String? selectedTime,
    required Function(String, String, String) onItemTap,
  }) {
    return GetBuilder<DoctorDetailController>(
      builder: (context) {
        return doctorDetailController.isLoading
            ? SizedBox()
            : list.isEmpty
            ? SizedBox()
            : Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SvgPicture.asset(image, color: color),
                        SizedBox(width: 5),
                        Text(
                          day.tr,
                          style: TextStyle(
                            color: BlackColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: Get.width,
                    color: Colors.grey.shade200,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 50,
                      ),
                      itemBuilder: (context, index) {
                        String time = list[index].t;
                        String hid = list[index].hid;
                        String bookStatus = list[index].o.toString();
                        bool isSelected = selectedSession == session && selectedTime == time;
                        List<String> timeParts = list[index].t.split(" ");
                        String timeValue = timeParts[0];
                        String timePeriod = timeParts.length > 1 ? timeParts[1] : "";

                        Color bgColor;
                        Color borderColor;
                        Color textColor;

                        if (bookStatus == "0") {
                          bgColor = Colors.red.shade100; // Blocked slot
                          borderColor = Colors.red;
                          textColor = Colors.red;
                        } else if (bookStatus == "1") {
                          bgColor = isSelected
                              ? primeryColor.withOpacity(0.2)
                              : WhiteColor; // Normal selectable slot
                          borderColor = isSelected
                              ? primeryColor
                              : Colors.grey.shade200;
                          textColor = isSelected ? primeryColor : BlackColor;
                        } else if (bookStatus == "2") {
                          bgColor = Colors.grey.shade200; // Already booked slot
                          borderColor = Colors.grey;
                          textColor = Colors.grey;
                        } else {
                          bgColor = WhiteColor;
                          borderColor = Colors.grey.shade200;
                          textColor = BlackColor;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (bookStatus == "0") {
                              Fluttertoast.showToast(msg: "You cannot book this time".tr);
                            } else if (bookStatus == "1") {
                              onItemTap(session, time, hid);
                            } else if (bookStatus == "2") {
                              Fluttertoast.showToast(msg: "This time is already book".tr);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  timeValue.tr,
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  timePeriod,
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String? hospitalID = "";

  var selectedHospital;

  Widget hospitalDetail() {
    selectedHospital = doctorDetailController.doctorDetailModel!.hospitalList!.firstWhereOrNull((hospital) => hospital.id.toString() == selectedHid);
    hospitalID = doctorDetailController.doctorDetailModel!.hospitalList!.firstWhereOrNull((hospital) => hospital.id.toString() == selectedHid)?.id.toString();

    if (selectedHospital == null) return SizedBox();
    return Positioned(
      bottom: -10,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primeryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 18,
                  child: SvgPicture.asset(
                    "assets/hospital.svg",
                    color: WhiteColor,
                  ),
                ),
                Text(
                  "Clinic Details".tr,
                  style: TextStyle(
                    color: WhiteColor,
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "${selectedHospital.name}".tr,
              style: TextStyle(
                color: WhiteColor,
                fontFamily: FontFamily.gilroyBold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "${selectedHospital.address}".tr,
              style: TextStyle(
                color: WhiteColor,
                fontFamily: FontFamily.gilroyBold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}