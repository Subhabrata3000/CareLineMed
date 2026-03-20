import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/cart_shop_controller.dart';
import 'package:laundry/controller/payment_controller/payfast_payment_controller.dart';
import 'package:laundry/controller/payment_controller/senang_pay_controller.dart';
import 'package:laundry/controller/product_detail_controller.dart';
import 'package:laundry/screen/shop/my%20order/my_order_screen.dart';
import 'package:laundry/screen/shop/product.dart';
import 'package:laundry/widget/button.dart';
import 'package:laundry/widget/coupon_apply_sucsessfull.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Api/config.dart';
import '../../controller/address_list_controller.dart';
import '../../controller/checkout_controller.dart';
import '../../controller/payment_controller/flutterwave_controller.dart';
import '../../controller/payment_controller/midtrans_controller.dart';
import '../../controller/payment_controller/paypal_controller.dart';
import '../../controller/payment_controller/paystack_controller.dart';
import '../../controller/payment_controller/strip_controller.dart';
import '../../controller/payment_detail_controller.dart';
import '../../controller/shop_add_order_controller.dart';
import '../../controller/shop_coupon_controller.dart';
import '../../helpar/routes_helper.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import '../../utils/customwidget.dart';
import '../PaymentGateway/PaymentCard.dart';
import '../PaymentGateway/common_webview.dart';
import '../bottombarpro_screen.dart';
import '../paypal/flutter_paypal.dart';

class CheckoutScreen extends StatefulWidget {
  final String sitterId;
  final bool isUpdate;

  const CheckoutScreen(
      {super.key, required this.sitterId, required this.isUpdate});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var currency = "";

  CheckOutController checkOutController = Get.put(CheckOutController());
  PaymentDetailController paymentDetailController =
      Get.put(PaymentDetailController());
  StripController stripController = Get.put(StripController());
  PayStackController payStackController = Get.put(PayStackController());
  FlutterWaveController flutterWaveController =
      Get.put(FlutterWaveController());
  MidTransController midTransController = Get.put(MidTransController());
  PayPalController payPalController = Get.put(PayPalController());
  AddressListController addressListController =
      Get.put(AddressListController());
  ShopCouponController shopCouponController = Get.put(ShopCouponController());
  ShopAddOrderController shopAddOrderController =
      Get.put(ShopAddOrderController());
  ProductDetailController productDetailController =
      Get.put(ProductDetailController());
  SenangPayController senangPayController = Get.put(SenangPayController());
  PayfastPaymentController payfastPaymentController =
      Get.put(PayfastPaymentController());

  Future _functionApi() async {
    setState(() {});
    currency = getData.read("currency");
    checkOutController
        .checkOutApi(
      sitterId: widget.sitterId.toString(),
    )
        .then((value) async {
      if (value["Result"] == true) {}
    });
    addressListController.addressListApi(
        uid: "${getData.read("UserLogin")["id"]}");
    paymentDetailController.paymentDetailApi();
    shopCouponController.shopCouponApi(orderId: widget.sitterId);
    setState(() {});
  }

  @override
  void initState() {
    debugPrint("=========== sitterId ============= ${widget.sitterId}");
    checkOutController.isLoading = false;
    setState(() {});
    _functionApi();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    checkOutController.isLoading = false;
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    checkOutController.coverimagepath.clear();
    _razorpay.clear();
    super.dispose();
  }

  int? _groupValue;
  String? selectidPay = "0";
  String razorpaykey = "";
  String? paymenttital;
  int paymentSelect = 0;
  bool status = false;

  late Razorpay _razorpay;

  String couponCode = "";

  bool paymentLoading = false;

