// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller_doctor/cart_detail_controller.dart';
import 'package:laundry/controller_doctor/succesee_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/my%20booking/booking_detail_screen.dart';
import 'package:laundry/screen/my%20booking/mybooking_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/button.dart';
import 'package:lottie/lottie.dart';

  SucceseeControllerController succeseeControllerController = Get.put(SucceseeControllerController());

Future successFully({
  required String appointmentID}) {
  CartDetailController cartDetailController = Get.put(CartDetailController());

  succeseeControllerController.successApiDoctor(
    appointmentId: appointmentID,
  );
  return Get.bottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    GetBuilder<SucceseeControllerController>(
      builder: (succeseeControllerController) {
        return succeseeControllerController.isLoading
            ? StatefulBuilder(
                builder: (context, setState) {
                  final String base64Image = succeseeControllerController.succeseeApiModel!.qrcode;
    
                  final String cleanedBase64 = base64Image.split(",").last;
    
                  Uint8List bytes = base64Decode(cleanedBase64);
                  return PopScope(
                    canPop: false,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      child: Scaffold(
                        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                        floatingActionButton: Padding(
                          padding: const EdgeInsets.all(10),
                          child: button(
                            text: "View Booking".tr,
                            color: primeryColor,
                            onPress: () {
                              cartDetailController.changeIndex(4);
                              setState(() {});
                              Get.offAll(BottomBarScreen());
                              Get.to(MyBookingScreen());
                              cartDetailController.addresTitle = "";
                            },
                          ),
                        ),
                        backgroundColor: bgcolor,
                        body: Stack(
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 65),
                              physics: BouncingScrollPhysics(),
                              clipBehavior: Clip.none,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Lottie.asset(
                                        "assets/lotties/Successfullysecounde.json",
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "You have successfully booking".tr,
                                      style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: FontFamily.gilroyExtraBold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      "${succeseeControllerController.succeseeApiModel?.appointData.bookDate}".tr,
                                      style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: FontFamily.gilroyMedium,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(child: Image.memory(bytes)),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.4),
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/ticket.svg",
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Booking Fee".tr,
                                              style: TextStyle(
                                                color: textcolor,
                                                fontSize: 18,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.totPrice}",
                                              style: TextStyle(
                                                color: textcolor,
                                                fontSize: 18,
                                                fontFamily: FontFamily.gilroyExtraBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(color: Colors.grey, height: 3),
                                        SizedBox(height: 10),
                                        bookingFeeText(title: "${"Clinic name".tr} : ", subtitle: "${succeseeControllerController.succeseeApiModel?.appointData.hospitalName}"),
                                        SizedBox(height: 10),
                                        bookingFeeText(title: "${"Department name".tr} : ", subtitle: "${succeseeControllerController.succeseeApiModel?.appointData.departmentName}"),
                                        SizedBox(height: 10),
                                        bookingFeeText(title: "${"SubType".tr} : ", subtitle: "${succeseeControllerController.succeseeApiModel?.appointData.subTitle}"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Transaction Detail".tr,
                                          style: TextStyle(
                                            color: textcolor,
                                            fontSize: 18,
                                            fontFamily: FontFamily.gilroyExtraBold,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        transactionDetailsText(title: "Doctor Consultation Charge".tr, subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.showTypePrice}"),
                                        if(succeseeControllerController.succeseeApiModel?.appointData.additionalPrice != 0)...[
                                          SizedBox(height: 10),
                                          transactionDetailsText(title: "Additional Price".tr, subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.additionalPrice}"),
                                        ],
                                        if(succeseeControllerController.serviceAndText != 0)...[
                                          SizedBox(height: 10),
                                          InkWell(
                                            key: buttonKey,
                                            onTap: () => toggleTooltip(context),
                                            child: transactionDetailsText(
                                              title: "Service Fee & Tax".tr,
                                              subtitle: "${getData.read("currency")} ${succeseeControllerController.serviceAndText}",
                                              image: "assets/info-circle.png",
                                            ),
                                          ),
                                        ],
                                        if(succeseeControllerController.succeseeApiModel?.appointData.walletAmount != 0)...[
                                          SizedBox(height: 10),
                                          transactionDetailsText(title: "Wallet Amount".tr, subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.walletAmount}"),
                                        ],
                                        if(succeseeControllerController.succeseeApiModel?.appointData.couponAmount != 0)...[
                                          SizedBox(height: 10),
                                          transactionDetailsText(title: "Coupon Amount".tr, subtitle: "${getData.read("currency")} -${succeseeControllerController.succeseeApiModel?.appointData.couponAmount}",subTextColor: green1Color),
                                        ],
                                        if(succeseeControllerController.succeseeApiModel?.appointData.onlineAmount != 0)...[
                                          SizedBox(height: 10),
                                          transactionDetailsText(title: "Payment Type".tr, subtitle: "(${succeseeControllerController.succeseeApiModel?.appointData.paymentName}) : ${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.onlineAmount}"),
                                        ],
                                        SizedBox(height: 10),
                                        DottedLine(dashColor: greyColor),
                                        SizedBox(height: 10),
                                        transactionDetailsText(title: "Total Price".tr, subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.totPrice}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 15,
                              top: 40,
                              child: GestureDetector(
                                onTap: () {
                                  cartDetailController.changeIndex(0);
                                  setState(() {
                                  });
                                  Get.offAll(BottomBarScreen());
                                  cartDetailController.addresTitle = "";
                                },
                                child: Icon(Icons.close, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
      },
    ),
  );
}

  final GlobalKey buttonKey = GlobalKey();
  OverlayEntry? overlayEntry;
  bool tooltipVisible = false;

  void toggleTooltip(context) {
    if (tooltipVisible) {
      hideTooltip();
    } else {
      showTooltip(context);
    }
  }

  void showTooltip(context) {
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: hideTooltip, // Tap outside to close
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx + 35,
            top: position.dy - 93,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      if(succeseeControllerController.succeseeApiModel?.appointData.doctorCommission != 0)...[
                        SizedBox(height: 10),
                        transactionDetailsText(
                          title: "Doctor Commission".tr,
                          subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.doctorCommission}",
                          subTextColor: WhiteColor,
                        ),
                      ],
                      if(succeseeControllerController.succeseeApiModel?.appointData.siteCommisiion != 0)...[
                        SizedBox(height: 10),
                        transactionDetailsText(
                          title: "Service Fee & Tax".tr,
                          subtitle: "${getData.read("currency")} ${succeseeControllerController.succeseeApiModel?.appointData.siteCommisiion}",
                          subTextColor: WhiteColor,
                        ),
                      ],
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: DownwardTrianglePainter(),
                    child: SizedBox(width: 15, height: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    tooltipVisible = true;
  }

  void hideTooltip() {
    overlayEntry?.remove();
    overlayEntry = null;
    tooltipVisible = false;
  }

bookingFeeText({required String title, required String subtitle}){
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: greycolor,
          fontSize: 14,
          fontFamily: FontFamily.gilroyBold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      Flexible(
        child: Text(
          subtitle,
          style: TextStyle(
            color: textcolor,
            fontSize: 16,
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
      ),
    ],
  );
}

transactionDetailsText({
  required String title,
  required String subtitle,
  Color? subTextColor,
  String? image,
}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontFamily: FontFamily.gilroyBold,
          color: subTextColor ?? textcolor,
        ),
      ),
      if(image != null)...[
          SizedBox(width: 7),
          Image.asset(
            image,
            color: textcolor,
            height: 14,
          ),
        ],
        Spacer(),
      Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          fontFamily: FontFamily.gilroyBold,
          color: subTextColor ?? textcolor,
        ),
      )
    ],
  );
}
