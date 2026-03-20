// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry/controller/payment_controller/payfast_payment_controller.dart';
import 'package:laundry/controller/payment_controller/senang_pay_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/cart_detail_controller.dart';
import '../../controller/payment_controller/flutterwave_controller.dart';
import '../../controller/payment_controller/midtrans_controller.dart';
import '../../controller/payment_controller/paypal_controller.dart';
import '../../controller/payment_controller/paystack_controller.dart';
import '../../controller/payment_controller/strip_controller.dart';
import '../../controller/payment_detail_controller.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/button.dart';
import '../../controller_doctor/add_wallet_controller.dart';
import '../../controller_doctor/wallet_detail_controller.dart';
import '../../utils/customwidget.dart';
import '../PaymentGateway/common_webview.dart';
import '../PaymentGateway/paytm_payment.dart';
import '../bottombarpro_screen.dart';
import '../paypal/flutter_paypal.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  int? _groupValue;
  String? selectidPay = "0";
  String razorpaykey = "";
  String? paymenttital;
  int paymentSelect = 0;

  bool isWalletLoding = false;

  late Razorpay _razorpay;

  PaymentDetailController paymentDetailController = Get.put(PaymentDetailController());
  AddWalletController addWalletController = Get.put(AddWalletController());
  WalletDetailController walletDetailController = Get.put(WalletDetailController());
  PayPalController payPalController = Get.put(PayPalController());
  StripController stripController = Get.put(StripController());
  PayStackController payStackController = Get.put(PayStackController());
  FlutterWaveController flutterWaveController = Get.put(FlutterWaveController());
  CartDetailController cartDetailController = Get.put(CartDetailController());
  MidTransController midTransController = Get.put(MidTransController());
  SenangPayController senangPayController = Get.put(SenangPayController());
  PayfastPaymentController payfastPaymentController = Get.put(PayfastPaymentController());

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    walletDetailController.walletDetailApi();
    paymentDetailController.walletPaymentDetailApi();
    super.initState();
  }

  @override
  void dispose() {
    walletDetailController.isLoading = false;
    super.dispose();
  }

  addWalletApi() {
    addWalletController.addWalletApi(paymentType: paymentSelect.toString()).then((value) {
      Map<String, dynamic> decodedValue = json.decode(value);
      if (decodedValue["Result"] == true) {
        cartDetailController.changeIndex(4);
        setState(() {});
        Get.offAll(const BottomBarScreen());
        Get.to(const WalletHistoryScreen());
        walletDetailController.walletDetailApi();
        isWalletLoding = false;
        setState(() {});
      } else {
        isWalletLoding = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: gradient.defoultColor,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Wallet".tr,
          style: const TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<WalletDetailController>(
        builder: (walletDetailController) {
          return walletDetailController.isLoading
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 120,
                          color: gradient.defoultColor,
                        ),
                        Expanded(
                          child: Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: bgcolor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 55),
                                if(walletDetailController.walletDetailModel!.walletList.isNotEmpty)...[
                                  Text(
                                    "Transaction History".tr,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                                Expanded(
                                  child: walletDetailController.walletDetailModel!.walletList.isNotEmpty
                                      ? ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: walletDetailController.walletDetailModel!.walletList.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: WhiteColor,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding: EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: walletDetailController.walletDetailModel!.walletList[index].status == "1" || walletDetailController.walletDetailModel!.walletList[index].status == "3" || walletDetailController.walletDetailModel!.walletList[index].status == "5" || walletDetailController.walletDetailModel!.walletList[index].status == "7" || walletDetailController.walletDetailModel!.walletList[index].status == "8"
                                                        ? Colors.green.withOpacity(0.1) 
                                                        : Colors.red.withOpacity(0.1),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/wallet-filed.svg",
                                                      color: walletDetailController.walletDetailModel!.walletList[index].status == "1" || walletDetailController.walletDetailModel!.walletList[index].status == "3" || walletDetailController.walletDetailModel!.walletList[index].status == "5" || walletDetailController.walletDetailModel!.walletList[index].status == "7" || walletDetailController.walletDetailModel!.walletList[index].status == "8"
                                                        ? Colors.green
                                                        : Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          walletDetailController.walletDetailModel!.walletList[index].status == "1"
                                                            ? "Appointment cancellation refund for doctor.".tr
                                                            : walletDetailController.walletDetailModel!.walletList[index].status == "2"
                                                                ? "Doctor appointment booked.".tr
                                                                : walletDetailController.walletDetailModel!.walletList[index].status == "3"
                                                                    ? "Medicine order cancellation refund.".tr
                                                                    : walletDetailController.walletDetailModel!.walletList[index].status == "4"
                                                                        ? "Medicine order placed.".tr
                                                                        : walletDetailController.walletDetailModel!.walletList[index].status == "5"
                                                                            ? "Lab package report cancellation refund.".tr
                                                                            : walletDetailController.walletDetailModel!.walletList[index].status == "6"
                                                                                ? "Lab package report booked.".tr
                                                                                : walletDetailController.walletDetailModel!.walletList[index].status == "7"
                                                                                    ? "Amount has been added to the wallet.".tr
                                                                                    : walletDetailController.walletDetailModel!.walletList[index].status == "8"
                                                                                        ? "Referral has been added.".tr
                                                                                        : "",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: BlackColor,
                                                            fontFamily: FontFamily.gilroyBold,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(walletDetailController.walletDetailModel!.walletList[index].date)),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: greycolor,
                                                            fontFamily: FontFamily.gilroyMedium,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    walletDetailController.walletDetailModel!.walletList[index].status == "1" || walletDetailController.walletDetailModel!.walletList[index].status == "3" || walletDetailController.walletDetailModel!.walletList[index].status == "5" || walletDetailController.walletDetailModel!.walletList[index].status == "7" || walletDetailController.walletDetailModel!.walletList[index].status == "8"
                                                      ?  "+ ${getData.read("currency")}${walletDetailController.walletDetailModel!.walletList[index].amount}"
                                                      :  "- ${getData.read("currency")}${walletDetailController.walletDetailModel!.walletList[index].amount}",
                                                    style: TextStyle(
                                                      color: walletDetailController.walletDetailModel!.walletList[index].status == "1" || walletDetailController.walletDetailModel!.walletList[index].status == "3" || walletDetailController.walletDetailModel!.walletList[index].status == "5" || walletDetailController.walletDetailModel!.walletList[index].status == "7" || walletDetailController.walletDetailModel!.walletList[index].status == "8" ? Colors.green : Colors.red,
                                                      fontFamily: FontFamily.gilroyBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                        )
                                      : Center(
                                          child: Center(
                                            child: Text(
                                              "Go & Add your Amount".tr,
                                              style: TextStyle(
                                                color: greytext,
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                              ),
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      // height: 150,
                      decoration: BoxDecoration(
                        color: bgcolor,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Lottie.asset("assets/lotties/wallet.json",
                                  height: 55),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TOTAL WALLET BALANCE'.tr,
                                      style: TextStyle(
                                        color: greycolor,
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyBold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${getData.read("currency")} ${walletDetailController.walletDetailModel!.totBalance}',
                                      style: TextStyle(
                                        color: textcolor,
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          button(
                            text: "Top Up".tr,
                            color: gradient.defoultColor,
                            onPress: () {
                              addWalletController.amount.clear();
                              paymentSheet().then((value) {
                                walletDetailController.walletDetailApi();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
        },
      ),
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
            return Container(
              constraints: BoxConstraints(
                maxHeight: Get.height / 1.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: Get.height / 80,
                      width: Get.width / 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Add Wallet Amount".tr,
                      style: const TextStyle(
                        color: gradient.defoultColor,
                        fontSize: 17,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: addWalletController.amount,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: FontFamily.gilroyBold),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 15),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          prefixIcon: SizedBox(
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Image.asset(
                                'assets/wallet.png',
                                width: 20,
                              ),
                            ),
                          ),
                          hintText: "Enter Amount".tr,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: FontFamily.gilroyBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Select Payment Type".tr,
                      style: TextStyle(
                        color: greycolor,
                        fontSize: 15,
                        fontFamily: FontFamily.gilroyBold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //! ---------List view paymente----------
                  Flexible(
                    child: GetBuilder<PaymentDetailController>(
                        builder: (paymentDetailController) {
                      return paymentDetailController.isLoading
                          ? ListView.separated(
                              itemCount: paymentDetailController.walletPaymentDetailModel!.paymentList.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      paymenttital = paymentDetailController.walletPaymentDetailModel!.paymentList[index].name;
                                      paymentSelect = paymentDetailController.walletPaymentDetailModel!.paymentList[index].id;
                                      razorpaykey = paymentDetailController.walletPaymentDetailModel!.paymentList[index].attribute;
                                      _groupValue = index;
                                      isWalletLoding = false;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: paymentSelect == paymentDetailController.walletPaymentDetailModel!.paymentList[index].id
                                            ? gradient.defoultColor
                                            : Colors.grey.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(65),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: "assets/ezgif.com-crop.gif",
                                              placeholderCacheHeight: 60,
                                              placeholderCacheWidth: 60,
                                              image: "${Config.imageBaseurlDoctor}${paymentDetailController.walletPaymentDetailModel!.paymentList[index].image}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                paymentDetailController
                                                    .walletPaymentDetailModel!
                                                    .paymentList[index]
                                                    .name,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              SizedBox(
                                                width: 190,
                                                child: Text(
                                                  paymentDetailController
                                                      .walletPaymentDetailModel!
                                                      .paymentList[index]
                                                      .subTitle,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Radio(
                                          activeColor: gradient.defoultColor,
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
                                color: gradient.defoultColor,
                              ),
                            );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: isWalletLoding
                    ? loaderButton()
                    : button(
                      text: "Continue".tr,
                      color: gradient.defoultColor,
                      onPress: () async {
                        // //!---- Payment ------
                        if (addWalletController.amount.text.isNotEmpty) {
                          if (paymentSelect != 0) {
                             if (isWalletLoding == false) {
                              isWalletLoding = true;
                              setState((){});
                              if (paymenttital == "Razorpay") {
                                openCheckout();
                              } else if (paymenttital == "Paypal") {
                                List<String> keyList = razorpaykey.split(",");
                                paypalPayment(
                                  function: (e) {
                                    addWalletApi();
                                  },
                                  context: context,
                                  amt: addWalletController.amount.text,
                                  clientId: keyList[0],
                                  secretKey: keyList[1],
                                );
                              } else if (paymenttital == "Stripe") {
                                stripController.stripApi(
                                  uid: "${getData.read("UserLogin")["id"]}",
                                  amount: addWalletController.amount.text,
                                ).then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["StripeURL"],
                                        navigationDelegate: (request) {
                                          final uri = Uri.parse(request.url);
                                          debugPrint("************ Navigating to URL: ${request.url}");
                                          debugPrint("************ Parsed URI: $uri");
                                          debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint("************ payment_intent: ${uri.queryParameters["payment_intent"]}");
                                          if (request.url.toString().contains("success") == true) {
                                            addWalletApi();
                                            return NavigationDecision.prevent;
                                          } else if (request.url.toString().contains("cancel") == false) {
                                            isWalletLoding = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                          return NavigationDecision.navigate;
                                        },
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                    isWalletLoding = false;
                                    setState(() {});
                                  }
                                });
                              } else if (paymenttital == "PayStack") {
                                payStackController.payStackApi(
                                  uid: "${getData.read("UserLogin")["id"]}",
                                  amount: addWalletController.amount.text,
                                ).then((value) {
                                  debugPrint("<><><><><><><><> value <><><><><><><><> $value");
                                  if (value["status"] == true) {
                                    Get.to(PaymentWebVIew(
                                      initialUrl: value["PaystackURL"],
                                      navigationDelegate: (request) {
                                        final uri = Uri.parse(request.url);
                                        debugPrint("************ Navigating to URL: ${request.url}");
                                        debugPrint("************ Parsed URI: $uri");
                                        debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                        debugPrint("************ trxref: ${uri.queryParameters["trxref"]}");
                                        debugPrint("************ reference: ${uri.queryParameters["reference"]}");
                                        if (uri.queryParameters["trxref"] != null && uri.queryParameters["reference"] != null) {
                                          addWalletApi();
                                          return NavigationDecision.prevent;
                                        } else {
                                          isWalletLoding = false;
                                          setState(() {});
                                          Get.back();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order not placed")));
                                          return NavigationDecision.navigate;
                                        }
                                      },
                                    ));
                                  } else {
                                    isWalletLoding = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "FlutterWave") {
                                flutterWaveController.flutterWaveApi(
                                  amount: addWalletController.amount.text,
                                  uid: "${getData.read("UserLogin")["id"]}",
                                ).then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["FlutterwaveURL"],
                                        navigationDelegate: (request) async {
                                          final uri = Uri.parse(request.url);
                                          debugPrint("************ Navigating to URL: ${request.url}");
                                          debugPrint("************ Parsed URI: $uri");
                                          debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint("************ status: ${uri.queryParameters["status"]}");
                                          if (uri.queryParameters["status"] != null) {
                                            if (uri.queryParameters["status"] == "successful") {
                                              addWalletApi();
                                              return NavigationDecision.prevent;
                                            } else {
                                              isWalletLoding = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage("${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            isWalletLoding = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    isWalletLoding = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "Paytm") {
                                Get.to(() => PayTmPayment(
                                  totalAmount: addWalletController.amount.text,
                                  uid: getData.read("UserLogin")["id"].toString(),
                                ))!.then((otid) {
                                  if (otid != null) {
                                    addWalletApi();
                                  } else {
                                    Get.back();
                                  }
                                });
                              } else if (paymenttital == "SenangPay") {
                                senangPayController.senangPayApi(
                                  amount: addWalletController.amount.text,
                                ).then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["SenangPayURL"],
                                        navigationDelegate: (request) {
                                        final uri = Uri.parse(request.url);
                                          debugPrint("************ Navigating to URL: ${request.url}");
                                          debugPrint("************ Parsed URI: $uri");
                                          debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint("************ status: ${uri.queryParameters["status"]}");
                                          if (uri.queryParameters["status"] != null) {
                                            if (uri.queryParameters["status"] == "successful") {
                                              return NavigationDecision.prevent;
                                            } else {
                                              isWalletLoding = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage("${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            isWalletLoding = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    isWalletLoding = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "MercadoPago") {
                              } else if (paymenttital == "Payfast") {
                                payfastPaymentController.payfastPaymentApi(
                                  amount: cartDetailController.total.toString(),
                                ).then((value) {
                                  if (value["status"] == true) {
                                    debugPrint("-------------- value[payFastLink] ----------- ${value["payFastLink"]}");
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["payFastLink"],
                                        navigationDelegate: (request) async {
                                          final uri = Uri.parse(request.url);
                                          debugPrint("************ Navigating to URL: ${request.url}");
                                          debugPrint("************ Parsed URI: $uri");
                                          debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint("************ return_url: ${uri.queryParameters["return_url"]}");
                                          if (uri.queryParametersAll.isNotEmpty) {
                                            Uri returnUrl = Uri.parse("${uri.queryParameters["return_url"]}");
                                            String transactionId = "${returnUrl.queryParameters['transactionId']}";
                                            debugPrint("-------------- transactionId ----------- $transactionId");
                                            addWalletApi();
                                            return NavigationDecision.prevent;
                                          } else {
                                            isWalletLoding = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    isWalletLoding = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                  }
                                });
                              } else if (paymenttital == "Midtrans") {
                                midTransController.midTransApi(
                                  amount: addWalletController.amount.text,
                                ).then((value) {
                                  if (value["status"] == true) {
                                    Get.to(
                                      PaymentWebVIew(
                                        initialUrl: value["MidtransURL"],
                                        navigationDelegate: (request) {
                                          final uri = Uri.parse(request.url);
                                          debugPrint("************ Navigating to URL: ${request.url}");
                                          debugPrint("************ Parsed URI: $uri");
                                          debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                          debugPrint("************ order_id: ${uri.queryParameters["order_id"]}");
                                          if (uri.queryParameters["status_code"] != null) {
                                            if (uri.queryParameters["status_code"] == "200") {
                                              addWalletApi();
                                              return NavigationDecision.prevent;
                                            } else {
                                              isWalletLoding = false;
                                              setState(() {});
                                              Get.back();
                                              showToastMessage("${uri.queryParameters["status"]}");
                                              return NavigationDecision.prevent;
                                            }
                                          } else {
                                            isWalletLoding = false;
                                            setState(() {});
                                            Get.back();
                                            return NavigationDecision.prevent;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    isWalletLoding = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                                  }
                                });
                              } 
                            }
                          } else {
                            showToastMessage("Payment method is required. Please select one.");
                          }
                        } else {
                          showToastMessage("Wallet amount is required. Please enter it.");
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //!--------- Razorpay ----------//

  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["phone"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (int.parse(addWalletController.amount.text) * 100).toString(),
      'name': username,
      'description': "",
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    addWalletApi();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isWalletLoding = false;
    setState(() {});
    showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isWalletLoding = false;
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
    payPalController.paypalApi(
      uid: getData.read("UserLogin")["id"].toString(),
      amount: addWalletController.amount.text,
    ).then((value) {
        if (value["status"] == true) {
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
            note: "Contact us for any questions on your service.",
            onSuccess: (Map params) {
              function(params);
              Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : $params', timeInSecForIosWeb: 4);
            },
            onError: (error) {
              isWalletLoding = false;
              setState(() {});
              Fluttertoast.showToast(msg: error.toString(), timeInSecForIosWeb: 4);
            },
            onCancel: (params) {
              isWalletLoding = false;
              setState(() {});
              Fluttertoast.showToast(msg: params.toString(), timeInSecForIosWeb: 4);
            },
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
        }
    });
  }
}