  addOrderApi({String? transactionID}) {
    paymentLoading = true;
    setState(() {});
    debugPrint(
        "----------- prescriptionRequire ------------ ${checkOutController.prescriptionRequire}");
    if (checkOutController.prescriptionRequire != 0) {
      debugPrint("----------- prescription Require ------------");
      if (checkOutController.coverimagepath.isNotEmpty) {
        checkOutController
            .addPatientApi(
          context: context,
          doctorId: widget.sitterId,
          images: checkOutController.coverimagepath,
        )
            .then((value) {
          debugPrint("------------- value ------------- $value");
          if (value["Result"] == true) {
            shopAddOrderController
                .shopAddOrderApi(
              uid: "${getData.read("UserLogin")["id"]}",
              sitterId: widget.sitterId,
              totalPrice:
                  double.parse(checkOutController.total.toStringAsFixed(1)),
              couponId: checkOutController.couponId == ""
                  ? ""
                  : checkOutController.couponId.toString(),
              couponAmount: checkOutController.couponAmt,
              sitterCommission: checkOutController.commission,
              address: checkOutController.addressId.toString(),
              walletAmount:
                  double.parse(checkOutController.useWallet.toStringAsFixed(2)),
              paymentId: "$paymentSelect",
              transactionId: transactionID ?? "",
            )
                .then(
              (value) {
                debugPrint("++++++++++++++++++++++++++++++ $value");
                if (value["Result"] == true) {
                  checkOutController.changeIndex(4);
                  productCartQuntityList.remove("dr_${widget.sitterId}");
                  setState(() {});
                  save("CartQuntry", productCartQuntityList);
                  debugPrint(
                      "================== CartQuntry ================ ${getData.read("CartQuntry")}");
                  Get.offAll(BottomBarScreen());
                  Get.to(MyOrderScreen());
                  Fluttertoast.showToast(msg: "${value["message"]}");
                  checkOutController.addresTitle = "";
                  paymentLoading = false;
                  setState(() {});
                } else {
                  paymentLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${value["message"]}")));
                }
              },
            );
          } else {
            paymentLoading = false;
            setState(() {});
            Fluttertoast.showToast(msg: value["message"]);
          }
        });
      } else {
        paymentLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: "Add Patient prescription".tr);
      }
    } else {
      debugPrint("----------- prescription not Require ------------");
      shopAddOrderController
          .shopAddOrderApi(
              uid: "${getData.read("UserLogin")["id"]}",
              sitterId: widget.sitterId,
              totalPrice:
                  double.parse(checkOutController.total.toStringAsFixed(1)),
              couponId: checkOutController.couponId == ""
                  ? ""
                  : checkOutController.couponId.toString(),
              couponAmount: checkOutController.couponAmt,
              sitterCommission: checkOutController.commission,
              address: checkOutController.addressId.toString(),
              walletAmount:
                  double.parse(checkOutController.useWallet.toStringAsFixed(2)),
              paymentId: "$paymentSelect",
              transactionId: transactionID ?? "")
          .then(
        (value) {
          debugPrint("++++++++++++++++++++++++++++++ $value");
          if (value["Result"] == true) {
            checkOutController.changeIndex(4);
            productCartQuntityList.remove("dr_${widget.sitterId}");
            setState(() {});
            save("CartQuntry", productCartQuntityList);
            debugPrint(
                "================== CartQuntry ================ ${getData.read("CartQuntry")}");
            Get.offAll(BottomBarScreen());
            Get.to(MyOrderScreen());
            Fluttertoast.showToast(msg: "${value["message"]}");
            checkOutController.addresTitle = "";
            paymentLoading = false;
            setState(() {});
          } else {
            paymentLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("${value["message"]}")));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        checkOutController.addressId = "";
        checkOutController.addresTitle = "";
        checkOutController.total = 0.0;
        checkOutController.tempWallet = 0.0;
        checkOutController.useWallet = 0.0;
        checkOutController.couponAmt = 0;

        Get.back();
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: BlackColor),
          backgroundColor: WhiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Checkout".tr,
            style: TextStyle(
              fontSize: 17,
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
            ),
          ),
        ),
        body: GetBuilder<CheckOutController>(
          builder: (checkOutController) {
            return checkOutController.isLoading
                ? Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: Get.size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: WhiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Details".tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: checkOutController
                                        .checkOutModel!.productList!.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(color: greyColor),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/ezgif.com-crop.gif",
                                                      placeholderCacheWidth: 60,
                                                      placeholderCacheHeight:
                                                          60,
                                                      image:
                                                          "${Config.imageBaseurlDoctor}${checkOutController.checkOutModel!.productList![index].productImage}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      checkOutController
                                                                  .checkOutModel!
                                                                  .productList![
                                                                      index]
                                                                  .prescriptionRequire ==
                                                              "Unrequired"
                                                          ? SizedBox()
                                                          : Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/prescription.png",
                                                                  height: 10,
                                                                  color: const Color(
                                                                      0xFFA30202),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  "Prescription Require"
                                                                      .tr,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyBold,
                                                                    color: const Color(
                                                                        0xFFA30202),
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        "${checkOutController.checkOutModel!.productList![index].productName}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          color: BlackColor,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        "${checkOutController.checkOutModel!.productList![index].proType}",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          color: greycolor,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  walletCalculation(false);
                                                  setState(() {});
                                                  checkOutController.useWallet =
                                                      0;
                                                  checkOutController.couponAmt =
                                                      0;
                                                  couponCode = "";
                                                  setState(() {});
                                                  cartAddItemsBottomSheet(
                                                          productId:
                                                              checkOutController
                                                                  .checkOutModel!
                                                                  .productList![
                                                                      index]
                                                                  .id!,
                                                          productListData:
                                                              checkOutController
                                                                  .checkOutModel!
                                                                  .productList![
                                                                      index]
                                                                  .toJson(),
                                                          i: index)
                                                      .then((value) {
                                                    setState(() {});
                                                    save("CartQuntry",
                                                        productCartQuntityList);
                                                  });
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 70,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: gradient
                                                            .defoultColor),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(
                                                        Icons.remove,
                                                        color: gradient
                                                            .defoultColor,
                                                        size: 18,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "${productCartQuntityList["dr_${widget.sitterId}"]["${checkOutController.checkOutModel!.productList![index].id}"]["tot_product_qty"]}",
                                                          style: TextStyle(
                                                            color: gradient
                                                                .defoultColor,
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.add,
                                                        color: gradient
                                                            .defoultColor,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "${checkOutController.checkOutModel!.productList![index].priceDetail!.length} ${"options".tr}",
                                                style: TextStyle(
                                                  color: gradient.defoultColor,
                                                  fontSize: 11,
                                                  fontFamily:
                                                      FontFamily.gilroyRegular,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (checkOutController.prescriptionRequire !=
                                0) ...[
                              SizedBox(height: 10),
                              Container(
                                width: Get.size.width,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: WhiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Your Uploaded Prescription".tr,
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: textcolor),
                                            ),
                                            checkOutController
                                                    .coverimagepath.isEmpty
                                                ? SizedBox()
                                                : InkWell(
                                                    onTap: () =>
                                                        checkOutController
                                                            .showPicker(
                                                                context:
                                                                    context),
                                                    child: Text(
                                                      "+ ${"Add More".tr}",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        fontSize: 15,
                                                        color: gradient
                                                            .defoultColor,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        checkOutController
                                                .coverimagepath.isNotEmpty
                                            ? GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                ),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: checkOutController
                                                    .coverimagepath.length,
                                                itemBuilder: (context, index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topRight,
                                                      children: [
                                                        Image.file(
                                                          File(checkOutController
                                                              .coverimagepath[
                                                                  index]
                                                              .toString()),
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Positioned(
                                                          right: -10,
                                                          top: -10,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              debugPrint(
                                                                  "-------------- coverimagepath 1 ------------- ${checkOutController.coverimagepath}");
                                                              setState(() {
                                                                checkOutController
                                                                    .coverimagepath
                                                                    .remove(checkOutController
                                                                            .coverimagepath[
                                                                        index]);
                                                              });
                                                              debugPrint(
                                                                  "-------------- coverimagepath 2 ------------- ${checkOutController.coverimagepath}");
                                                            },
                                                            icon: const Icon(
                                                              Icons.cancel,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                height: 100,
                                                width: Get.width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Get.width / 5,
                                                    vertical: 25),
                                                decoration: BoxDecoration(),
                                                child: InkWell(
                                                  onTap: () =>
                                                      checkOutController
                                                          .showPicker(
                                                              context: context),
                                                  child: DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: primeryColor,
                                                    radius: Radius.circular(15),
                                                    child: Center(
                                                      child: Text(
                                                        "+ ${"Add Prescription".tr}",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 15,
                                                          color: gradient
                                                              .defoultColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (checkOutController
                                    .checkOutModel!.walletAmount! >
                                0) ...[
                              SizedBox(height: 10),
                              Container(
                                width: Get.size.width,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: WhiteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Pay from Wallet".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 16,
                                            color: BlackColor,
                                          ),
                                        ),
                                        Spacer(),
                                        Transform.scale(
                                          scale: 0.7,
                                          child: CupertinoSwitch(
                                            inactiveTrackColor: greyColor,
                                            activeTrackColor:
                                                gradient.defoultColor,
                                            value: status,
                                            onChanged: (value) {
                                              setState(() {
                                                status = value;
                                                walletCalculation(value);
                                                debugPrint(
                                                    "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz${checkOutController.tempWallet}");
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/wallet.png",
                                            height: 25,
                                            width: 25,
                                            color: gradient.defoultColor,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "My Wallet".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "$currency${checkOutController.tempWallet.toStringAsFixed(2)}",
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
                              ),
                            ],
                            SizedBox(height: 10),
                            Container(
                              width: Get.size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (couponCode == "") {
                                    status = false;
                                    walletCalculation(false);
                                    setState(() {});
                                    shopCouponController.shopCouponApi(
                                        orderId: widget.sitterId.toString());
                                    Get.toNamed(Routes.shopCouponScreen,
                                            arguments: {
                                          "price": checkOutController.total,
                                          "orderId": widget.sitterId.toString()
                                        })!
                                        .then((value) {
                                      setState(() {
                                        couponCode = value;
                                      });
                                      couponSucsessFullyApplyed(
                                          couponAmt:
                                              "${checkOutController.couponAmt}");
                                    });
                                  } else {
                                    status = false;
                                    walletCalculation(false);
                                    setState(() {});

                                    checkOutController.useWallet = 0;

                                    checkOutController.couponAmt = 0;
                                    couponCode = "";
                                    setState(() {});
                                  }
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/badge-discount.png",
                                              height: 30,
                                              width: 30,
                                              color: gradient.defoultColor,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Apply Coupon".tr,
                                                    style: TextStyle(
                                                      color:
                                                          gradient.defoultColor,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  couponCode != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "${"Use code".tr} : ",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .gilroyMedium,
                                                              ),
                                                            ),
                                                            Text(
                                                              couponCode,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .gilroyBold,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                            couponCode != ""
                                                ? InkWell(
                                                    onTap: () {
                                                      status = false;
                                                      walletCalculation(false);
                                                      setState(() {});

                                                      couponCode = "";
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      "Remove".tr,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        color: RedColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      if (couponCode == "") {
                                                        status = false;
                                                        walletCalculation(
                                                            false);
                                                        setState(() {});
                                                        shopCouponController
                                                            .shopCouponApi(
                                                                orderId: widget
                                                                    .sitterId
                                                                    .toString());
                                                        Get.toNamed(
                                                                Routes
                                                                    .shopCouponScreen,
                                                                arguments: {
                                                              "price":
                                                                  checkOutController
                                                                      .total,
                                                              "orderId": widget
                                                                  .sitterId
                                                                  .toString()
                                                            })!
                                                            .then((value) {
                                                          setState(() {
                                                            couponCode = value;
                                                          });
                                                          couponSucsessFullyApplyed(
                                                              couponAmt:
                                                                  "${checkOutController.couponAmt}");
                                                        });
                                                      } else {
                                                        status = false;
                                                        walletCalculation(
                                                            false);
                                                        setState(() {});

                                                        couponCode = "";
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Text(
                                                      "Apply".tr,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        color: gradient
                                                            .defoultColor,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Divider(color: greyColor)),
                                    InkWell(
                                      onTap: () {
                                        if (couponCode == "") {
                                          status = false;
                                          walletCalculation(false);
                                          setState(() {});
                                          shopCouponController.shopCouponApi(
                                              orderId:
                                                  widget.sitterId.toString());
                                          Get.toNamed(
                                            Routes.shopCouponScreen,
                                            arguments: {
                                              "price": checkOutController.total,
                                              "orderId":
                                                  widget.sitterId.toString()
                                            },
                                          )!
                                              .then((value) {
                                            setState(() {
                                              couponCode = value;
                                            });
                                            couponSucsessFullyApplyed(
                                                couponAmt:
                                                    "${checkOutController.couponAmt}");
                                          });
                                        } else {
                                          status = false;
                                          walletCalculation(false);
                                          setState(() {});

                                          couponCode = "";
                                          setState(() {});
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(
                                            "View all coupons".tr,
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 15,
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: greyColor,
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: Get.size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: WhiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            GetBuilder<AddressListController>(
                                          builder: (addressListModel) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                checkOutController
                                                            .addresTitle ==
                                                        ""
                                                    ? Text(
                                                        "Select deliver address"
                                                            .tr,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          fontSize: 17,
                                                        ),
                                                      )
                                                    : Text(
                                                        checkOutController
                                                            .addresTitle,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "We deliver the product to this address."
                                                      .tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          addressListController.addressListApi(
                                              uid:
                                                  "${getData.read("UserLogin")["id"]}");
                                          addressShit()
                                              .then((value) => setState(() {}));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/location-pin.svg",
                                                height: 25,
                                                width: 25,
                                                color: gradient.defoultColor,
                                              ),
                                              SizedBox(width: 8),
                                              Image.asset(
                                                "assets/angle-down.png",
                                                height: 15,
                                                width: 15,
                                                color: gradient.defoultColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: Get.size.width,
                              // margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Review your requirements for this request"
                                        .tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  billSummaryTextCart(
                                    title: "Shop total".tr,
                                    subtitle:
                                        "${checkOutController.subtotal}$currency",
                                  ),
                                  SizedBox(height: 10),
                                  DottedLine(dashColor: greyColor),
                                  SizedBox(height: 10),
                                  checkOutController.checkOutModel!.comData!
                                              .commisiionType ==
                                          "fix"
                                      ? billSummaryTextCart(
                                          title:
                                              "${"Commission Rate".tr} (${checkOutController.checkOutModel!.comData!.commisiionType})",
                                          subtitle:
                                              "+${double.parse("${checkOutController.checkOutModel!.comData!.commissionRate}").toStringAsFixed(1)}$currency",
                                        )
                                      : billSummaryTextCart(
                                          title:
                                              "${"Commission Rate".tr} (${checkOutController.checkOutModel!.comData!.commissionRate}${checkOutController.checkOutModel!.comData!.commisiionType})",
                                          subtitle:
                                              "+${checkOutController.commission}$currency",
                                        ),
                                  if (status) ...[
                                    SizedBox(height: 10),
                                    DottedLine(dashColor: greyColor),
                                    SizedBox(height: 10),
                                    billSummaryTextCart(
                                      title: "Wallet".tr,
                                      subtitle:
                                          "-${checkOutController.useWallet.toStringAsFixed(2)}$currency",
                                    ),
                                  ],
                                  if (couponCode != "") ...[
                                    SizedBox(height: 10),
                                    DottedLine(dashColor: greyColor),
                                    SizedBox(height: 10),
                                    billSummaryTextCart(
                                      title: "Coupon".tr,
                                      subtitle:
                                          "-${checkOutController.couponAmt}$currency",
                                    ),
                                  ],
                                  SizedBox(height: 10),
                                  DottedLine(dashColor: greyColor),
                                  SizedBox(height: 10),
                                  billSummaryTextCart(
                                    title: "Total Payable Amount".tr,
                                    subtitle:
                                        "${checkOutController.total.toStringAsFixed(1)}$currency",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (paymentLoading) ...[
                        Container(
                          width: Get.width,
                          height: Get.height,
                          decoration: BoxDecoration(
                            color: bgcolor.withOpacity(0.5),
                          ),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: primeryColor),
                          ),
                        ),
                      ],
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                        color: gradient.defoultColor));
          },
        ),
        bottomNavigationBar: GetBuilder<CheckOutController>(
          builder: (checkOutController) {
            return checkOutController.isLoading
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: WhiteColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Price".tr,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: FontFamily.gilroyMedium,
                                color: greycolor,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "$currency${checkOutController.total.toStringAsFixed(1)}",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: paymentLoading
                              ? loaderButton()
                              : button(
                                  text: "Continue Total Payable Amount".tr,
                                  color: gradient.defoultColor,
                                  onPress: () {
                                    if (checkOutController.prescriptionRequire >
                                        0) {
                                      if (checkOutController
                                              .coverimagepath.isNotEmpty &&
                                          checkOutController
                                              .addresTitle.isNotEmpty) {
                                        checkOutController.total == 0
                                            ? addOrderApi()
                                            : paymentSheet();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Patient prescription & address required"
                                                    .tr);
                                      }
                                    } else {
                                      if (checkOutController
                                          .addresTitle.isNotEmpty) {
                                        checkOutController.total == 0
                                            ? addOrderApi()
                                            : paymentSheet();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please select address".tr);
                                      }
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  )
                : SizedBox();
          },
        ),
      ),
    );
  }

  Future cartAddItemsBottomSheet({
    required int productId,
    required int i,
    required Map productListData,
  }) {
    CartShopController cartShopController = Get.put(CartShopController());

    List isLoadingData =
        List.filled(productListData["price_detail"].length, false);

    debugPrint("---------------- isLoadingData --------------- $isLoadingData");

    return showModalBottomSheet(
      context: context,
      backgroundColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                        Get.back();
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
              StatefulBuilder(builder: (context, setState) {
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
                                image:
                                    "${Config.imageBaseurlDoctor}${productListData["product_image"]}",
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
                                        text:
                                            "${getData.read("currency")} ${productListData["price_detail"][index]["price"]} ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                "${getData.read("currency")} ${productListData["price_detail"][index]["base_price"]}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  FontFamily.gilroyMedium,
                                              color: greycolor,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
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
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      color: gradient.defoultColor,
                                      size: 25,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              int productQuntity = int.parse(
                                                  "${productListData["price_detail"][index]["cart_qty"]}");
                                              debugPrint(
                                                  "-------------- productQuntity ------------ $productQuntity");
                                              if (cartShopController.isCircle ==
                                                  false) {
                                                cartShopController.isCircle =
                                                    true;
                                                isLoadingData[index] = true;
                                                setState(() {});
                                                if (productQuntity > 1) {
                                                  debugPrint(
                                                      "-------------- log 1 ------------");

                                                  setState(() {
                                                    cartShopController
                                                        .cartShopApi(
                                                      uid:
                                                          "${getData.read("UserLogin")["id"]}",
                                                      sitterId: widget.sitterId
                                                          .toString(),
                                                      prodId:
                                                          "${productListData["id"]}",
                                                      proPrice: int.parse(
                                                          "${productListData["price_detail"][index]["price"]}"),
                                                      propType:
                                                          "${productListData["price_detail"][index]["title"]}",
                                                      proQty: productQuntity,
                                                      mode: "1",
                                                      proQtyType: 2,
                                                    )
                                                        .then((value) {
                                                      productQuntity--;

                                                      int totalQuantity = 0;

                                                      debugPrint(
                                                          "-------------- totalQuantity ------------ $totalQuantity");

                                                      setState(() {});
                                                      productCartQuntityList[
                                                                      "dr_${widget.sitterId}"]
                                                                  ["$productId"]
                                                              [
                                                              "tot_product_qty"] =
                                                          "$totalQuantity";

                                                      debugPrint(
                                                          "================== productQuntityList ================ $productCartQuntityList");

                                                      save("CartQuntry",
                                                          productCartQuntityList);
                                                      debugPrint(
                                                          "================== CartQuntry ================ ${getData.read("CartQuntry")}");
                                                      isLoadingData[index] =
                                                          false;
                                                      setState(() {});
                                                    });
                                                  });
                                                } else if (productQuntity > 0) {
                                                  debugPrint(
                                                      "-------------- log 2 ------------");
                                                  setState(() {
                                                    cartShopController
                                                        .cartShopApi(
                                                      uid:
                                                          "${getData.read("UserLogin")["id"]}",
                                                      sitterId: widget.sitterId
                                                          .toString(),
                                                      prodId:
                                                          "${productListData["id"]}",
                                                      proPrice: int.parse(
                                                          "${productListData["price_detail"][index]["price"]}"),
                                                      propType:
                                                          "${productListData["price_detail"][index]["title"]}",
                                                      proQty: productQuntity,
                                                      mode: "2",
                                                      proQtyType: 2,
                                                    )
                                                        .then((value) {
                                                      productQuntity--;
                                                      debugPrint(
                                                          "-------------- subtotal 1 ------------ ${checkOutController.subtotal}");

                                                      setState(() {});

                                                      save("CartQuntry",
                                                          productCartQuntityList);

                                                      checkOutController
                                                          .checkOutApi(
                                                              sitterId: widget
                                                                  .sitterId)
                                                          .then((value) {
                                                        if (value["Result"] ==
                                                            true) {
                                                          if (checkOutController
                                                              .checkOutModel!
                                                              .productList!
                                                              .isEmpty) {
                                                            Get.close(2);
                                                          } else {
                                                            Get.back();
                                                          }
                                                          isLoadingData[index] =
                                                              false;
                                                          setState(() {});
                                                        }
                                                      });
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
                                        "${productListData["price_detail"][index]["title"]}" ==
                                                "${productCartQuntityList["dr_${widget.sitterId}"]["$productId"]["cart_qty_title"][index]}"
                                            ? ""
                                            : "${productListData["price_detail"][index]["cart_qty"]}",
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
                                              debugPrint(
                                                  "-------------- log 3 ------------");
                                              if (cartShopController.isCircle ==
                                                  false) {
                                                cartShopController.isCircle =
                                                    true;
                                                isLoadingData[index] = true;
                                                setState(() {});

                                                int productQuntity = int.parse(
                                                    "${productListData["price_detail"][index]["cart_qty"]}");
                                                debugPrint(
                                                    "-------------- productQuntity ------------ $productQuntity");

                                                setState(() {
                                                  cartShopController
                                                      .cartShopApi(
                                                          uid:
                                                              "${getData.read("UserLogin")["id"]}",
                                                          sitterId: widget
                                                              .sitterId
                                                              .toString(),
                                                          prodId:
                                                              "${productListData["id"]}",
                                                          proPrice: int.parse(
                                                              "${productListData["price_detail"][index]["price"]}"),
                                                          propType:
                                                              "${productListData["price_detail"][index]["title"]}",
                                                          proQty:
                                                              productQuntity,
                                                          mode: "1",
                                                          proQtyType: 1)
                                                      .then((value) {
                                                    productQuntity++;
                                                    setState(() {});
                                                    debugPrint(
                                                        "-------------- subtotal 1 ------------ ${checkOutController.subtotal}");

                                                    debugPrint(
                                                        "-------------- cart_qty_title ------------ ${productCartQuntityList["dr_${widget.sitterId}"]["$productId"]["cart_qty_title"]}");
                                                    setState(() {});
                                                    int totalQuantity = 0;

                                                    debugPrint(
                                                        "-------------- totalQuantity ------------ $totalQuantity");

                                                    setState(() {});
                                                    productCartQuntityList[
                                                                    "dr_${widget.sitterId}"]
                                                                ["$productId"][
                                                            "tot_product_qty"] =
                                                        "$totalQuantity";

                                                    isLoadingData[index] =
                                                        false;
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
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: greyColor),
                );
              }),
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

  walletCalculation(value) {
    if (value == true) {
      if (double.parse(
              checkOutController.checkOutModel!.walletAmount.toString()) <
          double.parse(checkOutController.total.toString())) {
        setState(() {});
      }
    } else {
      checkOutController.tempWallet = 0;
      checkOutController.tempWallet = double.parse(
          checkOutController.checkOutModel!.walletAmount.toString());

      status = false;
      setState(() {});
    }
  }

  Future addressShit({String? isCheck}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.72,
              ),
              width: Get.size.width,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Choose a delivery address".tr,
                      style: TextStyle(
                        color: BlackColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.deliveryaddress1);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 35,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: gradient.defoultColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: gradient.defoultColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: Get.size.width * 0.5,
                          child: Text(
                            "Add New Address".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: gradient.defoultColor,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  GetBuilder<AddressListController>(
                    builder: (addressListController) {
                      return Flexible(
                        child: addressListController.isLoading
                            ? addressListController
                                    .addressListModel!.addressList!.isNotEmpty
                                ? ListView.separated(
                                    itemCount: addressListController
                                        .addressListModel!.addressList!.length,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 13),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              checkOutController.addresTitle =
                                                  "${addressListController.addressListModel!.addressList![index].address}";
                                              checkOutController.addressId =
                                                  addressListController
                                                      .addressListModel!
                                                      .addressList![index]
                                                      .id
                                                      .toString();
                                              debugPrint(
                                                  "adwdjgcjydchbdchdvc ${checkOutController.addressId}");
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                              width: Get.size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${addressListController.addressListModel!.addressList![index].addressAs} Address",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 17,
                                                      color: BlackColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.phone,
                                                        size: 19,
                                                        color: CupertinoColors
                                                            .activeGreen,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        "${addressListController.addressListModel!.addressList![index].countryCode} ${addressListController.addressListModel!.addressList![index].phone}",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 15,
                                                          color: greycolor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 19,
                                                        color: gradient
                                                            .defoultColor,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Expanded(
                                                        child: Text(
                                                          "${addressListController.addressListModel!.addressList![index].address}",
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: greycolor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      "Add Your Address".tr,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 15,
                                        color: BlackColor,
                                      ),
                                    ),
                                  )
                            : Center(
                                child: CircularProgressIndicator(
                                    color: gradient.defoultColor)),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future paymentSheet() {
    return showModalBottomSheet(
      backgroundColor: WhiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: Get.height / 80,
                    width: Get.width / 5,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 50),
                Row(
                  children: [
                    SizedBox(width: Get.width / 14),
                    Text(
                      "Select Payment Method".tr,
                      style: TextStyle(
                        color: BlackColor,
                        fontSize: Get.height / 40,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height / 50),
                //! --------- List view payment ----------
                SizedBox(
                  height: Get.height * 0.50,
                  child: GetBuilder<PaymentDetailController>(
                    builder: (paymentDetailController) {
                      return paymentDetailController.isLoading
                          ? ListView.separated(
                              itemCount: paymentDetailController
                                  .paymentDetailModel!.paymentList.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return paymentDetailController
                                            .paymentDetailModel!
                                            .paymentList[index]
                                            .name ==
                                        "Cash"
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            paymenttital =
                                                paymentDetailController
                                                    .paymentDetailModel!
                                                    .paymentList[index]
                                                    .name;
                                            paymentSelect =
                                                paymentDetailController
                                                    .paymentDetailModel!
                                                    .paymentList[index]
                                                    .id;
                                            razorpaykey =
                                                paymentDetailController
                                                    .paymentDetailModel!
                                                    .paymentList[index]
                                                    .attribute;
                                            _groupValue = index;
                                            debugPrint(
                                                "------------ payment Select --------- $paymentSelect");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: paymentSelect ==
                                                      paymentDetailController
                                                          .paymentDetailModel!
                                                          .paymentList[index]
                                                          .id
                                                  ? gradient.defoultColor
                                                  : Colors.grey
                                                      .withOpacity(0.4),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.network(
                                                  "${Config.imageBaseurlDoctor}${paymentDetailController.paymentDetailModel!.paymentList[index].image}",
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      paymentDetailController
                                                          .paymentDetailModel!
                                                          .paymentList[index]
                                                          .name,
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    SizedBox(
                                                      width: 190,
                                                      child: Text(
                                                        paymentDetailController
                                                            .paymentDetailModel!
                                                            .paymentList[index]
                                                            .subTitle,
                                                        style: TextStyle(
                                                          color: BlackColor,
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          fontSize: 13,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Radio(
                                                activeColor:
                                                    gradient.defoultColor,
                                                value: index,
                                                groupValue: _groupValue,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  color: gradient.defoultColor));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: paymentLoading
                      ? loaderButton()
                      : button(
                          text: "Continue".tr,
                          color: gradient.defoultColor,
                          onPress: () async {
                            // //!---- Payment ------
                            if (paymentLoading == false && paymentSelect != 0) {
                              paymentLoading = true;
                              setState(() {});
                              if (paymenttital == "Razorpay") {
                                checkOutController.setOrderLoading();
                                // Get.back();
                                openCheckout();
                              } else if (paymenttital == "Paypal") {
                                checkOutController.setOrderLoading();
                                List<String> keyList = razorpaykey.split(",");
                                debugPrint("dsdsdsdc $keyList");
                                paypalPayment(
                                  function: (e, t) {
                                    debugPrint(
                                        "=========== transaction Id ============ $t");
                                    addOrderApi(transactionID: t);
                                  },
                                  context: context,
                                  amt: checkOutController.total.toString(),
                                  clientId: keyList[0],
                                  secretKey: keyList[1],
                                );
                                debugPrint(
                                    "=========== client Id ============ ${keyList[0]}");
                                debugPrint(
                                    "========== secretKey Id ========== ${keyList[1]}");
                              } else if (paymenttital == "Stripe") {
                                stripController
                                    .stripApi(
                                  uid: "${getData.read("UserLogin")["id"]}",
                                  amount: checkOutController.total.toString(),
                                )
                                    .then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["StripeURL"],
                                        navigationDelegate: (request) {
                                          final uri = Uri.parse(request.url);
                                          debugPrint(
                                              "************ Navigating to URL: ${request.url}");
                                          debugPrint(
                                              "************ Parsed URI: $uri");
                                          debugPrint(
                                              "************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint(
                                              "************ payment_intent: ${uri.queryParameters["payment_intent"]}");
                                          if (request.url
                                                  .toString()
                                                  .contains("success") ==
                                              true) {
                                            stripController
                                                .stripSuccessGetDataApi(
                                                    paymentIntent:
                                                        "${uri.queryParameters["payment_intent"]}")
                                                .then((value) {
                                              if (value["status"] == true) {
                                                debugPrint(
                                                    "************ transactionId: ${value["transactionId"]}");
                                                addOrderApi(
                                                    transactionID:
                                                        value["transactionId"]);
                                              } else {
                                                paymentLoading = false;
                                                setState(() {});
                                                Get.back();
                                                showToastMessage(
                                                    "${value["message"]}");
                                              }
                                            });
                                            return NavigationDecision.prevent;
                                          } else if (request.url
                                                  .toString()
                                                  .contains("cancel") ==
                                              false) {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                          return NavigationDecision.navigate;
                                        },
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "PayStack") {
                                payStackController
                                    .payStackApi(
                                  uid: "${getData.read("UserLogin")["id"]}",
                                  amount: checkOutController.total.toString(),
                                )
                                    .then((value) {
                                  debugPrint(
                                      "<><><><><><><><> value <><><><><><><><> $value");
                                  if (value["status"] == true) {
                                    Get.to(PaymentWebVIew(
                                      initialUrl: value["PaystackURL"],
                                      navigationDelegate: (request) {
                                        final uri = Uri.parse(request.url);
                                        debugPrint(
                                            "************ Navigating to URL: ${request.url}");
                                        debugPrint(
                                            "************ Parsed URI: $uri");
                                        debugPrint(
                                            "************ queryParamiter: ${uri.queryParametersAll}");
                                        debugPrint(
                                            "************ trxref: ${uri.queryParameters["trxref"]}");
                                        debugPrint(
                                            "************ reference: ${uri.queryParameters["reference"]}");
                                        if (uri.queryParameters["trxref"] !=
                                                null &&
                                            uri.queryParameters["reference"] !=
                                                null) {
                                          payStackController
                                              .payStackSuccessGetDataApi(
                                            trxref:
                                                "${uri.queryParameters["trxref"]}",
                                            reference:
                                                "${uri.queryParameters["reference"]}",
                                          )
                                              .then((value) {
                                            debugPrint(
                                                "************ value: $value");
                                            if (value["status"] == true) {
                                              addOrderApi(
                                                  transactionID:
                                                      "${value["transactionId"]}");
                                            } else {
                                              paymentLoading = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage(
                                                  "${value["message"]}");
                                            }
                                          });
                                          return NavigationDecision.prevent;
                                        } else {
                                          paymentLoading = false;
                                          setState(() {});
                                          Get.back();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Order not placed")));
                                          return NavigationDecision.navigate;
                                        }
                                      },
                                    ));
                                  } else {
                                    paymentLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "FlutterWave") {
                                flutterWaveController
                                    .flutterWaveApi(
                                  amount: checkOutController.total.toString(),
                                  uid: "${getData.read("UserLogin")["id"]}",
                                )
                                    .then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["FlutterwaveURL"],
                                        navigationDelegate: (request) async {
                                          final uri = Uri.parse(request.url);
                                          debugPrint(
                                              "************ Navigating to URL: ${request.url}");
                                          debugPrint(
                                              "************ Parsed URI: $uri");
                                          debugPrint(
                                              "************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint(
                                              "************ status: ${uri.queryParameters["status"]}");
                                          if (uri.queryParameters["status"] !=
                                              null) {
                                            if (uri.queryParameters["status"] ==
                                                "successful") {
                                              flutterWaveController
                                                  .flutterWaveSuccessGetDataApi(
                                                txref:
                                                    "${uri.queryParameters["tx_ref"]}",
                                                transactionId:
                                                    "${uri.queryParameters["transaction_id"]}",
                                              )
                                                  .then((value) {
                                                if (value["status"] == true) {
                                                  addOrderApi(
                                                      transactionID:
                                                          "${value["transactionId"]}");
                                                } else {
                                                  paymentLoading = false;
                                                  setState(() {});
                                                  Get.back();
                                                  showToastMessage(
                                                      "${value["message"]}");
                                                }
                                              });
                                              return NavigationDecision.prevent;
                                            } else {
                                              paymentLoading = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage(
                                                  "${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    paymentLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "Paytm") {
                              } else if (paymenttital == "SenangPay") {
                                senangPayController
                                    .senangPayApi(
                                        amount: "${checkOutController.total}")
                                    .then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["SenangPayURL"],
                                        navigationDelegate: (request) {
                                          final uri = Uri.parse(request.url);
                                          debugPrint(
                                              "************ Navigating to URL: ${request.url}");
                                          debugPrint(
                                              "************ Parsed URI: $uri");
                                          debugPrint(
                                              "************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint(
                                              "************ status: ${uri.queryParameters["status"]}");
                                          if (uri.queryParameters["status"] !=
                                              null) {
                                            if (uri.queryParameters["status"] ==
                                                "successful") {
                                              return NavigationDecision.prevent;
                                            } else {
                                              paymentLoading = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage(
                                                  "${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    paymentLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "MercadoPago") {
                              } else if (paymenttital == "Payfast") {
                                payfastPaymentController
                                    .payfastPaymentApi(
                                  amount: checkOutController.total.toString(),
                                )
                                    .then((value) {
                                  if (value["status"] == true) {
                                    debugPrint(
                                        "-------------- value[payFastLink] ----------- ${value["payFastLink"]}");
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["payFastLink"],
                                        navigationDelegate: (request) async {
                                          final uri = Uri.parse(request.url);
                                          debugPrint(
                                              "************ Navigating to URL: ${request.url}");
                                          debugPrint(
                                              "************ Parsed URI: $uri");
                                          debugPrint(
                                              "************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint(
                                              "************ return_url: ${uri.queryParameters["return_url"]}");
                                          if (uri
                                              .queryParametersAll.isNotEmpty) {
                                            Uri returnUrl = Uri.parse(
                                                "${uri.queryParameters["return_url"]}");
                                            String transactionId =
                                                "${returnUrl.queryParameters['transactionId']}";
                                            debugPrint(
                                                "-------------- transactionId ----------- $transactionId");
                                            await payfastPaymentController
                                                .payfastSuccessGetDataApi(
                                                    transactionId:
                                                        transactionId)
                                                .then((value) {
                                              if (value["status"] == true) {
                                                addOrderApi(
                                                    transactionID:
                                                        "${value["transactionId"]} ");
                                              } else {
                                                paymentLoading = false;
                                                setState(() {});
                                              }
                                            });
                                            return NavigationDecision.prevent;
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    paymentLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "Midtrans") {
                                midTransController
                                    .midTransApi(
                                  amount: checkOutController.total.toString(),
                                )
                                    .then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["MidtransURL"],
                                        navigationDelegate: (request) {
                                          final uri = Uri.parse(request.url);

                                          if (uri.queryParameters[
                                                  "status_code"] !=
                                              null) {
                                            if (uri.queryParameters[
                                                    "status_code"] ==
                                                "200") {
                                              midTransController
                                                  .midTransSuccessGetDataApi(
                                                      orderId:
                                                          "${uri.queryParameters["order_id"]}")
                                                  .then((value) {

                                                if (value["status"] == true) {
                                                  addOrderApi(
                                                      transactionID:
                                                          "${value["transactionId"]} ");
                                                } else {
                                                  paymentLoading = false;
                                                  setState(() {});
                                                  Get.back();
                                                  showToastMessage(
                                                      "${value["message"]}");
                                                }
                                              });
                                              return NavigationDecision.prevent;
                                            } else {
                                              paymentLoading = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage(
                                                  "${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    paymentLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("${value["message"]}")));
                                  }
                                });
                              }
                            } else {
                              showToastMessage("Select Payment Method!");
                            }
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //!--------- Razorpay ----------//

  void openCheckout() async {
    var username = "${getData.read("UserLogin")["name"]}";
    var mobile = "${getData.read("UserLogin")["phone"]}";
    var email = "${getData.read("UserLogin")["email"]}";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(checkOutController.total.toString()) * 100)
          .toStringAsFixed(2),
      'name': username,
      'description': "",
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };
    debugPrint("$options");
    try {
      _razorpay.open(options);
    } catch (e) {
      paymentLoading = false;
      setState(() {});
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    addOrderApi(transactionID: "${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint(
        'Error Response: ${"ERROR: ${response.code} - ${response.message!}"}');
    setState(() {
      checkOutController.isOrderLoading = false;
    });
    showToastMessage(response.message!);
    paymentLoading = false;
    setState(() {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    paymentLoading = false;
    setState(() {});
    showToastMessage(response.walletName!);
  }

  //!--------- PayPal ----------//

  paypalPayment({
    required String amt,
    required String clientId,
    required String secretKey,
    var function,
    context,
  }) {
    // Get.back();
    payPalController
        .paypalApi(
      uid: "${getData.read("UserLogin")["id"]}",
      amount: checkOutController.total.toString(),
    )
        .then((value) {
      if (value["status"] == true) {
        debugPrint("csfcdscdsc ${value["status"]}");
        debugPrint("++++++++++ ${value["paypalURL"]}");
        Get.to(UsePaypal(
          sandboxMode: true,
          clientId: clientId,
          secretKey: secretKey,
          returnURL: value["paypalURL"],
          cancelURL: Config.baseUrlDoctor + Config.cancelPaypal,
          transactions: [
            {
              "amount": {
                "total": amt,
                "currency": "USD",
                "details": {
                  "subtotal": amt,
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": amt,
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) {
            // ✅ Get transaction ID safely
            final transactionId = params['data']?['transactions']?[0]
                ?['related_resources']?[0]?['sale']?['id'];

            debugPrint("✅ TRANSACTION ID: $transactionId");

            // Optional: Call your function and pass transactionId if needed
            function(params, transactionId);

            Fluttertoast.showToast(
              msg:
                  'SUCCESS PAYMENT : ${params["status"]}\nTransaction ID: $transactionId',
              timeInSecForIosWeb: 4,
            );

            paymentLoading = false;
            setState(() {});
          },
          onError: (error) {
            Fluttertoast.showToast(
                msg: error.toString(), timeInSecForIosWeb: 4);
            paymentLoading = false;
            setState(() {});
          },
          onCancel: (params) {
            paymentLoading = false;
            setState(() {});
            Fluttertoast.showToast(
                msg: params.toString(), timeInSecForIosWeb: 4);
          },
        ));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${value["message"]}")));
      }
    });
  }

  final formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCardCreated();
  var autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final card = PaymentCardCreated();

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardTypee cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  String getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
}
