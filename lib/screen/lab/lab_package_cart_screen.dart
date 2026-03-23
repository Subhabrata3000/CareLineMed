// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/address_list_controller.dart';
import 'package:carelinemed/controller/lab_package_cart_controller.dart';
import 'package:carelinemed/controller/packages_controller.dart';
import 'package:carelinemed/controller/payment_controller/flutterwave_controller.dart';
import 'package:carelinemed/controller/payment_controller/midtrans_controller.dart';
import 'package:carelinemed/controller/payment_controller/payfast_payment_controller.dart';
import 'package:carelinemed/controller/payment_controller/paypal_controller.dart';
import 'package:carelinemed/controller/payment_controller/paystack_controller.dart';
import 'package:carelinemed/controller/payment_controller/senang_pay_controller.dart';
import 'package:carelinemed/controller/payment_controller/strip_controller.dart';
import 'package:carelinemed/controller/payment_detail_controller.dart';
import 'package:carelinemed/controller_doctor/cart_detail_controller.dart';
import 'package:carelinemed/controller_doctor/home_controller.dart';
import 'package:carelinemed/helpar/routes_helper.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/PaymentGateway/PaymentCard.dart';
import 'package:carelinemed/screen/PaymentGateway/common_webview.dart';
import 'package:carelinemed/screen/authentication/onbording_screen.dart';
import 'package:carelinemed/screen/bottombarpro_screen.dart';
import 'package:carelinemed/screen/lab/lab_booking_list_screen.dart';
import 'package:carelinemed/screen/paypal/flutter_paypal.dart';
import 'package:carelinemed/screen/video_call/vc_provider.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/widget/add_pet_bottom.dart';
import 'package:carelinemed/widget/button.dart';
import 'package:carelinemed/widget/coupon_apply_sucsessfull.dart';
import 'package:carelinemed/widget/custom_title.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LabPackageCartScreen extends StatefulWidget {
  final String labId;
  final String categoryId;
  const LabPackageCartScreen({
    super.key,
    required this.labId,
    required this.categoryId,
  });

  @override
  State<LabPackageCartScreen> createState() => _LabPackageCartScreenState();
}

class _LabPackageCartScreenState extends State<LabPackageCartScreen> {
  bool switchValue = false;
  bool frontGateSwitch = false;
  bool buttonEnabled = true;
  List value_1 = [];
  int currentIndex = 0;
  int paymentSelect = 0;
  double commission = 0;

  bool paymentLoading = false;

  CartDetailController cartDetailController = Get.put(CartDetailController());
  LabPackageCartController labPackageCartController = Get.put(LabPackageCartController());
  AddPetController addPetController = Get.put(AddPetController());
  HomeController homeController = Get.put(HomeController());
  AddressListController addressListController = Get.put(AddressListController());
  PackagesController packagesController = Get.put(PackagesController());
  PayPalController payPalController = Get.put(PayPalController());
  StripController stripController = Get.put(StripController());
  PayStackController payStackController = Get.put(PayStackController());
  FlutterWaveController flutterWaveController = Get.put(FlutterWaveController());
  MidTransController midTransController = Get.put(MidTransController());
  PaymentDetailController paymentDetailController = Get.put(PaymentDetailController());
  SenangPayController senangPayController = Get.put(SenangPayController());
  PayfastPaymentController payfastPaymentController = Get.put(PayfastPaymentController());

  var currency = "";

  late Razorpay _razorpay;

  int? _groupValue;
  String? selectidPay = "0";
  String razorpaykey = "";
  String? paymenttital;

