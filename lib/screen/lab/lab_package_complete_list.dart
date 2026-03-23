// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller/lab_booking_list_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/lab/lab_booking_details_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/widget/custom_title.dart';

class LabPackageCompleteList extends StatefulWidget {
  const LabPackageCompleteList({super.key});

  @override
  State<LabPackageCompleteList> createState() => _LabPackageCompleteListState();
}

class _LabPackageCompleteListState extends State<LabPackageCompleteList> {
  LabBookingListController labBookingListController = Get.put(LabBookingListController());
  @override
  Widget build(BuildContext context) {
    return labBookingListController.labBookingListModel!.labCompleteList!.isEmpty
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
            itemCount: labBookingListController.labBookingListModel!.labCompleteList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                   Get.to(LabBookingDetailsScreen(
                     labBookId: "${labBookingListController.labBookingListModel!.labCompleteList![index].id}",
                     labName: "${labBookingListController.labBookingListModel!.labCompleteList![index].name}",
                     date: "${labBookingListController.labBookingListModel!.labCompleteList![index].date}",
                     price: "${labBookingListController.labBookingListModel!.labCompleteList![index].totPrice}",
                     status: "${labBookingListController.labBookingListModel!.labCompleteList![index].statusType}",
                     logo: "${labBookingListController.labBookingListModel!.labCompleteList![index].labLogo}",
                   ));
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
                              "${"Appointment Id".tr} : ${labBookingListController.labBookingListModel!.labCompleteList![index].id}",
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
                              color: "${labBookingListController.labBookingListModel!.labCompleteList![index].statusType}" == "Completed"
                                ? green1Color.withOpacity(0.1)
                                : RedColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "${labBookingListController.labBookingListModel!.labCompleteList![index].statusType}",
                              style: TextStyle(
                                color: "${labBookingListController.labBookingListModel!.labCompleteList![index].statusType}" == "Completed"
                                  ? green1Color
                                  : RedColor,
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
                                  "${labBookingListController.labBookingListModel!.labCompleteList![index].name}",
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
                                        "${labBookingListController.labBookingListModel!.labCompleteList![index].date} ",
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
                                  "${labBookingListController.currency}${labBookingListController.labBookingListModel!.labCompleteList![index].totPrice!.toStringAsFixed(2)}",
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
                                image: "${Config.imageBaseurlDoctor}${labBookingListController.labBookingListModel!.labCompleteList![index].labLogo}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: labBookingListController.buttons(
                              onTap: () {
                                makingPhoneCall(context, number: "${labBookingListController.labBookingListModel!.labCompleteList![index].phone}");
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
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
          );
  }
}
