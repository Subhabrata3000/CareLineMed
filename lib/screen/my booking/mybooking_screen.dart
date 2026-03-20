// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/screen/my%20booking/booking_detail_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/book_list_controller.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';
import '../../utils/customwidget.dart';
import '../chat/message.dart';


class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final note = TextEditingController();
  var selectedRadioTile;
  String? rejectmsg = '';

  BookListController bookListController = Get.put(BookListController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    bookListController.bookListApi();
    super.initState();
    _tabController?.index == 0;
    if (_tabController?.index == 0) {
    }
  }

  @override
  void dispose() {
    super.dispose();
    bookListController.isLoading = false;
    _tabController?.dispose();
  }

  Future<void> _makingPhoneCall({required String number}) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "My Booking".tr,
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
              color: Colors.white,
              // borderRadius: BorderRadius.circular(8),
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
                  labelColor: gradient.defoultColor,
                  onTap: (value) {
                    if (value == 0) {
                    } else {
                    }
                  },
                  tabs: [
                    Tab(text: "Current Booking".tr),
                    Tab(text: "Past Booking".tr),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                currentOrder(),
                pastOrder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget currentOrder() {
    return GetBuilder<BookListController>(builder: (bookListController) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: bookListController.isLoading
            ? bookListController.bookListModel!.pendingAppointList.isNotEmpty
                ? ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: bookListController.bookListModel!.pendingAppointList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Get.to(BookingDetailScreen(appointmentId: bookListController.bookListModel!.pendingAppointList[index].id.toString()));
                          });
                        },
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${"Appointment Id".tr} : ${bookListController.bookListModel!.pendingAppointList[index].id}",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                        color: primeryColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: bookListController.bookListModel!.pendingAppointList[index].statusType == "Pending"
                                          ? yelloColor.withOpacity(0.1)
                                          : bookListController.bookListModel!.pendingAppointList[index].statusType == "Service Start"
                                            ? orangeColor.withOpacity(0.1)
                                            : bookListController.bookListModel!.pendingAppointList[index].statusType == "Service End"
                                                ? gradient.defoultColor.withOpacity(0.1)
                                                : null,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(
                                      bookListController.bookListModel!.pendingAppointList[index].statusType,
                                      style: TextStyle(
                                        color: bookListController.bookListModel!.pendingAppointList[index].statusType == "Pending"
                                            ? yelloColor
                                            : bookListController.bookListModel!.pendingAppointList[index].statusType == "Service Start"
                                              ? orangeColor
                                              : bookListController.bookListModel!.pendingAppointList[index].statusType == "Service End"
                                                ? gradient.defoultColor
                                                : null,
                                        fontFamily: FontFamily.gilroyBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookListController.bookListModel!.pendingAppointList[index].docTitle,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily:
                                            FontFamily.gilroyExtraBold,
                                            fontSize: 15,
                                            color: BlackColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          bookListController.bookListModel!.pendingAppointList[index].departName,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 14,
                                            color: greycolor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              child: Image.asset(
                                                "assets/calendar1.png",
                                                color: greycolor,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Flexible(
                                              child: Text(
                                                "${bookListController.bookListModel!.pendingAppointList[index].appointmentDate}, ${bookListController.bookListModel!.pendingAppointList[index].appointmentTime} ",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily:
                                                  FontFamily.gilroyBold,
                                                  fontSize: 12.5,
                                                  color: greycolor,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        bookListController.bookListModel!.pendingAppointList[index].showType != "1"
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: SvgPicture.asset(
                                                      "assets/camera_video.svg",
                                                      color: primeryColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Video visit".tr,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      FontFamily.gilroyBold,
                                                      fontSize: 12.5,
                                                      color: primeryColor,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: SvgPicture.asset(
                                                      "assets/user-rectangle.svg",
                                                      color: primeryColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "In-person".tr,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      FontFamily.gilroyBold,
                                                      fontSize: 12.5,
                                                      color: primeryColor,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FadeInImage.assetNetwork(
                                        fadeInCurve: Curves.easeInCirc,
                                        placeholder:
                                        "assets/ezgif.com-crop.gif",
                                        placeholderCacheHeight: 70,
                                        placeholderCacheWidth: 70,
                                        placeholderFit: BoxFit.cover,
                                        image: "${Config.imageBaseurlDoctor}${bookListController.bookListModel!.pendingAppointList[index].docLogo}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: button(image: "assets/chat-text.svg", title: "Message".tr,onTap: (){
                                    Get.to(MessageScreen(userImage:  bookListController.bookListModel!.pendingAppointList[index].docLogo,username: bookListController.bookListModel!.pendingAppointList[index].name, receiverId: bookListController.bookListModel!.pendingAppointList[index].did.toString(), senderId: getData.read("UserLogin")["id"].toString()));
                                  })),
                                  SizedBox(width: 15),
                                  Expanded(child: button(image: "assets/Call.svg", title: "Call doctor".tr,onTap: (){
                                    setState(() {
                                      _makingPhoneCall(number: "${bookListController.bookListModel!.pendingAppointList[index].countryCode}${bookListController.bookListModel!.pendingAppointList[index].phone}");
                                    });
                                  })),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Booking placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any Booking.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
      );
    });
  }

  Widget pastOrder() {
    Get.put(BookListController());
    return GetBuilder<BookListController>(builder: (bookListController) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: bookListController.isLoading
            ? bookListController.bookListModel!.completeAppointList.isNotEmpty
                ? ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: bookListController.bookListModel!.completeAppointList.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  Get.to(BookingDetailScreen(appointmentId: bookListController.bookListModel!.completeAppointList[index].id.toString(),));
                });
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${"Appointment Id".tr} : ${bookListController.bookListModel!.completeAppointList[index].id}",
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 14,
                              color: primeryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: bookListController.bookListModel!.completeAppointList[index].statusType == "Canceled"
                                ? RedColor.withOpacity(0.1)
                                : bookListController.bookListModel!.completeAppointList[index].statusType == "Completed"
                                  ? green1Color.withOpacity(0.1)
                                  : null,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Text(
                            bookListController.bookListModel!.completeAppointList[index].statusType,
                            style: TextStyle(
                              color: bookListController.bookListModel!.completeAppointList[index].statusType == "Canceled"
                                  ? RedColor
                                  : bookListController.bookListModel!.completeAppointList[index].statusType == "Completed"
                                    ? green1Color
                                    : null,
                              fontFamily: FontFamily.gilroyBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookListController.bookListModel!.completeAppointList[index].docTitle,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyExtraBold,
                                  fontSize: 15,
                                  color: BlackColor,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                bookListController.bookListModel!.completeAppointList[index].departName,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyBold,
                                  fontSize: 14,
                                  color: greycolor,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Image.asset(
                                      "assets/calendar1.png",
                                      color: greycolor,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      "${bookListController.bookListModel!.completeAppointList[index].appointmentDate}, ${bookListController.bookListModel!.completeAppointList[index].appointmentTime}",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily:
                                        FontFamily.gilroyBold,
                                        fontSize: 12.5,
                                        color: greycolor,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              bookListController.bookListModel!.completeAppointList[index].showType != "1"
                                  ? Row(
                                children: [
                                  SizedBox(
                                      height: 20,
                                      child: SvgPicture.asset("assets/camera_video.svg",color: primeryColor)),
                                  SizedBox(width: 5),
                                  Text(
                                    "Video visit".tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily:
                                      FontFamily.gilroyBold,
                                      fontSize: 12.5,
                                      color: primeryColor,
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                                  : Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: SvgPicture.asset(
                                      "assets/user-rectangle.svg",
                                      color: primeryColor,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "In-person".tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily:
                                      FontFamily.gilroyBold,
                                      fontSize: 12.5,
                                      color: primeryColor,
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.assetNetwork(
                              fadeInCurve: Curves.easeInCirc,
                              placeholder:
                              "assets/ezgif.com-crop.gif",
                              placeholderCacheHeight: 70,
                              placeholderCacheWidth: 70,
                              placeholderFit: BoxFit.cover,
                              image: "${Config.imageBaseurlDoctor}${bookListController.bookListModel!.completeAppointList[index].docLogo}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: button(image: "assets/chat-text.svg", title: "Message".tr,onTap: (){
                          Get.to(MessageScreen(userImage: bookListController.bookListModel!.completeAppointList[index].docLogo, username: bookListController.bookListModel!.completeAppointList[index].name, receiverId: bookListController.bookListModel!.completeAppointList[index].did.toString(), senderId: getData.read("UserLogin")["id"].toString()));
                        })),
                        SizedBox(width: 15),
                        Expanded(child: button(image: "assets/Call.svg", title: "Call doctor".tr,onTap: (){
                          setState(() {
                            _makingPhoneCall(number: "${bookListController.bookListModel!.completeAppointList[index].countryCode}${bookListController.bookListModel!.completeAppointList[index].phone}");
                          });
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Booking placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any Booking.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
      );
    });
  }

  ticketCancel(orderId) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: WhiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Select Reason".tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: FontFamily.gilroyBold,
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "${"Please select the reason for cancellation".tr} : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: FontFamily.gilroyMedium,
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            setState(() {});
                            selectedRadioTile = i;
                            rejectmsg = cancelList[i]["title"];
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Radio(
                                  activeColor: gradient.defoultColor,
                                  value: i,
                                  groupValue: selectedRadioTile,
                                  onChanged: (value) {
                                    setState(() {});
                                    selectedRadioTile = value;
                                    rejectmsg = cancelList[i]["title"];
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  cancelList[i]["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Medium',
                                    color: BlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    rejectmsg == "Others".tr
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  hintText: 'Enter reason'.tr,
                                  hintStyle: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: Get.size.height / 55,
                                      color: Colors.grey)),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketButton(
                            title: "Cancel".tr,
                            bgColor: RedColor,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          },
          );
        },
    );
  }

  List cancelList = [
    {"id": 1, "title": "Financing fell through".tr},
    {"id": 2, "title": "Inspection issues".tr},
    {"id": 3, "title": "Change in financial situation".tr},
    {"id": 4, "title": "Title issues".tr},
    {"id": 5, "title": "Seller changes their mind".tr},
    {"id": 6, "title": "Competing offer".tr},
    {"id": 7, "title": "Personal reason".tr},
    {"id": 8, "title": "Others".tr},
  ];

  Widget button({required void Function() onTap,required String image,required String title}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
                child: SvgPicture.asset(image)),
            SizedBox(width: 3),
            Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontFamily:
                FontFamily.gilroyBold,
                fontSize: 15,
                color: BlackColor,
                overflow:
                TextOverflow.ellipsis,
              ),
            ),

          ],
        ),
      ),
    );
  }

  ticketButton({Function()? ontap, String? title, Color? bgColor, titleColor, Gradient? gradient1}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient1,
          borderRadius: (BorderRadius.circular(18)),
        ),
        child: Center(
          child: Text(title!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontFamily: 'Gilroy Medium',
            ),
          ),
        ),
      ),
    );
  }

}

