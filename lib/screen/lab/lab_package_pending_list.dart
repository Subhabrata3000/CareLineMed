// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/lab_booking_list_controller.dart';
import 'package:laundry/controller_doctor/appint_cancel_reson_list_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/lab/lab_booking_details_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/custom_title.dart';

class LabPackagePendingList extends StatefulWidget {
  const LabPackagePendingList({super.key});

  @override
  State<LabPackagePendingList> createState() => _LabPackagePendingListState();
}

class _LabPackagePendingListState extends State<LabPackagePendingList> {
  LabBookingListController labBookingListController = Get.put(LabBookingListController());

  AppintCancelResonListController appintCancelResonListController = Get.put(AppintCancelResonListController());

  @override
  void initState() {
    appintCancelResonListController.appintCancelResonListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return labBookingListController.labBookingListModel!.labPendingList!.isEmpty
        ? Center(
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
                SizedBox(height: 10),
                Text(
                  "No Booking placed!".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 5),
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
        : ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(15),
            itemCount: labBookingListController.labBookingListModel!.labPendingList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(LabBookingDetailsScreen(labBookId: "${labBookingListController.labBookingListModel!.labPendingList![index].id}"));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
                              "${"Appointment Id".tr} : ${labBookingListController.labBookingListModel!.labPendingList![index].id}",
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
                              color: "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Pending"
                                ? yelloColor.withOpacity(0.1)
                                : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Accepted"
                                  ? orangeColor.withOpacity(0.1)
                                  : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Assign Collector"
                                    ? blueColor.withOpacity(0.1)
                                    : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Ongoing"
                                      ? Darkblue2.withOpacity(0.1)
                                      : green1Color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}",
                              style: TextStyle(
                                color: "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Pending"
                                  ? yelloColor
                                  : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Accepted"
                                    ? orangeColor
                                    : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Assign Collector"
                                      ? blueColor
                                      : "${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Ongoing"
                                          ? Darkblue2
                                          : green1Color,
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
                                  "${labBookingListController.labBookingListModel!.labPendingList![index].name}",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyExtraBold,
                                    fontSize: 15,
                                    color: BlackColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      child: Image.asset(
                                        "assets/calendar1.png",
                                        color: greycolor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        "${labBookingListController.labBookingListModel!.labPendingList![index].date} ",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 12.5,
                                          color: greycolor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${labBookingListController.currency}${labBookingListController.labBookingListModel!.labPendingList![index].totPrice!.toStringAsFixed(2)}",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: primeryColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FadeInImage.assetNetwork(
                                fadeInCurve: Curves.easeInCirc,
                                placeholder: "assets/ezgif.com-crop.gif",
                                placeholderCacheHeight: 70,
                                placeholderCacheWidth: 70,
                                placeholderFit: BoxFit.cover,
                                image: "${Config.imageBaseurlDoctor}${labBookingListController.labBookingListModel!.labPendingList![index].labLogo}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          if("${labBookingListController.labBookingListModel!.labPendingList![index].statusType}" == "Pending")...[
                            Expanded(
                              child: labBookingListController.buttons(
                                onTap: () {ticketCancel("${labBookingListController.labBookingListModel!.labPendingList![index].id}");},
                                buttonText: "Cancel".tr,
                                buttonColor: RedColor,
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                          Expanded(
                            child: labBookingListController.buttons(
                              onTap: () {
                                makingPhoneCall(context, number: "${labBookingListController.labBookingListModel!.labPendingList![index].phone}");
                              },
                              buttonText: "Call".tr,
                              buttonIcon: "assets/Call.svg",
                              buttonColor: gradient.defoultColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 10),
          );
  }

  ticketCancel(orderId) {
    labBookingListController.reasonmsg = "";
    labBookingListController.reasonId = "";
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: WhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return GetBuilder<AppintCancelResonListController>(
            builder: (appintCancelResonListController) {
              return appintCancelResonListController.isLoading
              ? Center(child: CircularProgressIndicator(color: primeryColor))
              :StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: Get.height * 0.02),
                        Container(
                          height: 6,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Text(
                          "Select Reason".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gilroy Bold',
                            color: BlackColor,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Text(
                          "${"Please select the reason for cancellation".tr}:",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy Medium',
                            color: BlackColor,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        ListView.builder(
                          itemCount: appintCancelResonListController.appintCancelResonListModel!.cancelReason!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {
                                labBookingListController.reasonmsg = "${appintCancelResonListController.appintCancelResonListModel!.cancelReason![i].title}";
                                labBookingListController.reasonId = "${appintCancelResonListController.appintCancelResonListModel!.cancelReason![i].id}";
                                setState((){});
                                debugPrint("=============== reasonmsg ============= ${labBookingListController.reasonmsg}");
                                debugPrint("================ reasonId ============= ${labBookingListController.reasonId}");
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
                                      value: labBookingListController.reasonmsg == "${appintCancelResonListController.appintCancelResonListModel!.cancelReason![i].title}" ? true : false,
                                      groupValue: true,
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        "${appintCancelResonListController.appintCancelResonListModel!.cancelReason![i].title}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Gilroy Medium',
                                          color: BlackColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        labBookingListController.reasonmsg == "Other"
                            ? SizedBox(
                                height: 50,
                                width: Get.width * 0.85,
                                child: TextField(
                                  controller: labBookingListController.cancelNotController,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
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
                            SizedBox(
                              width: Get.width * 0.35,
                              height: Get.height * 0.05,
                              child: ticketButton(
                                title: "Confirm".tr,
                                gradient1: gradient.btnGradient,
                                titleColor: Colors.white,
                                ontap: () {
                                  labBookingListController.labBookingCancelApi(
                                    labBookId: orderId,
                                    reasonId: labBookingListController.reasonId,
                                    reason: labBookingListController.reasonmsg == "Other" ? labBookingListController.reasonmsg : "",
                                  ).then((value) {
                                    if (value["Result"] == true) {
                                      Get.back();
                                      labBookingListController.labBookingListApi();
                                    } 
                                  });
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
            }
          );
        },
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
