import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/screen/shop/my%20order/view_image_screen.dart';
import 'package:carelinemed/widget/custom_title.dart';
import '../../../Api/config.dart';
import '../../../controller/shop_order_detail_controller.dart';
import '../../../model/font_family_model.dart';
import '../../../utils/custom_colors.dart';

class StoreWiseScreen extends StatefulWidget {
  final String orderId;
  final String doctorId;
  final String? statusSummary;
  final String? totPriceSummary;
  final String? nameSummary;
  final String? addressSummary;
  final String? dateSummary;
  final String? totProductSummary;
  final String? imageSummary;
  const StoreWiseScreen({
    super.key,
    required this.orderId,
    required this.doctorId,
    this.statusSummary,
    this.totPriceSummary,
    this.nameSummary,
    this.addressSummary,
    this.dateSummary,
    this.totProductSummary,
    this.imageSummary,
  });

  @override
  State<StoreWiseScreen> createState() => _StoreWiseScreenState();
}

class _StoreWiseScreenState extends State<StoreWiseScreen> {
  ShopOrderDetailController shopOrderDetailController = Get.put(ShopOrderDetailController());

  @override
  void initState() {
    super.initState();
    _functionApi();
  }

  @override
  void dispose() {
    shopOrderDetailController.isLoading = false;
    super.dispose();
  }

  var currency;

