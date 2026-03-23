// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller/cart_shop_controller.dart';
import 'package:carelinemed/model_doctor/product_list_model.dart';
import 'package:carelinemed/screen/authentication/onbording_screen.dart';
import 'package:carelinemed/screen/shop/cart_add_bottomsheet.dart';
import 'package:carelinemed/screen/shop/checkout_screen.dart';
import 'package:carelinemed/screen/shop/product_details.dart';
import 'package:carelinemed/screen/shop/product_search_screen.dart';
import 'package:carelinemed/widget/custom_title.dart';

import '../../Api/data_store.dart';
import '../../controller_doctor/product_controller.dart';
import '../../controller_doctor/product_list_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';

Map productCartQuntityList = {};

class ProductScreen extends StatefulWidget {
  final String doctorId;
  final String categoryId;
  final String title;
  const ProductScreen({
    super.key,
    required this.doctorId,
    required this.categoryId,
    required this.title,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductController productController = Get.put(ProductController());
  ProductListController productListController = Get.put(ProductListController());
  CartShopController cartShopController = Get.put(CartShopController());
  // bool productListLoading = false;

  String currency = "";

  funApi() async {
    currency = "${getData.read("currency")}";
    cartShopController.cartShopApi(
      uid: "${getData.read("UserLogin")["id"]}",
      proQtyType: 0,
      sitterId: widget.doctorId,
      proPrice: 0,
      propType: "",
      prodId: "",
      proQty: 0,
      mode: "0",
    ).then((value) async {
      debugPrint("--------------- value -------------- $value");
      if (value["Result"] == true) {
        if (cartShopController.cartShopModel!.cplist!.isNotEmpty) {
          debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
          if (getData.read("CartQuntry") != null) {
            productCartQuntityList.addAll(getData.read("CartQuntry"));
            debugPrint("================== productCartQuntityList 1 ================ $productCartQuntityList");
          }
          if (productCartQuntityList.containsKey("dr_${widget.doctorId}") == false) {
            productCartQuntityList.addAll({"dr_${widget.doctorId}": {}});
            debugPrint("================== productCartQuntityList 2 ================ $productCartQuntityList");
          }
          for (var i = 0; i < cartShopController.cartShopModel!.cplist!.length; i++) {
            int qtyTotal = 0;
            List productQty = [];
            for (var j = 0; j < cartShopController.cartShopModel!.cplist![i].totValue!.length; j++) {
              productQty.add({"${cartShopController.cartShopModel!.cplist![i].totValue![j].title}" : cartShopController.cartShopModel!.cplist![i].totValue![j].qty});
              setState(() {});
            }
            for (var item in productQty) {
              item.forEach((key, value) {
                qtyTotal += value as int;
              });
            }
            debugPrint("================= productQty =============== $productQty");
            debugPrint("================== qtyTotal ================ $qtyTotal");
            if (productCartQuntityList["dr_${widget.doctorId}"].containsKey("${cartShopController.cartShopModel!.cplist![i].id}") == false) {
              await productCartQuntityList["dr_${widget.doctorId}"].addAll({
                "${cartShopController.cartShopModel!.cplist![i].id}": {
                  "tot_product_qty": "$qtyTotal",
                  "cart_qty_title": productQty.toList(),
                },
              });
            }
            debugPrint("================== productQuntityList ================ $productCartQuntityList");
          }
          await save("CartQuntry", productCartQuntityList);
          debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
        }
      }
      productController.productApi(
        doctorId: widget.doctorId.toString(),
        categoryId: widget.categoryId.toString(),
      ).then(
        (value) async {
          Map<String, dynamic> decodedData = json.decode(value);
          if (decodedData["Result"] == true && decodedData["ResponseCode"] == 200) {
            setState(() {});
            productListController.productListApi(
              doctorId: widget.doctorId,
              categoryId: "${productController.productModel!.subCategory!.first.id}"
            );
            if (getData.read("CartQuntry") == null) {
              for (int i = 0; i < productController.productModel!.subCategory!.length; i++) {
                await productListController.fetchInitialData(
                  scId: productController.productModel!.subCategory![i].id.toString(),
                  doctorId: widget.doctorId,
                );
              }
            }
            setState(() {});
            await productListController.fetchInitialData(
              scId: productController.productModel!.subCategory![0].id.toString(),
              doctorId: widget.doctorId,
            ).then((value) {
              debugPrint("-------- value : $value");
              if (value == true) {
                setState(() {});
              }
            });
            setState(() {});
          } else {
            Fluttertoast.showToast(msg: "${decodedData["message"]}");
          }
        },
      );
    });
    setState(() {});
  }

  @override
  void initState() {
    productListController.isLoading = false;
    setState(() {});
    funApi();
    super.initState();
  }

  int selectIndex = 0;
  int selectIndexSlider = 0;

  @override
  void dispose() {
    productController.isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: InkWell(
          onTap: () async {
            Get.to(
              ProductSearchScreen(
                title: widget.title,
                doctorId: widget.doctorId,
              ),
            )!.then((value) => setState(() {}));
          },
          child: Container(
            height: 45,
            margin: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/Search.png",
                  height: 18,
                  width: 18,
                  color: BlackColor,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "${"Search".tr} ${widget.title} ${"Product".tr}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: BlackColor,
                      fontSize: 13,
                      fontFamily: FontFamily.gilroyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GetBuilder<ProductListController>(
        builder: (productListController) {
          return productListController.isLoading && productCartQuntityList["dr_${widget.doctorId}"] != null
              ? productCartQuntityList["dr_${widget.doctorId}"]["tot_cart_qty"] != 0
                  ? InkWell(
                      onTap: () {
                        Get.to(
                          CheckoutScreen(
                            sitterId: widget.doctorId,
                            isUpdate: true,
                          ),
                        )!.then((value) => setState(() {}));
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: gradient.defoultColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: BlackColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/shopping-cart-star.svg",
                                color: WhiteColor,
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "View Cart".tr,
                                    style: TextStyle(
                                      color: WhiteColor,
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    productCartQuntityList["dr_${widget.doctorId}"]["tot_cart_qty"] == null
                                        ? ""
                                        : "${productCartQuntityList["dr_${widget.doctorId}"]["tot_cart_qty"]} ${"items".tr}",
                                    style: TextStyle(
                                      color: WhiteColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: WhiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox()
              : SizedBox();
        },
      ),
      body: GetBuilder<ProductController>(
        builder: (productController) {
          return Container(
            color: WhiteColor,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: Get.height / 10),
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productController.isLoading
                              ? productController.productModel!.bannerList!.isNotEmpty
                                  ? CarouselSlider(
                                      options: CarouselOptions(
                                        aspectRatio: 2.0,
                                        viewportFraction: 0.8,
                                        clipBehavior: Clip.none,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        autoPlay: productController.productModel!.bannerList!.length > 1,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            selectIndexSlider = index;
                                          });
                                        },
                                      ),
                                      items: productController.productModel!.bannerList!.map(
                                        (item) => GestureDetector(
                                          child: Container(
                                            width: Get.size.width,
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: "assets/ezgif.com-crop.gif",
                                                image: "${Config.imageBaseurlDoctor}$item",
                                                fit: BoxFit.cover,
                                                width: Get.width,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ).toList(),
                                    )
                                  : Container(
                                      height: 190,
                                      width: Get.size.width,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No doctor available in your area.".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 15,
                                          color: BlackColor,
                                        ),
                                      ),
                                    )
                              : Container(
                                  height: 170,
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      fit: BoxFit.cover,
                                      width: Get.width,
                                    ),
                                  ),
                              ),
                          titlebar(title: "Categories".tr),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < (productController.isLoading ? productController.productModel!.subCategory!.length : 5); i++) ...[
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectIndex = i;
                                      });
                                      setState(() {});
                                      productListController.fetchInitialData(
                                        scId: "${productController.productModel!.subCategory![i].id}",
                                        doctorId: widget.doctorId,
                                      );
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 130,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: productController.isLoading
                                            ? selectIndex == i
                                                ? Colors.white
                                                : Colors.transparent
                                            : transparent,
                                        border: Border.all(
                                          color: productController.isLoading
                                              ? selectIndex == i
                                                  ? gradient.defoultColor
                                                  : bordercolor
                                              : bordercolor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: productController.isLoading
                                                  ? FadeInImage.assetNetwork(
                                                      width: 72,
                                                      height: 72,
                                                      placeholder: "assets/ezgif.com-crop.gif",
                                                      image: "${Config.imageBaseurlDoctor}${productController.productModel!.subCategory![i].image}",
                                                      placeholderFit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/ezgif.com-crop.gif",
                                                      fit: BoxFit.cover,
                                                      width: Get.width,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          SizedBox(
                                            height: 30,
                                            width: double.infinity,
                                            child: productController.isLoading
                                                ? Text(
                                                    "${productController.productModel!.subCategory![i].name}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: FontFamily.gilroyMedium,
                                                      color: selectIndex == i
                                                          ? gradient.defoultColor
                                                          : BlackColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  )
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      "assets/ezgif.com-crop.gif",
                                                      fit: BoxFit.cover,
                                                      height: 30,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (i != (productController.isLoading ? productController.productModel!.subCategory!.length : 5) - 1) ...[SizedBox(width: 8)],
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          titlebar(title: "Bestseller Products".tr),
                          SizedBox(height: 10),
                          GetBuilder<ProductListController>(
                            builder: (productListController) {
                              return Stack(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisExtent: 260,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: productListController.isLoading ? productListController.productListModel!.productList!.length : 3,
                                    itemBuilder: (context, index) {
                                      ProductList? product;
                                      if (productListController.isLoading) {
                                        product = productListController.productListModel!.productList![index];
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (productListController.isLoading) {
                                            Get.to(
                                              ProductDetails(
                                                title: widget.title,
                                                sitterId: widget.doctorId.toString(),
                                                productIndex: index,
                                                prodId: product!.id.toString(),
                                              ),
                                            )!.then((value) => setState(() {}));
                                          }
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              width: Get.width,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: productListController.isLoading
                                                        ? FadeInImage.assetNetwork(
                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                            image: "${Config.imageBaseurlDoctor}${product!.productImage}",
                                                            fit: BoxFit.cover,
                                                            width: Get.width,
                                                          )
                                                        : Image.asset(
                                                            "assets/ezgif.com-crop.gif",
                                                            fit: BoxFit.cover,
                                                            width: Get.width,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            productListController.isLoading
                                                                ? Text(
                                                                    "${product!.productName}",
                                                                    style: TextStyle(
                                                                      fontFamily: FontFamily.gilroyBold,
                                                                      color: BlackColor,
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  )
                                                                : ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image.asset(
                                                                      "assets/ezgif.com-crop.gif",
                                                                      fit: BoxFit.cover,
                                                                      width: 100,
                                                                      height: 15,
                                                                    ),
                                                                  ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      if (productListController.isLoading) ...[
                                                                        Text(
                                                                          "$currency${productListController.productListModel!.productList![index].priceDetail!.first.price}",
                                                                          style: TextStyle(
                                                                            fontSize: 16,
                                                                            fontFamily: FontFamily.gilroyBold,
                                                                            color: BlackColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "$currency${productListController.productListModel!.productList![index].priceDetail!.first.basePrice}",
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontFamily: FontFamily.gilroyMedium,
                                                                            color: greycolor,
                                                                            decoration: TextDecoration.lineThrough,
                                                                            decorationStyle: TextDecorationStyle.solid,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      if (productListController.isLoading == false)...[
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          child: Image.asset(
                                                                            "assets/ezgif.com-crop.gif",
                                                                            fit: BoxFit.cover,
                                                                            width: 50,
                                                                            height: 30,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ],
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        if (productListController.isLoading) {
                                                                          if (getData.read("UserLogin") == null) {
                                                                            Get.offAll(BoardingPage());
                                                                          } else {
                                                                            cartAddItemsBottomSheet(
                                                                              context,
                                                                              productListData: productListController.productListModel!.productList![index].toJson(),
                                                                              doctorId: widget.doctorId,
                                                                            ).then((value) {
                                                                              int cartTotalQty = 0;
                                                                              productCartQuntityList["dr_${widget.doctorId}"].forEach((key, value) {
                                                                                if (int.tryParse(key) != null && value is Map) {
                                                                                  List<dynamic> cartQtyTitle = value["cart_qty_title"];
                                                                                  for (var item in cartQtyTitle) {
                                                                                    item.forEach((k, v) {
                                                                                      cartTotalQty += v as int;
                                                                                    });
                                                                                  }
                                                                                }
                                                                              });
                                                                              debugPrint("============ cartTotalQty =========== $cartTotalQty");
                                                                              productCartQuntityList["dr_${widget.doctorId}"].addAll({
                                                                                "tot_cart_qty": cartTotalQty
                                                                              });
                                                                              setState(() {});
                                                                              save("CartQuntry", productCartQuntityList);
                                                                              debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                                            });
                                                                          }
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        height: 30,
                                                                        width: 60,
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          border: Border.all(color: productListController.isLoading ? gradient.defoultColor : transparent),
                                                                          image: productListController.isLoading
                                                                              ? null
                                                                              : DecorationImage(
                                                                                  image: AssetImage("assets/ezgif.com-crop.gif"),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                        ),
                                                                        child: productListController.isLoading
                                                                            ? Center(
                                                                                child: int.parse("${productCartQuntityList["dr_${widget.doctorId}"]["${productListController.productListModel!.productList![index].id}"]["tot_product_qty"]}") != 0
                                                                                    ? Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.remove,
                                                                                            color: gradient.defoultColor,
                                                                                            size: 18,
                                                                                          ),
                                                                                          Text(
                                                                                            "${productCartQuntityList["dr_${widget.doctorId}"]["${productListController.productListModel!.productList![index].id}"]["tot_product_qty"]}",
                                                                                            style: TextStyle(
                                                                                              fontSize: 13,
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: gradient.defoultColor,
                                                                                            ),
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.add,
                                                                                            color: gradient.defoultColor,
                                                                                            size: 18,
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Text(
                                                                                        "Add".tr,
                                                                                        style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: gradient.defoultColor,
                                                                                        ),
                                                                                      ),
                                                                              )
                                                                            : SizedBox(),
                                                                      ),
                                                                    ),
                                                                    if (productListController.isLoading) ...[
                                                                      SizedBox(height: 2),
                                                                      Text(
                                                                        "${productListController.productListModel!.productList![index].priceDetail!.length} ${"options".tr}",
                                                                        style: TextStyle(
                                                                          color: gradient.defoultColor,
                                                                          fontSize: 10,
                                                                          fontFamily: FontFamily.gilroyRegular,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (productListController.isLoading) ...[
                                              Positioned(
                                                left: -3,
                                                top: 5,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SvgPicture.asset("assets/Delivery.svg"),
                                                    Positioned(
                                                      bottom: 11.5,
                                                      left: 26,
                                                      child: Text(
                                                        "${productListController.productListModel!.productList![index].priceDetail!.first.discount}% ${"OFF".tr}",
                                                        style: TextStyle(
                                                          color: WhiteColor,
                                                          fontSize: 10,
                                                          fontFamily: FontFamily.gilroyBold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (productListController.isLoading) ...[
                                    if (productListController.productListModel!.productList!.isEmpty) ...[
                                      Center(
                                        child: Container(
                                          height: Get.height / 3,
                                          width: Get.width / 2,
                                          decoration: BoxDecoration(color: WhiteColor),
                                          child: Center(
                                            child: Text(
                                              "No stock available for this medicine.".tr,
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
                                    ],
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
