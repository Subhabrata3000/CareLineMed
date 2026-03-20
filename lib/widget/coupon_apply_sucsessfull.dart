import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:lottie/lottie.dart';

Future couponSucsessFullyApplyed({required String couponAmt}) {
  return Get.defaultDialog(
    title: "",
    content: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.size.width,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  color: transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/discount-voucher.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "${"Yey! You've saved".tr} ${getData.read("currency")}$couponAmt ${"With this coupon".tr}",
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyExtraBold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Supporting small businesses has never been so rewarding!".tr,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyMedium,
                  height: 1.2,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "Awesome!".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    color: gradient.defoultColor,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -160,
          left: 0,
          right: 0,
          child: Container(
            color: transparent,
            child: Lottie.asset(
              'assets/L6o2mVij1E.json',
              repeat: false,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ),
  );
}