  Future _functionApi() async {
    currency = getData.read("currency");
    setState(() {});
    shopOrderDetailController.shopOrderDetailApi(
      uid: "${getData.read("UserLogin")["id"]}", 
      orderId: widget.orderId, 
      doctorId: widget.doctorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: BackButton(color: WhiteColor),
        title: Text(
          "${"Order ID:".tr} #${widget.orderId}",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: gradient.defoultColor,
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 2),
            () {
              shopOrderDetailController.shopOrderDetailApi(
                uid: "${getData.read("UserLogin")["id"]}",
                orderId: widget.orderId,
                doctorId: widget.doctorId,
              );
            },
          );
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GetBuilder<ShopOrderDetailController>(
              builder: (shopOrderDetailController) {
                bool isFallback = shopOrderDetailController.shopOrderDetailModel?.orderDetail == null;
                return shopOrderDetailController.isLoading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.02),
                          Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: WhiteColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order Info".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: gradient.defoultColor,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      shopOrderDetailController.productList.isEmpty
                                          ? (isFallback ? Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.grey.withOpacity(0.1),
                                                    ),
                                                    child: widget.imageSummary != null && widget.imageSummary!.isNotEmpty
                                                        ? ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.network(
                                                              "${Config.imageBaseurlDoctor}${widget.imageSummary}",
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (context, error, stackTrace) => Icon(Icons.shopping_bag, color: gradient.defoultColor),
                                                            ),
                                                          )
                                                        : Icon(Icons.shopping_bag, color: gradient.defoultColor),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${widget.nameSummary ?? 'Careline Store'}",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyBold,
                                                            fontSize: 16,
                                                            color: BlackColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "${widget.dateSummary ?? ''} • ${widget.totProductSummary ?? '1'} Items",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyMedium,
                                                            fontSize: 13,
                                                            color: greytext,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "$currency ${widget.totPriceSummary ?? '0.00'}",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyBold,
                                                            fontSize: 16,
                                                            color: gradient.defoultColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ) : SizedBox(
                                              height: 100,
                                              child: Center(
                                                child: Text(
                                                  "No products found for this order".tr,
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.gilroyMedium,
                                                    color: greycolor,
                                                  ),
                                                ),
                                              ),
                                            ))
                                          : ListView.separated(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: shopOrderDetailController.productList.length,
                                              separatorBuilder: (context, index) => Divider(color: greyColor),
                                              itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(65),
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: "assets/ezgif.com-crop.gif",
                                                    placeholderCacheHeight: 80,
                                                    placeholderCacheWidth: 80,
                                                    placeholderFit: BoxFit.cover,
                                                    image: "${Config.imageBaseurlDoctor}${shopOrderDetailController.productList[index].productImage}",
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // SizedBox(height: 8),
                                                    shopOrderDetailController.productList[index].prescriptionRequire == "Unrequired"
                                                      ? SizedBox()
                                                      : Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/prescription.png",
                                                            height: 10,
                                                            color: const Color(0xFFA30202),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "Prescription Require".tr,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontFamily: FontFamily.gilroyBold,
                                                              color: const Color(0xFFA30202),
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${shopOrderDetailController.productList[index].productName}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: FontFamily.gilroyBold,
                                                              color: BlackColor,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${shopOrderDetailController.productList[index].proType}",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyMedium,
                                                            color: greycolor,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${shopOrderDetailController.productList[index].priceDetail!.title}",
                                                                style: TextStyle(
                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                  color: greycolor,
                                                                ),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "$currency${shopOrderDetailController.productList[index].priceDetail!.price} ",
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontFamily: FontFamily.gilroyBold,
                                                                        color: BlackColor,
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: "$currency${shopOrderDetailController.productList[index].priceDetail!.bprice}",
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
                                                                      "${shopOrderDetailController.productList[index].priceDetail!.discount}% OFF",
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
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "Qty".tr,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.gilroyBold,
                                                                color: BlackColor,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            SizedBox(height: 3),
                                                            Text(
                                                              "${shopOrderDetailController.productList[index].priceDetail!.qty}",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily: FontFamily.gilroyBold,
                                                                color: greytext,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                          if (shopOrderDetailController.shopOrderDetailModel?.orderDetail?.medicinePrescription != null && shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription!.isNotEmpty)...[
                            SizedBox(height: Get.height * 0.02),
                            Container(
                              height: 150,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              width: Get.size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: WhiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Medicine Prescription".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription!.length,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(ViewImageScreen(imageIndex: index));
                                          },
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: bg1Color),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: "assets/ezgif.com-crop.gif",
                                                placeholderCacheHeight: 80,
                                                placeholderCacheWidth: 80,
                                                placeholderFit: BoxFit.cover,
                                                image: "${Config.imageBaseurlDoctor}${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.medicinePrescription![index]}",
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          // --- Fallback Display Variables ---
                          Builder(
                            builder: (context) {
                              String? displayStatus = shopOrderDetailController.shopOrderDetailModel?.orderDetail?.status ?? widget.statusSummary;
                              
                              return Column(
                                children: [
                                  if (displayStatus != null)...[
                                    SizedBox(height: Get.height * 0.02),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      width: Get.size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: WhiteColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order Status".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 14,
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          SizedBox(height: 13),
                                          stepper(status: int.parse(displayStatus)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (shopOrderDetailController.shopOrderDetailModel?.orderDetail != null || isFallback)...[
                                    SizedBox(height: Get.height * 0.02),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      width: Get.size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: WhiteColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Payment & Address Info".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 14,
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          SizedBox(height: 13),
                                          if (isFallback) ...[
                                            if (widget.totPriceSummary != null)
                                              billSummaryTextDetaile(
                                                title: "Total Price".tr,
                                                subtitle: "$currency ${widget.totPriceSummary}",
                                              ),
                                            if (widget.nameSummary != null) ...[
                                              SizedBox(height: 5),
                                              billSummaryTextDetaile(
                                                title: "Store".tr,
                                                subtitle: "${widget.nameSummary}",
                                              ),
                                            ],
                                            if (widget.addressSummary != null) ...[
                                              SizedBox(height: 5),
                                              billSummaryTextDetaile(
                                                title: "Address".tr,
                                                subtitle: "${widget.addressSummary}",
                                              ),
                                            ],
                                          ] else ...[
                                if(shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet != 0)...[
                                  billSummaryTextDetaile(
                                    title: "Wallet Amount".tr,
                                    subtitle: "$currency ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet}",
                                  ),
                                ],
                                if(shopOrderDetailController.shopOrderDetailModel!.orderDetail!.couponAmount != 0)...[
                                  SizedBox(height: 5),
                                  billSummaryTextDetaile(
                                    title: "Coupon Amount".tr,
                                    subtitle: "$currency ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.couponAmount}",
                                  ),
                                ],

                                SizedBox(height: 5),
                                billSummaryTextDetaile(
                                  title: "Product Amount".tr,
                                  subtitle: "$currency ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.sitterAmount}",
                                ),
                                SizedBox(height: 5),
                                billSummaryTextDetaile(
                                  title: "Site Commission".tr,
                                  subtitle: "$currency ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.siteCommission}",
                                ),
                                SizedBox(height: 5),
                                billSummaryTextDetaile(
                                  title: "Total Price".tr,
                                  subtitle: "$currency ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.totPrice}",
                                ),
                                if( shopOrderDetailController.shopOrderDetailModel!.orderDetail!.transactionId != "")...[
                                  SizedBox(height: 5),
                                  billSummaryTextDetaile(
                                    title: "Transaction Id".tr,
                                    subtitle: "${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.transactionId}",
                                  ),
                                ],
                                SizedBox(height: 5),
                                billSummaryTextDetaile(
                                  title: "Payment Method".tr,
                                  subtitle:  shopOrderDetailController.shopOrderDetailModel!.orderDetail!.paymentName == ""
                                    ? "Pay form Wallet"
                                    : shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet == 0
                                      ? "${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.paymentName}"
                                      : shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet != 0 && shopOrderDetailController.shopOrderDetailModel!.orderDetail!.paymentName != ""
                                        ? "(Pay form Wallet) & ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.paymentName}"
                                        : "",
                                ),
                                SizedBox(height: 5),
                                billSummaryTextDetaile(
                                  title: "Address".tr,
                                  subtitle: "${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.houseNo}, ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.address}, ${shopOrderDetailController.shopOrderDetailModel!.orderDetail!.landmark}",
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: DottedLine(dashColor: greytext),
                                ),
                                if( shopOrderDetailController.shopOrderDetailModel!.orderDetail!.onlineAmount != 0)...[
                                  SizedBox(height: 5),
                                  billSummaryTextDetaile(
                                    title: "Online Payed".tr,
                                    subtitle: "$currency ${double.parse(shopOrderDetailController.shopOrderDetailModel!.orderDetail!.onlineAmount.toString()).toStringAsFixed(2)}",
                                  ),
                                ],
                                if( shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet != 0)...[
                                  SizedBox(height: 5),
                                  billSummaryTextDetaile(
                                    title: "Payed from Wallet".tr,
                                    subtitle: "$currency ${double.parse(shopOrderDetailController.shopOrderDetailModel!.orderDetail!.wallet.toString()).toStringAsFixed(2)}",
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }
              ),
              SizedBox(height: Get.height * 0.02),
            ],
          )
        : SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: gradient.defoultColor,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget stepper({required int status}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pending Step
        Column(
          children: [
            SizedBox(height: 7),
            Image.asset(
              "assets/trakersIcons/Pending_fill.png",
              height: 45,
              width: 45,
            ),
            SizedBox(height: 3),
            Text(
              "Pending".tr,
              style: TextStyle(
                fontSize: 11,
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
        Flexible(
          child: SizedBox(
            width: Get.width,
            child: DottedLine(
              dashColor: status >= 1 ? BlackColor : Colors.grey.shade300,
            ),
          ),
        ),

        // Processing Step
        Column(
          children: [
            Image.asset(
              status >= 1 && status != 4
                  ? "assets/trakersIcons/Processing_fill.png"
                  : "assets/trakersIcons/processing_grey.png",
              height: 55,
              width: 55,
            ),
            Text(
              "Processing".tr,
              style: TextStyle(
                fontSize: 11,
                color: status >= 1 && status != 4 ? BlackColor : greyColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
        Flexible(
          child: SizedBox(
            width: Get.width,
            child: DottedLine(
              dashColor: status >= 2 && status != 4
                  ? BlackColor
                  : Colors.grey.shade300,
            ),
          ),
        ),

        // Ready to Deliver Step
        Column(
          children: [
            Image.asset(
              status >= 2 && status != 4
                  ? "assets/trakersIcons/route-fill.png"
                  : "assets/trakersIcons/route_grey.png",
              height: 55,
              width: 55,
            ),
            Text(
              "On Route".tr,
              style: TextStyle(
                fontSize: 11,
                color: status >= 2 && status != 4 ? BlackColor : greyColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
        Flexible(
          child: SizedBox(
            width: Get.width,
            child: DottedLine(
              dashColor: status >= 3 ? BlackColor : Colors.grey.shade300,
            ),
          ),
        ),

        // Deliver Step
        Column(
          children: [
            Image.asset(
              status == 3
                  ? "assets/trakersIcons/complete_fill.png"
                  : status == 4
                      ? "assets/trakersIcons/cancel.png"
                      : "assets/trakersIcons/complete_grey.png",
              height: 50,
              width: 50,
            ),
            SizedBox(height: 3),
            Text(
              status == 3
                  ? "Deliver".tr
                  : status == 4
                      ? "Cancel".tr
                      : "Deliver".tr,
              style: TextStyle(
                fontSize: 11,
                color: status == 3
                    ? Colors.green
                    : status == 4
                        ? Colors.red
                        : greyColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
