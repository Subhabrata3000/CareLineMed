import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/shop_order_detail_controller.dart';
import 'package:laundry/utils/custom_colors.dart';

class ViewImageScreen extends StatefulWidget {
  final int imageIndex;
  const ViewImageScreen({super.key, required this.imageIndex});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  ShopOrderDetailController shopOrderDetailController = Get.put(ShopOrderDetailController());
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    currentPage = widget.imageIndex;
    pageController = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription!.length,
            controller: pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return FadeInImage.assetNetwork(
                placeholder: "assets/ezgif.com-crop.gif",
                placeholderCacheHeight: 80,
                placeholderCacheWidth: 80,
                placeholderFit: BoxFit.cover,
                image: "${Config.imageBaseurlDoctor}${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription![index]}",
                height: 60,
                width: 60,
                // fit: BoxFit.cover,
              );
            },
          ),
          Positioned(
            top: 50,
            left: 15,
            child: InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.3),
                  shape: BoxShape.circle
                ),
                child: Blur(
                  borderRadius: BorderRadius.circular(50),
                  colorOpacity: 0.50,
                  blurColor: BlackColor,
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
          ),
          shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription!.length == 1
          ? SizedBox()
          : Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int i = 0; i < shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription!.length; i++)...[
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutExpo,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        height: 10,
                        width: currentPage == i ? 20 : 10,
                        decoration: BoxDecoration(
                          color: currentPage == i ? primeryColor : greyColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}