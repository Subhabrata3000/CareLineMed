import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/checkout_controller.dart';
import 'package:carelinemed/controller_doctor/product_list_controller.dart';
import 'package:carelinemed/screen/authentication/onbording_screen.dart';
import 'package:carelinemed/screen/shop/cart_add_bottomsheet.dart';
import 'package:carelinemed/screen/shop/checkout_screen.dart';
import 'package:carelinemed/screen/shop/product.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../controller/cart_shop_controller.dart';
import '../../controller/product_detail_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import '../home_screen.dart';

class ProductDetails extends StatefulWidget {
  final String sitterId;
  final String prodId;
  final String title;
  final int? productIndex;
  const ProductDetails({
    super.key,
    required this.sitterId,
    required this.prodId,
    required this.title,
    this.productIndex,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var currency;

  ProductDetailController productDetailController = Get.put(ProductDetailController());
  CartShopController cartShopController = Get.put(CartShopController());
  CheckOutController checkOutController = Get.put(CheckOutController());
  ProductListController productListController = Get.put(ProductListController());

  fun() async {
    productDetailController.isLoading = false;
    setState(() {});
    currency = getData.read("currency");
    debugPrint("------- currency --------- $currency");
    debugPrint("----- productIndex ------- ${widget.productIndex}");
    productDetailController.productDetailApi(
      sitterId: widget.sitterId.toString(),
      prodId: widget.prodId.toString(),
    ).then((value) {
      debugPrint("--------------- value -------------- $value");
      if (value["Result"] == true) {
        productDetailController.imagePaths = productDetailController.productDetailModel!.product!.productImage!;
        setState(() {});
        debugPrint("=============== imagePaths =========== ${productDetailController.imagePaths}");
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    fun();
    super.initState();
  }

  @override
  void dispose() {
    productDetailController.isLoading = false;
    super.dispose();
  }

  int selectIndex = 0;
  int quantityTotal = 1;

  final List<Map<String, dynamic>> apiQueue = [];
  bool isProcessingQueue = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        cartShopController.cartShopApi(
          uid: "${getData.read("UserLogin")["id"]}",
          sitterId: widget.sitterId.toString(),
          prodId: "",
          proQty: 0,
          proPrice: 0,
          propType: "",
          mode: "0",
          proQtyType: 0,
        );
        Get.back();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (widget.productIndex != null) {
            Get.back();
          } else {
            Get.close(2);
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: bgcolor,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: Container(
              height: 30,
              margin: const EdgeInsets.only(left: 15),
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(color: greyColor2.withOpacity(0.4)),
                shape: BoxShape.circle,
              ),
              child: BackButton(
                color: WhiteColor,
                onPressed: () {
                  if (widget.productIndex != null) {
                    Get.back();
                  } else {
                    Get.close(2);
                  }
                },
              ),
            ),
          ),
          body: GetBuilder<ProductDetailController>(
            builder: (productDetailController) {
              return productDetailController.isLoading
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height / 4,
                            child: PageView.builder(
                              clipBehavior: Clip.none,
                              controller: PageController(viewportFraction: 1),
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: productDetailController.productDetailModel!.product!.productImage!.length,
                              onPageChanged: (value) {
                                setState(() {
                                  selectIndex = value;
                                });
                              },
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      PhotoViewPage(
                                        photos: productDetailController.productDetailModel!.product!.productImage!,
                                        index: index,
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(17),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      placeholderFit: BoxFit.cover,
                                      placeholderCacheWidth: 10,
                                      placeholderCacheHeight: 10,
                                      image: Config.imageBaseurlDoctor + productDetailController.productDetailModel!.product!.productImage![index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          productDetailController.productDetailModel!.product!.productImage!.length == 1
                            ? SizedBox()
                            : SizedBox(
                                height: 25,
                                width: Get.size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List.generate(
                                      productDetailController.productDetailModel!.product!.productImage!.length,
                                      (index) {
                                        return Indicator(isActive: selectIndex == index ? true : false);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          SizedBox(height: 10),
                          productDetailController.productDetailModel!.product!.prescriptionRequire == "Unrequired"
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Image.asset(
                                      "assets/prescription.png",
                                      height: 16,
                                      color: const Color(0xFFA30202),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Prescription Require".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyBold,
                                        color: const Color(0xFFA30202),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                          SizedBox(height: 10),
                          Text(
                            "${productDetailController.productDetailModel!.product!.productName}",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: FontFamily.gilroyBold,
                              color: BlackColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "$currency${productDetailController.productDetailModel!.product!.priceDetail!.first.price} ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "$currency${productDetailController.productDetailModel!.product!.priceDetail!.first.basePrice}",
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
                                  color: Color(0xffFEB902),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: Text(
                                  "${productDetailController.productDetailModel!.product!.priceDetail!.first.discount}% OFF",
                                  style: TextStyle(
                                    color: WhiteColor,
                                    fontSize: 11,
                                    fontFamily: FontFamily.gilroyBold,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (getData.read("UserLogin") == null) {
                                        Get.offAll(BoardingPage());
                                      } else {
                                        cartAddItemsBottomSheet(
                                          context,
                                          productListData: productDetailController.productDetailModel!.product!.toJson(),
                                          doctorId: widget.sitterId,
                                          isProductDetails: true,
                                        ).then((value) {
                                          int cartTotalQty = 0;
                                          productCartQuntityList["dr_${widget.sitterId}"].forEach((key, value) {
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
                                          productCartQuntityList["dr_${widget.sitterId}"].addAll({"tot_cart_qty": cartTotalQty});
                                          setState(() {});
                                          save("CartQuntry", productCartQuntityList);
                                          debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 70,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: gradient.defoultColor),
                                      ),
                                      child: Center(
                                        child: int.parse("${productCartQuntityList["dr_${widget.sitterId}"]["${productDetailController.productDetailModel!.product!.id}"]["tot_product_qty"]}") != 0
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.remove,
                                                    color: gradient.defoultColor,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    productCartQuntityList["dr_${widget.sitterId}"]["${productDetailController.productDetailModel!.product!.id}"]["tot_product_qty"],
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
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${productDetailController.productDetailModel!.product!.priceDetail!.length} ${"options".tr}",
                                    style: TextStyle(
                                      color: gradient.defoultColor,
                                      fontSize: 11,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "${productDetailController.productDetailModel!.product!.proType}",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: FontFamily.gilroyMedium,
                              color: BlackColor,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "${productDetailController.productDetailModel!.product!.description}",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: FontFamily.gilroyMedium,
                              color: greycolor,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GetBuilder<ProductDetailController>(
            builder: (productDetailController) {
              return productDetailController.isLoading
                  ? productCartQuntityList["dr_${widget.sitterId}"]["tot_cart_qty"] != 0
                      ? InkWell(
                          onTap: () {
                            Get.to(
                              CheckoutScreen(
                                sitterId: widget.sitterId,
                                isUpdate: true,
                              ),
                            )!.then((value) => fun());
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
                                        "${productCartQuntityList["dr_${widget.sitterId}"]["tot_cart_qty"]} ${"items".tr}",
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
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? gradient.defoultColor : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class PhotoViewPage extends StatefulWidget {
  final List<String> photos;
  final int index;

  const PhotoViewPage({super.key, required this.photos, required this.index});

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  ProductDetailController productDetailController = Get.put(ProductDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: WhiteColor,
      appBar: AppBar(
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(
          color: WhiteColor,
        ),
        itemCount: productDetailController.productDetailModel!.product!.productImage!.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: CachedNetworkImage(
            height: Get.height,
            width: Get.width,
            filterQuality: FilterQuality.high,
            imageUrl: "${Config.imageBaseurlDoctor}${productDetailController.productDetailModel!.product!.productImage![index]}",
            placeholder: (context, url) => Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: WhiteColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/ezgif.com-crop.gif",
                fit: BoxFit.cover,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  error.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          minScale: PhotoViewComputedScale.covered,
          heroAttributes: PhotoViewHeroAttributes(
            tag: "${Config.imageBaseurlDoctor}${widget.photos[index]}",
          ),
        ),
        pageController: PageController(initialPage: widget.index),
        enableRotation: false,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}
