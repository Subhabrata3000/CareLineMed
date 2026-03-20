// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_typing_uninitialized_variables, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/lab_package_cart_controller.dart';
import 'package:laundry/controller_doctor/cart_detail_controller.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/data_store.dart';
import '../model/font_family_model.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  TextEditingController search = TextEditingController();
  CartDetailController cartDetailController = Get.put(CartDetailController());
  LabPackageCartController labPackageCartController = Get.put(LabPackageCartController());

  @override
  void initState() {
    debugPrint("-------------- price -------------- $price");
    debugPrint("----------- labPackCart ----------- $labPackCart");
    super.initState();
  }

  double price = Get.arguments["price"];
  bool labPackCart = Get.arguments["labPackCart"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 53,
              width: Get.size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: BlackColor,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "All coupons".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Best Coupon".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 18,
                  color: BlackColor,
                ),
              ),
            ),
            SizedBox(height: 5),

            labPackCart == true
            ? GetBuilder<LabPackageCartController>(
                builder: (labPackageCartController) {
                  return Expanded(
                    child:
                        labPackageCartController.labPackageCartApiModel!.coupon!.isNotEmpty
                            ? ListView.builder(
                                itemCount: labPackageCartController.labPackageCartApiModel!.coupon!.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return couponDataContainer(
                                    title: "${labPackageCartController.labPackageCartApiModel!.coupon![index].title}",
                                    subTitle: "${labPackageCartController.labPackageCartApiModel!.coupon![index].subTitle}",
                                    code: "${labPackageCartController.labPackageCartApiModel!.coupon![index].code}",
                                    discountAmount: "${labPackageCartController.labPackageCartApiModel!.coupon![index].discountAmount}",
                                    minAmount: "${labPackageCartController.labPackageCartApiModel!.coupon![index].minAmount}",
                                    endDate: "${labPackageCartController.labPackageCartApiModel!.coupon![index].endDate}",
                                    onTap: () {
                                      if (double.parse(price.toString()) >= double.parse("${labPackageCartController.labPackageCartApiModel!.coupon![index].minAmount}")) {
                                        setState(() {
                                          labPackageCartController.couponAmt = int.parse("${labPackageCartController.labPackageCartApiModel!.coupon![index].discountAmount}");
                                        });
                                        labPackageCartController.total = labPackageCartController.total - labPackageCartController.couponAmt;
                                        labPackageCartController.apitotal = labPackageCartController.total;
                                        debugPrint("--------------------- total ---------------------- ${labPackageCartController.total}");
                                        debugPrint("------------------- apitotal --------------------- ${labPackageCartController.apitotal}");
                                        labPackageCartController.couponId = "${labPackageCartController.labPackageCartApiModel!.coupon![index].id}";
                                        Get.back(result: labPackageCartController.labPackageCartApiModel!.coupon![index].code);
                                      }
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: SizedBox(
                                  width: Get.width / 1.7,
                                  child: Text(
                                    "The Coupon is unavailable in your Service.".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                              ),
                  );
                },
              )
            : GetBuilder<CartDetailController>(
                builder: (context) {
                  return Expanded(
                    child: cartDetailController.isLoading
                        ? cartDetailController.cartDetailModel!.coupon.isNotEmpty
                            ? ListView.builder(
                                itemCount: cartDetailController.cartDetailModel!.coupon.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return couponDataContainer(
                                    title: cartDetailController.cartDetailModel!.coupon[index].title,
                                    subTitle: cartDetailController.cartDetailModel!.coupon[index].subTitle,
                                    code: cartDetailController.cartDetailModel!.coupon[index].code,
                                    discountAmount: "${cartDetailController.cartDetailModel!.coupon[index].discountAmount}",
                                    minAmount: "${cartDetailController.cartDetailModel!.coupon[index].minAmount}",
                                    endDate: cartDetailController.cartDetailModel!.coupon[index].endDate,
                                    onTap: () {
                                      if (double.parse(price.toString()) >= double.parse("${cartDetailController.cartDetailModel!.coupon[index].minAmount}")) {
                                        setState(() {
                                          cartDetailController.couponAmt = int.parse("${cartDetailController.cartDetailModel!.coupon[index].discountAmount}");
                                        });
                                        cartDetailController.total = cartDetailController.total - cartDetailController.couponAmt;
                                        cartDetailController.couponId = "${cartDetailController.cartDetailModel!.coupon[index].id}";
                                        Get.back(result: cartDetailController.cartDetailModel!.coupon[index].code);
                                      }
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: SizedBox(
                                  width: Get.width / 1.7,
                                  child: Text(
                                    "The Coupon is unavailable in your Service.".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                              )
                        : Center(child: CircularProgressIndicator(color: gradient.defoultColor)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
  
  Widget couponDataContainer({
    required String title,
    required String subTitle,
    required String code,
    required String discountAmount,
    required String minAmount,
    required String endDate,
    required VoidCallback onTap,
  }) {
    return Container(
      width: Get.size.width,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyExtraBold,
                    color: BlackColor,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 14,
                    fontFamily: FontFamily.gilroyMedium,
                  ),
                ),
                SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: "${"Coupon Code".tr} : ",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 15,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: code,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.gilroyBold,
                          color: gradient.defoultColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: "${"Coupon Amount".tr} : ",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 15,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: "${getData.read("currency")}$discountAmount",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.gilroyBold,
                          color: BlackColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: "${"Minimum Amount".tr} : ",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 15,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text:  "${getData.read("currency")}$minAmount",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.gilroyBold,
                          color: BlackColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: "${"Ex Date".tr} : ",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 15,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: endDate.toString().split(" ").first,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.gilroyBold,
                          color: BlackColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 40,
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    child: Text(
                      "Apply coupons".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        color: double.parse(price.toString()) >= double.parse(minAmount)
                            ? gradient.defoultColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: double.parse(price.toString()) >= double.parse(minAmount)
                          ? Border.all(color: gradient.defoultColor)
                          : Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          Container(
            height: 130,
            width: 100,
            alignment: Alignment.center,
            child: Container(
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.asset("assets/offerIcon.svg"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}