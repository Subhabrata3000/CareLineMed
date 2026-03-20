// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_typing_uninitialized_variables, unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller_doctor/cart_detail_controller.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/checkout_controller.dart';
import '../../controller/shop_coupon_controller.dart';
import '../../model/font_family_model.dart';


class ShopCouponScreen extends StatefulWidget {
  const ShopCouponScreen({super.key});

  @override
  State<ShopCouponScreen> createState() => _ShopCouponScreenState();
}

class _ShopCouponScreenState extends State<ShopCouponScreen> {

  TextEditingController search = TextEditingController();
  ShopCouponController shopCouponController = Get.put(ShopCouponController());
  CheckOutController checkOutController = Get.put(CheckOutController());



  var currency;

  currencyGet() async {
    currency = getData.read("currency");
    shopCouponController.shopCouponApi(orderId: orderId);
    setState(() {

    });
  }

  @override
  void initState() {
    currencyGet();
    super.initState();
  }


  double price = Get.arguments["price"];
  String orderId = Get.arguments["orderId"];

  @override
  void dispose() {
    shopCouponController.isLoading = false;
    super.dispose();
  }

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
          SizedBox(
            height: 5,
          ),
          GetBuilder<ShopCouponController>(builder: (shopCouponController) {
            return Expanded(
              child: shopCouponController.isLoading
                  ? shopCouponController.shopCouponModel!.couponList!.isNotEmpty
                  ? ListView.builder(
                itemCount: shopCouponController.shopCouponModel!.couponList!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    width: Get.size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "${shopCouponController.shopCouponModel!.couponList![index].title}",
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily:
                                  FontFamily.gilroyExtraBold,
                                  color: BlackColor,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${shopCouponController.shopCouponModel!.couponList![index].subTitle}",
                                style: TextStyle(
                                  color: greyColor,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Coupon Code: '.tr,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: shopCouponController.shopCouponModel!.couponList![index].code,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily:
                                        FontFamily.gilroyBold,
                                        color:
                                        gradient.defoultColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Coupon Amount: '.tr,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: "$currency${shopCouponController.shopCouponModel!.couponList![index].discountAmount}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily:
                                        FontFamily.gilroyBold,
                                        color: BlackColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Minimum Amount: '.tr,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: "$currency${shopCouponController.shopCouponModel!.couponList![index].minAmount}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily:
                                        FontFamily.gilroyBold,
                                        color: BlackColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Ex Date: '.tr,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily:
                                    FontFamily.gilroyMedium,
                                    fontSize: 15,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: shopCouponController.shopCouponModel!.couponList![index].endDate.toString().split(" ").first,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily:
                                        FontFamily.gilroyBold,
                                        color: BlackColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (double.parse(price.toString()) >= double.parse(shopCouponController.shopCouponModel!.couponList![index].minAmount.toString())) {
                                    setState(() {
                                      checkOutController.couponAmt = int.parse(shopCouponController.shopCouponModel!.couponList![index].discountAmount.toString());
                                    });

                                    checkOutController.total = checkOutController.total - checkOutController.couponAmt;

                                    checkOutController.couponId = shopCouponController.shopCouponModel!.couponList![index].id.toString();

                                    Get.back(result: shopCouponController.shopCouponModel!.couponList![index].code);

                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Apply coupons".tr,
                                    style: TextStyle(
                                      fontFamily:
                                      FontFamily.gilroyBold,
                                      color: double.parse(price.toString()) >= double.parse(shopCouponController.shopCouponModel!.couponList![index].minAmount.toString())
                                          ? gradient.defoultColor
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    border: double.parse(price.toString()) >= double.parse(shopCouponController.shopCouponModel!.couponList![index].minAmount.toString())
                                        ? Border.all(
                                        color: gradient
                                            .defoultColor)
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
                              borderRadius:
                              BorderRadius.circular(10),
                              child: SvgPicture.asset("assets/offerIcon.svg"),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(40),
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
                },
              )
                  : Center(
                child: Text(
                  "The Coupon is unavailable \n in your Service.".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                    color: BlackColor,
                  ),
                ),
              )
                  : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
}
