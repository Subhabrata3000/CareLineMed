import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/cart_shop_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/shop/product.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future cartAddItemsBottomSheet(
  context, {
  required Map productListData,
  required String doctorId,
  bool? isProductDetails,
}) {
  debugPrint("------------- productListData ----------- $productListData");
  debugPrint("---------------- doctorId --------------- $doctorId");
  CartShopController cartShopController = Get.put(CartShopController());

  List isLoadingData = List.filled(productListData["price_detail"].length, false);

  debugPrint("---------------- isLoadingData --------------- $isLoadingData");

  return showModalBottomSheet(
    context: context,
    backgroundColor: WhiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${productListData["product_name"]}",
                      style: TextStyle(
                        color: textcolor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!cartShopController.isCircle) {
                        Get.back();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: greyColor2,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: greyColor),
            StatefulBuilder(
              builder: (context, setState) {
                cartShopController.isCircle = false;
                setState(() {});
                return ListView.separated(
                  itemCount: productListData["price_detail"].length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/ezgif.com-crop.gif",
                                placeholderCacheWidth: 60,
                                placeholderCacheHeight: 60,
                                image: isProductDetails == true
                                    ? "${Config.imageBaseurlDoctor}${productListData["product_image"][0]}"
                                    : "${Config.imageBaseurlDoctor}${productListData["product_image"]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${productListData["product_name"]}",
                                  style: TextStyle(
                                    color: textcolor,
                                    fontFamily: FontFamily.gilroyMedium,
                                  ),
                                ),
                                Text(
                                  "${productListData["price_detail"][index]["title"]}",
                                  style: TextStyle(
                                    color: greyColor,
                                    fontFamily: FontFamily.gilroyMedium,
                                  ),
                                ),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "${getData.read("currency")} ${productListData["price_detail"][index]["price"]} ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "${getData.read("currency")} ${productListData["price_detail"][index]["base_price"]}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: FontFamily.gilroyMedium,
                                              color: greycolor,
                                              decoration: TextDecoration.lineThrough,
                                              decorationStyle: TextDecorationStyle.solid,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFEB902),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: Text(
                                        "${productListData["price_detail"][index]["discount"]}% OFF",
                                        style: TextStyle(
                                          color: WhiteColor,
                                          fontSize: 11,
                                          fontFamily: FontFamily.gilroyBold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: gradient.defoultColor),
                            ),
                            child: isLoadingData[index]
                                ? Center(
                                    child: LoadingAnimationWidget.staggeredDotsWave(
                                      color: gradient.defoultColor,
                                      size: 25,
                                    ),
                                  )
                                : (int.parse("${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}") > 0
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  int productQuntity = int.parse("${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                  if (cartShopController.isCircle == false) {
                                                    isLoadingData[index] = true;
                                                    cartShopController.isCircle = true;
                                                    setState(() {});
                                                    if (productQuntity > 1) {
                                                      debugPrint("-------------- log 1 ------------");
                                                      debugPrint("-------------- productQuntity ------------ $productQuntity");
                                                      setState(() {
                                                        cartShopController.cartShopApi(
                                                          uid: "${getData.read("UserLogin")["id"]}",
                                                          sitterId: doctorId,
                                                          prodId: "${productListData["id"]}",
                                                          proPrice: int.parse("${productListData["price_detail"][index]["price"]}"),
                                                          propType: "${productListData["price_detail"][index]["title"]}",
                                                          proQty: productQuntity,
                                                          mode: "1",
                                                          proQtyType: 2,
                                                        ).then((value) {
                                                          productQuntity--;
                                                          debugPrint("-------------- itemRemove 2 ------------ $productQuntity");
                                                          productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"] = productQuntity;
                                                          debugPrint("-------------- cartQty ------------ ${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                          int totalQuantity = 0;
                                                          for (var item in productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"]) {
                                                            item.forEach((key, value) {
                                                              totalQuantity += value as int;
                                                            });
                                                          }
                                                          debugPrint("-------------- totalQuantity ------------ $totalQuantity");

                                                          setState(() {});
                                                          productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["tot_product_qty"] = "$totalQuantity";

                                                          debugPrint("================== productQuntityList ================ $productCartQuntityList");
                                                          save("CartQuntry", productCartQuntityList);
                                                          debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                          isLoadingData[index] = false;
                                                          setState(() {});
                                                        });
                                                      });
                                                    } else if (productQuntity > 0) {
                                                      debugPrint("-------------- log 2 ------------");
                                                      debugPrint("-------------- productQuntity ------------ $productQuntity");
                                                      setState(() {});

                                                      setState(() {
                                                        cartShopController.cartShopApi(
                                                          uid: "${getData.read("UserLogin")["id"]}",
                                                          sitterId: doctorId,
                                                          prodId: "${productListData["id"]}",
                                                          proPrice: int.parse("${productListData["price_detail"][index]["price"]}"),
                                                          propType: "${productListData["price_detail"][index]["title"]}",
                                                          proQty: productQuntity,
                                                          mode: "1",
                                                          proQtyType: 2,
                                                        ).then((value) {
                                                          productQuntity--;
                                                          debugPrint("-------------- itemRemove 2 ------------ $productQuntity");
                                                          productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"] = productQuntity;
                                                          debugPrint("-------------- cartQty ------------ ${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                          int totalQuantity = 0;
                                                          for (var item in productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"]) {
                                                            item.forEach((key, value) {
                                                              totalQuantity += value as int;
                                                            });
                                                          }
                                                          debugPrint("-------------- totalQuantity ------------ $totalQuantity");

                                                          setState(() {});
                                                          productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["tot_product_qty"] = "$totalQuantity";

                                                          debugPrint("================== productQuntityList ================ $productCartQuntityList");
                                                          save("CartQuntry", productCartQuntityList);
                                                          debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                          isLoadingData[index] = false;
                                                          setState(() {});
                                                        });
                                                      });
                                                    }
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                color: gradient.defoultColor,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: FontFamily.gilroyBold,
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (cartShopController.isCircle == false) {
                                                    isLoadingData[index] = true;
                                                    cartShopController.isCircle = true;

                                                    int productQuntity = int.parse("${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                    debugPrint("-------------- productQuntity ------------ $productQuntity");

                                                    setState(() {
                                                      cartShopController.cartShopApi(
                                                        uid: "${getData.read("UserLogin")["id"]}",
                                                        sitterId: doctorId,
                                                        prodId: "${productListData["id"]}",
                                                        proPrice: int.parse("${productListData["price_detail"][index]["price"]}"),
                                                        propType: "${productListData["price_detail"][index]["title"]}",
                                                        proQty: productQuntity,
                                                        mode: "1",
                                                        proQtyType: 1,
                                                      ).then((value) {
                                                        productQuntity++;
                                                        setState(() {});
                                                        productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"] = productQuntity;
                                                        debugPrint("-------------- cartQty List ------------ ${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                        setState(() {});
                                                        int totalQuantity = 0;
                                                        for (var item in productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"]) {
                                                          item.forEach((key, value) {
                                                            totalQuantity += value as int;
                                                          });
                                                        }
                                                        debugPrint("-------------- totalQuantity ------------ $totalQuantity");

                                                        setState(() {});
                                                        productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["tot_product_qty"] = "$totalQuantity";
                                                        debugPrint("================== productQuntityList ================ $productCartQuntityList");
                                                        save("CartQuntry", productCartQuntityList);
                                                        debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                        isLoadingData[index] = false;
                                                        setState(() {});
                                                      });
                                                    });
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: gradient.defoultColor,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (cartShopController.isCircle == false) {
                                              isLoadingData[index] = true;
                                              cartShopController.isCircle = true;
                                              setState(() {});
                                              int productQuntity = int.parse("${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                              debugPrint("-------------- productQuntity ------------ $productQuntity");
                                              cartShopController.cartShopApi(
                                                uid: "${getData.read("UserLogin")["id"]}",
                                                sitterId: doctorId,
                                                prodId: "${productListData["id"]}",
                                                proPrice: int.parse("${productListData["price_detail"][index]["price"]}"),
                                                propType: "${productListData["price_detail"][index]["title"]}",
                                                proQty: productQuntity,
                                                mode: "1",
                                                proQtyType: 1,
                                              ).then((value) {
                                                productQuntity++;
                                                setState(() {});
                                                productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"] = productQuntity;
                                                debugPrint("-------------- cartQty List ------------ ${productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"][index]["${productListData["price_detail"][index]["title"]}"]}");
                                                setState(() {});
                                                int totalQuantity = 0;
                                                for (var item in productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["cart_qty_title"]) {
                                                  item.forEach((key, value) {
                                                    totalQuantity += value as int;
                                                  });
                                                }
                                                debugPrint("-------------- totalQuantity ------------ $totalQuantity");
                                                setState(() {});
                                                productCartQuntityList["dr_$doctorId"]["${productListData["id"]}"]["tot_product_qty"] = "$totalQuantity";
                                                debugPrint("================== productQuntityList ================ $productCartQuntityList");
                                                save("CartQuntry", productCartQuntityList);
                                                debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                isLoadingData[index] = false;
                                                setState(() {});
                                              });
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Add",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: FontFamily.gilroyBold,
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(color: greyColor),
                );
              },
            ),
            Divider(color: greyColor),
            Container(
              width: Get.width,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(),
              child: button(
                onPress: () {
                  Get.back();
                },
                text: "Done",
                color: gradient.defoultColor,
              ),
            ),
          ],
        ),
      );
    },
  );
}