  walletCalculation(value) {
    if (value == true) {
      if (double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}") < double.parse("${labPackageCartController.total}")) {
        labPackageCartController.tempWallet = double.parse("${labPackageCartController.total}") - double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}");
        labPackageCartController.useWallet = double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}");
        labPackageCartController.total = (double.parse("${labPackageCartController.total}") - double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}"));
        labPackageCartController.tempWallet = 0;
        setState(() {});
      } else {
        labPackageCartController.tempWallet = double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}") - double.parse("${labPackageCartController.total}");
        labPackageCartController.useWallet = double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}") - labPackageCartController.tempWallet;
        labPackageCartController.total = 0;
      }
    } else {
      setState(() {});
      labPackageCartController.status = false;
      labPackageCartController.tempWallet = 0;
      labPackageCartController.tempWallet = double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}");
      labPackageCartController.total = labPackageCartController.total + labPackageCartController.useWallet;
      labPackageCartController.useWallet = 0;
    }
  }

  @override
  void initState() {
    debugPrint("--------------- labId ------------- ${widget.labId}");
    debugPrint("------------- categoryId ---------- ${widget.categoryId}");
    labPackageCartController.isLoading = true;
    currency = getData.read("currency");
    setState(() {});
    fun();
    paymentDetailController.paymentDetailApi();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  fun() {
    labPackageCartController.total = 0;
    labPackageCartController.subTotal = 0;
    labPackageCartController.selectedPackagePatient.clear();
    labPackageCartController.packageTotal.clear();
    labPackageCartController.apitotal = 0;
    labPackageCartController.status = false;
    labPackageCartController.labPackageCartApi(
      uid: "${getData.read("UserLogin")["id"]}",
      labId: widget.labId,
      categoryId: widget.categoryId,
    ).then((value) {
      walletCalculation(false);
      labPackageCartController.tempWallet = double.parse("${labPackageCartController.labPackageCartApiModel!.walletAmount}");
      setState(() {});

      for (var i = 0; i < labPackageCartController.labPackageCartApiModel!.packageDetail!.length; i++) {
        labPackageCartController.selectedPackagePatient.putIfAbsent(i, () => []);
        setState(() {
          if (labPackageCartController.labPackageCartApiModel!.familyMember!.isNotEmpty) {
            labPackageCartController.selectedPackagePatient[i]!.add(labPackageCartController.labPackageCartApiModel!.familyMember![0].id!);
            var pachageListTotal = double.parse("${labPackageCartController.labPackageCartApiModel!.packageDetail![i].packagePrice}") * labPackageCartController.selectedPackagePatient[i]!.length;
            labPackageCartController.packageTotal.add(pachageListTotal);
          } else {
            labPackageCartController.packageTotal.add(0);
          }

        });
      }
      setState(() {});
      labPackageCartController.subTotal = labPackageCartController.packageTotal.reduce((a, b) => a + b);
      debugPrint("-------------------- subTotal ------------------------ ${labPackageCartController.subTotal}");
      labPackageCartController.commission = labPackageCartController.labPackageCartApiModel!.commissionData!.commisiionType == "fix"
          ? double.parse("${labPackageCartController.labPackageCartApiModel!.commissionData!.commissionRate}")
          : labPackageCartController.subTotal * double.parse("${labPackageCartController.labPackageCartApiModel!.commissionData!.commissionRate}") / 100;
      labPackageCartController.total = labPackageCartController.subTotal + labPackageCartController.commission;
      labPackageCartController.apitotal = labPackageCartController.total;
      setState(() {});

    });
  }

  @override
  void dispose() {
    labPackageCartController.selectedPackagePatient.clear();
    labPackageCartController.packageTotal.clear();
    labPackageCartController.sampleCollectTime = null;
    labPackageCartController.sampleCollectDate = "";
    labPackageCartController.status = false;
    labPackageCartController.homeExtraPrice = false;
    labPackageCartController.total = 0;
    labPackageCartController.status = false;
    labPackageCartController.caregiverController.clear();
    labPackageCartController.total = labPackageCartController.total + labPackageCartController.useWallet;
    labPackageCartController.useWallet = 0;
    labPackageCartController.total = labPackageCartController.total + labPackageCartController.couponAmt;
    labPackageCartController.couponAmt = 0;
    labPackageCartController.apitotal = labPackageCartController.total;
    labPackageCartController.couponCode = "";
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    bookLabAppointment(transactionID: "${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: ${"ERROR: ${response.code} - ${response.message!}"}');
    paymentLoading = false;
    setState(() {});
    showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    paymentLoading = false;
    setState(() {});
    showToastMessage(response.walletName!);
  }

  bookLabAppointment({String? transactionID}) {
    paymentLoading = true;
    List packageList = [];
    List familyMemIdList = [];
    for (var i = 0; i < labPackageCartController.selectedPackagePatient.length; i++) {
      packageList.add({
        "pid": labPackageCartController.labPackageCartApiModel!.packageDetail![i].id,
        "f": labPackageCartController.selectedPackagePatient[i]
      });
      for (var j = 0; j < labPackageCartController.selectedPackagePatient[i]!.length; j++) {
        if (familyMemIdList.contains(labPackageCartController.selectedPackagePatient[i]![j]) == false) {
          familyMemIdList.add(labPackageCartController.selectedPackagePatient[i]![j]);
        }
      }
    }
    setState(() {});

    labPackageCartController.bookLabAppointmentApi(
      uid: "${getData.read("UserLogin")["id"]}",
      labId: "${labPackageCartController.labPackageCartApiModel!.lab!.id}",
      categoryId: "${labPackageCartController.labPackageCartApiModel!.category!.id}",
      date: labPackageCartController.sampleCollectDate,
      time: labPackageCartController.sampleCollectTime!.format(context),
      message: labPackageCartController.caregiverController.text,
      address: labPackageCartController.addressId,
      packageList: packageList,
      familyMemId: familyMemIdList,
      homeColStatus: "${labPackageCartController.homeExtraPrice ? 1 : 0}",
      totPrice: double.parse(labPackageCartController.apitotal.toStringAsFixed(2)),
      totPackagePrice: double.parse(labPackageCartController.subTotal.toStringAsFixed(2)),
      homeExtraPrice: labPackageCartController.homeCollectExtraPrice,
      couponId: labPackageCartController.couponId,
      couponAmount: double.parse(labPackageCartController.couponAmt.toStringAsFixed(2)),
      siteCommission: double.parse(labPackageCartController.commission.toStringAsFixed(2)),
      paymentId: "$paymentSelect",
      walletAmount: double.parse(labPackageCartController.useWallet.toStringAsFixed(2)),
      transactionId: transactionID ?? ""
    ).then((value) {
      debugPrint("-------------------------------------------- $value");
      if (value["Result"] == true) {
        cartDetailController.changeIndex(4);
        setState(() {});
        Get.offAll(BottomBarScreen());
        Get.to(LabBookingListScreen());
        cartDetailController.addresTitle = "";
        paymentLoading = false;
        setState(() {});
      } else if (value["Result"] == false) {
        paymentLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
      } else {
        paymentLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["error"]}")));
      }
    });
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
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Book Lab Tests".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
      ),
      bottomNavigationBar: labPackageCartController.subTotal <= 0
          ? SizedBox(height: 0, width: 0)
          : Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$currency${labPackageCartController.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 2.3,
                    child: paymentLoading
                      ?  loaderButton(borderRadius: BorderRadius.circular(15))
                      :  button(
                          height: 45,
                          onPress: () {
                            labPackageCartController.emptyList.clear();
                            for (int i = 0; i < labPackageCartController.packageTotal.length; i++) {
                              if (labPackageCartController.packageTotal[i] != 0) {
                                labPackageCartController.emptyList.add(labPackageCartController.packageTotal[i]);
                              }
                            }
                            if (labPackageCartController.packageTotal.length == labPackageCartController.emptyList.length) {
                              if (labPackageCartController.sampleCollectDate != "" && labPackageCartController.sampleCollectTime != null) {
                                if (labPackageCartController.homeExtraPrice == true) {
                                  if (labPackageCartController.addressId != "") {
                                    labPackageCartController.total == 0
                                        ? bookLabAppointment()
                                        : paymentSheet();
                                  } else {
                                    Fluttertoast.showToast(msg: "Address Required!".tr);
                                  }
                                } else {
                                  labPackageCartController.total == 0
                                      ? bookLabAppointment()
                                      : paymentSheet();
                                }
                              } else {
                                Fluttertoast.showToast(msg: "SampleCollect Date & Time Required!".tr);
                              }
                            } else {
                              Fluttertoast.showToast(msg: "Please Select Patient, All Packges".tr);
                            }
                          },
                          text: "Proceed".tr,
                          borderRadius: BorderRadius.circular(15),
                          color: gradient.defoultColor,
                        ),
                  ),
                ],
              ),
            ),
      body: GetBuilder<LabPackageCartController>(
        builder: (labPackageCartController) {
          return labPackageCartController.isLoading
              ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
              : Stack(
                children: [
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lab details".tr,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: FadeInImage.assetNetwork(
                                        height: Get.height / 10,
                                        width: Get.height / 10,
                                        fit: BoxFit.cover,
                                        placeholder: "assets/ezgif.com-crop.gif",
                                        placeholderFit: BoxFit.cover,
                                        placeholderCacheWidth: 60,
                                        placeholderCacheHeight: 60,
                                        image: "${Config.imageBaseurlDoctor}${labPackageCartController.labPackageCartApiModel!.lab!.logo}",
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${labPackageCartController.labPackageCartApiModel!.lab!.name}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "${labPackageCartController.labPackageCartApiModel!.lab!.address}",
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontSize: 12,
                                              fontFamily: FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/star.svg",
                                                color: yelloColor,
                                              ),
                                              SizedBox(width: 5),
                                              RichText(
                                                text: TextSpan(
                                                  text: "${labPackageCartController.labPackageCartApiModel!.lab!.totReview}",
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily: FontFamily.gilroyBlack,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " (${labPackageCartController.labPackageCartApiModel!.lab!.avgStar}+ ${"Ratings".tr})",
                                                      style: TextStyle(
                                                        color: greycolor,
                                                        fontFamily: FontFamily.gilroyRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                          SizedBox(height: 15),
                          Text(
                            "Test Details & Package Details".tr,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            itemCount: labPackageCartController.labPackageCartApiModel!.packageDetail!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              labPackageCartController.selectedPackagePatient.putIfAbsent(index, () => []);
                              return Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: WhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: greyColor,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: FadeInImage.assetNetwork(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              placeholder: "assets/ezgif.com-crop.gif",
                                              placeholderFit: BoxFit.cover,
                                              placeholderCacheWidth: 60,
                                              placeholderCacheHeight: 60,
                                              image: "${Config.imageBaseurlDoctor}${labPackageCartController.labPackageCartApiModel!.packageDetail![index].logo}",
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${labPackageCartController.labPackageCartApiModel!.packageDetail![index].title}",
                                                      style: TextStyle(
                                                        color: BlackColor,
                                                        fontFamily: FontFamily.gilroyBold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            titlePadding: EdgeInsets.only(top: 15,left: 15,right: 15),
                                                            contentPadding: EdgeInsets.only(bottom: 0,left: 15,right: 15),
                                                            actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                            title: Text(
                                                              "Remove Cart?".tr,
                                                              style: TextStyle(
                                                                fontFamily: FontFamily.gilroyBold,
                                                                color: BlackColor,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            content: Text(
                                                              "${"Are You Sure You Want To Delete All Item From".tr} ${labPackageCartController.labPackageCartApiModel!.packageDetail![index].title}",
                                                              style: TextStyle(
                                                                fontFamily: FontFamily.gilroyMedium,
                                                                color: greycolor,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            actions: [
                                                              GestureDetector(
                                                                onTap: () => Get.back(),
                                                                child: Container(
                                                                  width: Get.width / 4.5,
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(color: gradient.defoultColor),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                        color: gradient.defoultColor,
                                                                        fontFamily: FontFamily.gilroyBlack,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  labPackageCartController.isLoading = true;
                                                                  setState(() {});
                                                                  walletCalculation(false);
                                                                  setState(() {});
                                                                  labPackageCartController.total = labPackageCartController.total + labPackageCartController.couponAmt;
                                                                  labPackageCartController.apitotal = labPackageCartController.total;
                                                                  labPackageCartController.couponAmt = 0;
                                                                  labPackageCartController.couponCode = "";
                                                                  setState(() {});
                                                                  Get.back();
                                                                  packagesController.packageAddinCartApi(
                                                                    labId: "${labPackageCartController.labPackageCartApiModel!.lab!.id}",
                                                                    pacakgeId: "${labPackageCartController.labPackageCartApiModel!.packageDetail![index].id}",
                                                                  ).then((value) {
                                                                    if (value["Result"] == true) {
                                                                      packagesController.packagesApi(
                                                                        categoryId: widget.categoryId,
                                                                        labId: widget.labId,
                                                                      ).then((value1) {
                                                                        if (value1["Result"] == true) {
                                                                          if (packagesController.packagesApiModel!.cartCheck! > 0) {
                                                                            fun();
                                                                          } else {
                                                                            Get.close(1);
                                                                          }
                                                                        }
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                child: Container(
                                                                  width: Get.width / 4.5,
                                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    color: gradient.defoultColor,
                                                                    border: Border.all(color: gradient.defoultColor),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Remove".tr,
                                                                      style: TextStyle(
                                                                        color: WhiteColor,
                                                                        fontFamily: FontFamily.gilroyBlack,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: bgcolor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: SvgPicture.asset(
                                                        "assets/trash.svg",
                                                        color: greyColor,
                                                        height: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${labPackageCartController.labPackageCartApiModel!.packageDetail![index].subtitle}",
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${"Includes".tr} ${labPackageCartController.labPackageCartApiModel!.packageDetail![index].packageName} ${"tests".tr}",
                                                style: TextStyle(
                                                  color: greycolor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: "${"Package Price".tr} : ",
                                                        style: TextStyle(
                                                          color: BlackColor,
                                                          fontFamily: FontFamily.gilroyMedium,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: "$currency ${labPackageCartController.labPackageCartApiModel!.packageDetail![index].packagePrice} X ",
                                                            style: TextStyle(
                                                              color: greycolor,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${labPackageCartController.selectedPackagePatient[index]!.length}",
                                                            style: TextStyle(
                                                              color: greycolor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "$currency ${labPackageCartController.packageTotal[index]}",
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily: FontFamily.gilroyBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            padding: EdgeInsets.only(left: Get.width / 12),
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    walletCalculation(false);
                                                    addPetController.addPetBottom(context).then((value) {
                                                      fun();
                                                      homeController.homeApiDoctor(lat: "$lat", lon: "$long");
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 73,
                                                    width: 73,
                                                    decoration: BoxDecoration(
                                                      color: primeryColor.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: gradient.defoultColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 13),
                                                Row(
                                                  children: [
                                                    for (int i = 0; i < labPackageCartController.labPackageCartApiModel!.familyMember!.length; i++) ...[
                                                      Column(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  walletCalculation(false);
                                                                  setState(() {});
                                                                  labPackageCartController.useWallet = 0;
                                                                  labPackageCartController.couponAmt = 0;
                                                                  labPackageCartController.apitotal = labPackageCartController.total;
                                                                  labPackageCartController.couponCode = "";
                                                                  setState(() {});
                                                                  setState(() {
                                                                    if (labPackageCartController.selectedPackagePatient[index]!.contains(labPackageCartController.labPackageCartApiModel!.familyMember![i].id)) {
                                                                      labPackageCartController.selectedPackagePatient[index]!.remove(labPackageCartController.labPackageCartApiModel!.familyMember![i].id);
                                                                      debugPrint("---------- selectedPackagePatient ----------- ${labPackageCartController.selectedPackagePatient}");
                                                                    } else {
                                                                      labPackageCartController.selectedPackagePatient[index]!.add(labPackageCartController.labPackageCartApiModel!.familyMember![i].id!.toInt());
                                                                      debugPrint("---------- selectedPackagePatient ----------- ${labPackageCartController.selectedPackagePatient}");
                                                                    }
                                                                  });
                                                                  var pachageListTotal = double.parse("${labPackageCartController.labPackageCartApiModel!.packageDetail![index].packagePrice}");
                                                                  labPackageCartController.packageTotal[index] = pachageListTotal;
                                                                  debugPrint("--------------- packageTotal ----------- ${labPackageCartController.packageTotal}");
                                                                  setState(() {});


                                                                  setState(() {});
                                                                },
                                                                child: Container(
                                                                  height: 73,
                                                                  width: 73,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: labPackageCartController.selectedPackagePatient[index]!.contains(labPackageCartController.labPackageCartApiModel!.familyMember![i].id)
                                                                          ? gradient.defoultColor
                                                                          : Colors.transparent,
                                                                      width: 2.5,
                                                                    ),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(65),
                                                                    child: FadeInImage.assetNetwork(
                                                                      placeholder: "assets/ezgif.com-crop.gif",
                                                                      placeholderCacheWidth: 73,
                                                                      placeholderCacheHeight: 73,
                                                                      image: "${Config.imageBaseurlDoctor}${labPackageCartController.labPackageCartApiModel!.familyMember![i].profileImage}",
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              labPackageCartController.selectedPackagePatient[index]!.contains(labPackageCartController.labPackageCartApiModel!.familyMember![i].id)
                                                                  ? Positioned(
                                                                      bottom: 0,
                                                                      right: 0,
                                                                      child: Container(
                                                                        height: 26,
                                                                        width: 26,
                                                                        decoration: BoxDecoration(
                                                                          color: gradient.defoultColor,
                                                                          border: Border.all(
                                                                            color: Colors.white,
                                                                            width: 1.6,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(70),
                                                                        ),
                                                                        child: Icon(
                                                                          Icons.check,
                                                                          color: Colors.white,
                                                                          size: 15,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            "${labPackageCartController.labPackageCartApiModel!.familyMember![i].name}",
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyBold,
                                                              fontSize: 16,
                                                              color: labPackageCartController.selectedPackagePatient[index]!.contains(labPackageCartController.labPackageCartApiModel!.familyMember![i].id)
                                                                  ? gradient.defoultColor
                                                                  : textcolor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (i != labPackageCartController.labPackageCartApiModel!.familyMember!.length - 1) ...[SizedBox(width: 13)],
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Sample collection slot".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 16,
                                    color: BlackColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => labPackageCartController.selectDate(context),
                                        child: Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: WhiteColor,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: greycolor),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/calendar1.png",
                                                height: 20,
                                                color: greycolor,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  labPackageCartController.sampleCollectDate == ""
                                                      ? "Select date".tr
                                                      : labPackageCartController.sampleCollectDate,
                                                  style: TextStyle(
                                                    color: labPackageCartController.sampleCollectDate == ""
                                                        ? greycolor
                                                        : gradient.defoultColor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => labPackageCartController.pickTime(context),
                                        child: Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: WhiteColor,
                                            border: Border.all(color: greycolor),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/clock-circle.svg",
                                                height: 20,
                                                color: greycolor,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  labPackageCartController.sampleCollectTime == null
                                                      ? "Select Time".tr
                                                      : labPackageCartController.sampleCollectTime!.format(context),
                                                  style: TextStyle(
                                                    color: labPackageCartController.sampleCollectTime == null
                                                        ? greycolor
                                                        : gradient.defoultColor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                  
                          //! ---------- Message -----------!//
                  
                          Container(
                            width: Get.size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: WhiteColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Symptoms/Private Note".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 16,
                                    color: BlackColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: labPackageCartController.caregiverController,
                                  maxLength: 500,
                                  maxLines: 5,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 15,
                                    color: textcolor,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Message".tr,
                                    hintStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 15,
                                      color: greyColor,
                                    ),
                                    contentPadding: EdgeInsets.only(top: 20, left: 12, right: 12),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: gradient.defoultColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  
                          if(labPackageCartController.labPackageCartApiModel!.walletAmount != 0)...[
                            SizedBox(height: 10),
                            Container(
                              width: Get.size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Pay from Wallet".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 16,
                                          color: BlackColor,
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.7,
                                        child: CupertinoSwitch(
                                          inactiveTrackColor: greyColor,
                                          activeTrackColor: gradient.defoultColor,
                                          value: labPackageCartController.status,
                                          onChanged: (value) {
                                            setState(() {
                                              labPackageCartController.status = value;
                                              walletCalculation(value);
                                              debugPrint("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz ${labPackageCartController.tempWallet}");
                                              debugPrint("-------- cartDetailController.subTotal -------- ${labPackageCartController.subTotal}");
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
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                          "${getData.read("currency")}${labPackageCartController.tempWallet.toStringAsFixed(2)}",
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
                  
                          //!---------- Coupon Widget -----------!//
                          Container(
                            width: Get.size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (labPackageCartController.couponCode == "") {
                                  labPackageCartController.status = false;
                                  walletCalculation(false);
                                  setState(() {});
                                  Get.toNamed(
                                    Routes.couponScreen,
                                    arguments: {
                                      "price": labPackageCartController.total,
                                      "labPackCart": true,
                                    },
                                  )!.then((value) {
                                    setState(() {
                                      labPackageCartController.couponCode = value;
                                    });
                                    couponSucsessFullyApplyed(couponAmt: "${labPackageCartController.couponAmt}");
                                  });
                                } else {
                                  labPackageCartController.status = false;
                                  walletCalculation(false);
                                  setState(() {});
                                  labPackageCartController.useWallet = 0;
                                  labPackageCartController.couponAmt = 0;
                                  labPackageCartController.couponCode = "";
                                  setState(() {});
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/badge-discount.png",
                                            height: 40,
                                            width: 40,
                                            color: gradient.defoultColor,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Apply Coupon".tr,
                                                  style: TextStyle(
                                                    color: gradient.defoultColor,
                                                    fontFamily: FontFamily.gilroyBold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                labPackageCartController.couponCode != ""
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            "${"Use code".tr} : ",
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyMedium,
                                                            ),
                                                          ),
                                                          Text(
                                                            labPackageCartController.couponCode,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyBold,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                          labPackageCartController.couponCode != ""
                                              ? InkWell(
                                                  onTap: () {
                                                    labPackageCartController.status = false;
                                                    walletCalculation(false);
                                                    setState(() {});
                                                    labPackageCartController.useWallet = 0;
                                                    labPackageCartController.couponAmt = 0;
                                                    labPackageCartController.couponCode = "";
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    "Remove".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyBold,
                                                      color: RedColor,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (labPackageCartController.couponCode == "") {
                                                      labPackageCartController.status = false;
                                                      walletCalculation(false);
                                                      setState(() {});
                                                      Get.toNamed(
                                                        Routes.couponScreen,
                                                        arguments: {
                                                          "price": labPackageCartController.total,
                                                          "labPackCart": true,
                                                        },
                                                      )!.then((value) {
                                                        setState(() {
                                                          labPackageCartController.couponCode = value;
                                                        });
                                                        couponSucsessFullyApplyed(couponAmt: "${labPackageCartController.couponAmt}");
                                                      });
                                                    } else {
                                                      labPackageCartController.status = false;
                                                      walletCalculation(false);
                                                      setState(() {});
                                                      labPackageCartController.useWallet = 0;
                                                      labPackageCartController.couponAmt = 0;
                                                      labPackageCartController.couponCode = "";
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Text(
                                                    "Apply".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyBold,
                                                      color: gradient.defoultColor,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Divider(color: greycolor),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      if (labPackageCartController.couponCode == "") {
                                        labPackageCartController.status = false;
                                        walletCalculation(false);
                                        setState(() {});
                                        Get.toNamed(
                                          Routes.couponScreen,
                                          arguments: {
                                            "price": labPackageCartController.total,
                                            "labPackCart": true,
                                          },
                                        )!.then((value) {
                                          setState(() {
                                            labPackageCartController.couponCode = value;
                                          });
                                          couponSucsessFullyApplyed(couponAmt: "${labPackageCartController.couponAmt}");
                                        });
                                      } else {
                                        labPackageCartController.status = false;
                                        walletCalculation(false);
                                        setState(() {});
                                        labPackageCartController.useWallet = 0;
                                        labPackageCartController.couponAmt = 0;
                                        labPackageCartController.apitotal = labPackageCartController.total;
                                        labPackageCartController.couponCode = "";
                                        setState(() {});
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "View all coupons".tr,
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 15,
                                              fontFamily: FontFamily.gilroyMedium,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: greyColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  
                          SizedBox(height: 10),
                  
                          if (labPackageCartController.labPackageCartApiModel!.homeExtraPrice != 0) ...[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: WhiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home Service(Collect my test sample)".tr,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${"Additional Cost Required to Pay".tr} ${getData.read("currency")}${labPackageCartController.labPackageCartApiModel!.homeExtraPrice}",
                                          style: TextStyle(
                                            color: gradient.defoultColor,
                                            fontFamily: FontFamily.gilroyRegular,
                                          ),
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.7,
                                        child: CupertinoSwitch(
                                          inactiveTrackColor: greyColor,
                                          activeTrackColor: gradient.defoultColor,
                                          value: labPackageCartController.homeExtraPrice,
                                          onChanged: (value) {
                                            setState(() {
                                              labPackageCartController.homeExtraPrice = value;
                                            });
                                            if (labPackageCartController.homeExtraPrice) {
                                              labPackageCartController.homeCollectExtraPrice = double.parse(labPackageCartController.labPackageCartApiModel!.homeExtraPrice!.toStringAsFixed(2));
                                              labPackageCartController.apitotal = labPackageCartController.total;
                                            } else {
                                              labPackageCartController.apitotal = labPackageCartController.total;
                                              labPackageCartController.homeCollectExtraPrice = 0;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                          Container(
                            width: Get.size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: WhiteColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labPackageCartController.homeExtraPrice
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: GetBuilder<AddressListController>(
                                              builder: (addressListModel) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    labPackageCartController.addresTitle == ""
                                                        ? Text(
                                                            "We Come to You".tr,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyBold,
                                                              fontSize: 17,
                                                            ),
                                                          )
                                                        : Text(
                                                            labPackageCartController.addresTitle,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyBold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      "Choose your address for hassle-free sample collection at home".tr,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.gilroyMedium,
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
                                              addressListController.addressListApi(uid: "${getData.read("UserLogin")["id"]}");
                                              addressShit().then((value) => setState(() {}));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.grey.shade300),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Your Lab Appointment Location".tr,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.gilroyBold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      "Kindly visit the address below for your scheduled lab services.".tr,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.gilroyMedium,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Image.asset(
                                                "assets/selfPickupPin.png",
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: DottedLine(dashColor: greyColor),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/location-pin.svg",
                                                height: 25,
                                                width: 25,
                                                color: gradient.defoultColor,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "${labPackageCartController.labPackageCartApiModel!.lab!.address}",
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.gilroyMedium,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                  
                          SizedBox(height: 10),
                  
                          //! ---------- Total Bill ----------!//
                  
                          Container(
                            width: Get.size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Review your requirements for this request".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 10),
                                billSummaryTextCart(
                                  title: "Service total".tr,
                                  subtitle: "${labPackageCartController.subTotal.toStringAsFixed(2)}${getData.read("currency")}",
                                ),
                                if(labPackageCartController.homeCollectExtraPrice != 0)...[
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: DottedLine(dashColor: greyColor),
                                  ),
                                  billSummaryTextCart(
                                    title: "Home Collection Fee".tr,
                                    subtitle: "+${labPackageCartController.homeCollectExtraPrice}${getData.read("currency")}",
                                  ),
                                ],
                                if(labPackageCartController.status)...[
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: DottedLine(dashColor: greyColor),
                                  ),
                                  billSummaryTextCart(
                                    title: "Wallet".tr,
                                    subtitle: "-${labPackageCartController.useWallet.toStringAsFixed(2)}${getData.read("currency")}",
                                  ),
                                ],
                                if(labPackageCartController.couponCode != "")...[
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: DottedLine(dashColor: greyColor),
                                  ),
                                  billSummaryTextCart(
                                    title: "Coupon".tr,
                                    subtitle: "-${labPackageCartController.couponAmt}${getData.read("currency")}",
                                  ),
                                ],
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: DottedLine(dashColor: greyColor),
                                ),
                                labPackageCartController.labPackageCartApiModel!.commissionData!.commisiionType == "fix"
                                  ? billSummaryTextCart(
                                      title: "${"Service Fee & Tax".tr} (${labPackageCartController.labPackageCartApiModel!.commissionData!.commisiionType})",
                                      subtitle: "+${double.parse("${labPackageCartController.labPackageCartApiModel!.commissionData!.commissionRate}").toStringAsFixed(1)}${getData.read("currency")}",
                                    )
                                  : billSummaryTextCart(
                                      title: "${"Service Fee & Tax".tr} (${labPackageCartController.labPackageCartApiModel!.commissionData!.commissionRate}${labPackageCartController.labPackageCartApiModel!.commissionData!.commisiionType})",
                                      subtitle: "${labPackageCartController.commission.toStringAsFixed(2)}${getData.read("currency")}",
                                    ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: DottedLine(dashColor: greyColor),
                                ),
                                
                                billSummaryTextCart(
                                  title: "Total Payable Amount".tr,
                                  subtitle: "${labPackageCartController.total.toStringAsFixed(2)}${getData.read("currency")}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if(paymentLoading)...[
                    Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                        color: bgcolor.withOpacity(0.5),
                      ),
                      child: Center(child: CircularProgressIndicator(color: primeryColor),
                      ),
                    ),
                  ],
                ],
              );
        },
      ),
    );
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
              constraints: BoxConstraints(maxHeight: Get.height * 0.72),
              width: Get.size.width,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        SizedBox(width: 15),
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
                            ? addressListController.addressListModel!.addressList!.isNotEmpty
                                ? ListView.separated(
                                    itemCount: addressListController.addressListModel!.addressList!.length,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) => SizedBox(height: 13),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              labPackageCartController.addresTitle = "${addressListController.addressListModel!.addressList![index].address}";
                                              labPackageCartController.addressId = "${addressListController.addressListModel!.addressList![index].id}";
                                              debugPrint("adwdjgcjydchbdchdvc ${labPackageCartController.addressId}");
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              width: Get.size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${addressListController.addressListModel!.addressList![index].addressAs} ${"Address".tr}",
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyBold,
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
                                                        color: CupertinoColors.activeGreen,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        "${addressListController.addressListModel!.addressList![index].countryCode} ${addressListController.addressListModel!.addressList![index].phone}",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.gilroyMedium,
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
                                                        color: gradient.defoultColor,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Expanded(
                                                        child: Text(
                                                          "${addressListController.addressListModel!.addressList![index].address}",
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily: FontFamily.gilroyMedium,
                                                            color: greycolor,
                                                            overflow: TextOverflow.ellipsis,
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
                            : Center(child: CircularProgressIndicator(color: gradient.defoultColor)),
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

  //!--------- Razorpay ----------//
  void openCheckout() async {
    debugPrint("${getData.read("UserLogin")}");
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["phone"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(labPackageCartController.total.toString()) * 100).toStringAsFixed(2),
      'name': username,
      'description': "",
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };
    debugPrint("eeee$options");
    try {
      _razorpay.open(options);
    } catch (e) {
      paymentLoading = false;
      setState(() {});
      debugPrint('Error: $e');
    }
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
      uid: "${getData.read("UserLogin")["id"]}",
      amount: "${labPackageCartController.total}",
    ).then((value) {
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
            final transactionId = params['data']?['transactions']?[0]?['related_resources']?[0]?['sale']?['id'];
          
            debugPrint("✅ TRANSACTION ID: $transactionId");
          
            // Optional: Call your function and pass transactionId if needed
            function(params , transactionId);
          
            Fluttertoast.showToast(
              msg: 'SUCCESS PAYMENT : ${params["status"]}\nTransaction ID: $transactionId',
              timeInSecForIosWeb: 4,
            );
          
            paymentLoading = false;
            setState(() {});
          },
          onError: (error) {
            paymentLoading = false;
            setState(() {});
            Fluttertoast.showToast(msg: error.toString(), timeInSecForIosWeb: 4);
          },
          onCancel: (params) {
            paymentLoading = false;
            setState(() {});
            Fluttertoast.showToast(msg: params.toString(), timeInSecForIosWeb: 4);
          },
        ));
      } else {
        paymentLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
      }
    });
  }

  final formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final paymentCard = PaymentCardCreated();
  final autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final card = PaymentCardCreated();

  void getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardTypee cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      paymentCard.type = cardType;
    });
  }

  String getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  //!-------- PaymentSheet --------//
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
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
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
                              itemCount: paymentDetailController.paymentDetailModel!.paymentList.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      paymenttital = paymentDetailController.paymentDetailModel!.paymentList[index].name;
                                      paymentSelect = paymentDetailController.paymentDetailModel!.paymentList[index].id;
                                      razorpaykey = paymentDetailController.paymentDetailModel!.paymentList[index].attribute;
                                      _groupValue = index;
        
                                      debugPrint("xaxbashgsvcvdgcvdcvd---$paymentSelect");
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    padding: EdgeInsets.all(10),
                                    // height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: paymentSelect == paymentDetailController.paymentDetailModel!.paymentList[index].id
                                            ? gradient.defoultColor
                                            : Colors.grey.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(shape: BoxShape.circle,),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(65),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: "assets/ezgif.com-crop.gif",
                                              placeholderCacheHeight: 60,
                                              placeholderCacheWidth: 60,
                                              image: "${Config.imageBaseurlDoctor}${paymentDetailController.paymentDetailModel!.paymentList[index].image}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                paymentDetailController.paymentDetailModel!.paymentList[index].name,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              SizedBox(
                                                width: 190,
                                                child: Text(
                                                  paymentDetailController.paymentDetailModel!.paymentList[index].subTitle,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily: FontFamily.gilroyMedium,
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
                          : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
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
                      if (paymentLoading == false) {
                        paymentLoading = true;
                        setState(() {});
                        if (paymenttital == "Razorpay") {
                          Get.back();
                          openCheckout();
                        } else if (paymenttital == "Paypal") {
                          List<String> keyList = razorpaykey.split(",");
                          debugPrint("dsdsdsdc $keyList");
                          paypalPayment(
                            function: (e,t) {
                              bookLabAppointment(transactionID: t);
                            },
                            context: context,
                            amt: labPackageCartController.total.toString(),
                            clientId: keyList[0],
                            secretKey: keyList[1],
                          );
                        } else if (paymenttital == "Cash") {
                          bookLabAppointment();
                        } else if (paymenttital == "Stripe") {
                          stripController.stripApi(
                            uid: "${getData.read("UserLogin")["id"]}",
                            amount: "${labPackageCartController.total}",
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
                                      stripController.stripSuccessGetDataApi(paymentIntent: "${uri.queryParameters["payment_intent"]}").then((value) {
                                        if (value["status"] == true) {
                                          debugPrint("************ transactionId: ${value["transactionId"]}");
                                          bookLabAppointment(transactionID: value["transactionId"]);
                                        } else {
                                          paymentLoading = false;
                                          setState(() {});
                                          Get.back();
                                          showToastMessage("${uri.queryParameters["status"]}");
                                        }
                                      });
                                      return NavigationDecision.prevent;
                                    } else if (request.url.toString().contains("cancel") == false) {
                                      paymentLoading = false;
                                      setState(() {});
                                      Get.back();
                                      return NavigationDecision.prevent;
                                    }
                                    paymentLoading = false;
                                    setState(() {});
                                    return NavigationDecision.navigate;
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                            }
                          });
                        } else if (paymenttital == "PayStack") {
                          payStackController.payStackApi(
                            uid: "${getData.read("UserLogin")["id"]}",
                            amount: "${labPackageCartController.total}",
                          ).then((value) {
                            if (value["status"] == true) {
                              Get.to(
                                PaymentWebVIew(
                                  initialUrl: value["PaystackURL"],
                                  navigationDelegate: (request) {
                                  final uri = Uri.parse(request.url);
                                    debugPrint("************ Navigating to URL: ${request.url}");
                                    debugPrint("************ Parsed URI: $uri");
                                    debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                                    debugPrint("************ trxref: ${uri.queryParameters["trxref"]}");
                                    debugPrint("************ reference: ${uri.queryParameters["reference"]}");
                                    if (uri.queryParameters["trxref"] != null && uri.queryParameters["reference"] != null) {
                                      payStackController.payStackSuccessGetDataApi(
                                        trxref: "${uri.queryParameters["trxref"]}",
                                        reference: "${uri.queryParameters["reference"]}",
                                      ).then((value) {
                                        debugPrint("************ value: $value");
                                        if (value["status"] == true) {
                                          bookLabAppointment(transactionID: "${value["transactionId"]}");
                                        } else {
                                          paymentLoading = false;
                                          setState(() {});
                                          Get.back();
                                          showToastMessage("${uri.queryParameters["status"]}");
                                        }
                                      });
                                      return NavigationDecision.prevent;
                                    } else {
                                      paymentLoading = false;
                                      setState(() {});
                                      Get.back();
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order not placed")));
                                      return NavigationDecision.navigate;
                                    }
                                  },
                                ),
                              );
                            } else {
                              paymentLoading = false;
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                            }
                          });
                        } else if (paymenttital == "FlutterWave") {
                          flutterWaveController.flutterWaveApi(
                            amount: labPackageCartController.total.toString(),
                            uid: getData.read("UserLogin")["id"].toString(),
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
                                        flutterWaveController.flutterWaveSuccessGetDataApi(
                                          txref: "${uri.queryParameters["tx_ref"]}",
                                          transactionId: "${uri.queryParameters["transaction_id"]}",
                                        ).then((value) {
                                          if (value["status"] == true) {
                                            bookLabAppointment(transactionID: "${value["transactionId"]}");
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            showToastMessage("${uri.queryParameters["status"]}");
                                          }
                                        });
                                        return NavigationDecision.prevent;
                                      } else {
                                        paymentLoading = false;
                                        setState(() {});
                                        Get.back();
                                        showToastMessage("${uri.queryParameters["status"]}");
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                            }
                          });
                        } else if (paymenttital == "Paytm") {
                        } else if (paymenttital == "SenangPay") {
                          senangPayController.senangPayApi(amount: "${labPackageCartController.total}").then((value) {
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
                                          paymentLoading = false;
                                          setState(() {});
                                          Get.back();
                                          showToastMessage("${uri.queryParameters["status"]}");
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
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                              }
                            });
                        } else if (paymenttital == "MercadoPago") {
                        } else if (paymenttital == "Payfast") {
                          payfastPaymentController.payfastPaymentApi(
                            amount: labPackageCartController.total.toString(),
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
                                      await payfastPaymentController.payfastSuccessGetDataApi(transactionId: transactionId).then((value) {
                                        if (value["status"] == true) {
                                          bookLabAppointment(transactionID: "${value["transactionId"]} ");
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                            }
                          });
                        } else if (paymenttital == "Midtrans") {
                          midTransController.midTransApi(
                            amount: labPackageCartController.total.toString(),
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
                                        midTransController.midTransSuccessGetDataApi(orderId: "${uri.queryParameters["order_id"]}").then((value) {
                                          debugPrint("************ transactionId: ${value["transactionId"]}");
                                          if (value["status"] == true) {
                                            bookLabAppointment(transactionID: "${value["transactionId"]} ");
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            showToastMessage("${value["message"]}");
                                          }
                                        });
                                        return NavigationDecision.prevent;
                                      } else {
                                        paymentLoading = false;
                                        setState(() {});
                                        Get.back();
                                        showToastMessage("${uri.queryParameters["status"]}");
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                            }
                          });
                        }
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
}
