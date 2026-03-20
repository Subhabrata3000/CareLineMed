// ignore_for_file: must_be_immutable, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry/controller/payment_controller/payfast_payment_controller.dart';
import 'package:laundry/controller/payment_controller/senang_pay_controller.dart';
import 'package:laundry/controller_doctor/home_controller.dart';
import 'package:laundry/controller_doctor/succesee_controller.dart';
import 'package:laundry/screen/sucsess_full_order.dart';
import 'package:laundry/widget/button.dart';
import 'package:laundry/widget/coupon_apply_sucsessfull.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller_doctor/add_order_controller.dart';
import '../controller_doctor/cart_detail_controller.dart';
import '../controller/payment_controller/flutterwave_controller.dart';
import '../controller/payment_controller/midtrans_controller.dart';
import '../controller/payment_controller/paypal_controller.dart';
import '../controller/payment_controller/paystack_controller.dart';
import '../controller/payment_controller/strip_controller.dart';
import '../controller/payment_detail_controller.dart';
import '../controller_doctor/doctor_detail_controller.dart';
import '../helpar/routes_helper.dart';
import '../model/font_family_model.dart';
import '../screen/paypal/flutter_paypal.dart';
import '../utils/custom_colors.dart';
import '../utils/customwidget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../widget/add_pet_bottom.dart';
import 'PaymentGateway/PaymentCard.dart';
import 'PaymentGateway/common_webview.dart';

class YourCartScreen extends StatefulWidget {
  final String doctorId;
  final String subDepartmentId;
  final String departmentId;
  final String hospitalId;
  final String serviceType;
  final String date;
  final String time;
  final String day;
  final num price;
  String? cartStatus;
  String? oID;
  String? serviceID;

  YourCartScreen({
    super.key,
    required this.doctorId,
    required this.subDepartmentId,
    required this.hospitalId,
    required this.serviceType,
    required this.date,
    required this.time,
    required this.price,
    required this.departmentId,
    required this.day,
    this.cartStatus,
    this.oID,
    this.serviceID,
  });

  @override
  State<YourCartScreen> createState() => YourCartScreenState();
}

double total = 0.0;
double getTotal = 0.0;
int groupValue = 0;
int getMaxDelivery = 1;

class YourCartScreenState extends State<YourCartScreen> {
  String couponCode = "";
  double proTotal = 0;
  var useWallet = 0.0;
  String wallet = "";
  var tempWallet = 0.0;

  int? _groupValue;
  String? selectidPay = "0";
  String razorpaykey = "";
  String? paymenttital;

  int cnt = 1;

  bool status = false;

  int? timeSlotValue;

  int? droptimeSlotValue;

  String timeSlot = "";

  String dropSlot = "";

  List<int> maxDelivery = [];

  TextEditingController writeinstruction = TextEditingController();

  late Razorpay _razorpay;

  String formattedDate = "";

  String dropDate = "";

  double storeTotal = 0.0;

  bool paymentLoading = false;

  @override
  void initState() {
    super.initState();
    fun();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    paymentDetailController.paymentDetailApi();
  }

  fun() async {
    familyMember.clear();
    setState(() {});
    cartDetailController.cartDetailApi(
      doctorId: widget.doctorId.toString(),
      subDepartmentId: widget.subDepartmentId.toString(),
      hospitalId: widget.hospitalId.toString(),
    ).then((value) {
      tempWallet = double.parse(cartDetailController.cartDetailModel!.walletAmount.toString());

      setState(() {});
      cartDetailController.commission = cartDetailController.cartDetailModel!.commissionData.commisiionType == "fix"
          ? double.parse(cartDetailController.cartDetailModel!.commissionData.commissionRate)
          : widget.price * double.parse(cartDetailController.cartDetailModel!.commissionData.commissionRate) / 100;
      setState(() {});

      debugPrint("---------------- id ---------------- ${cartDetailController.cartDetailModel!.familyMember.first.id}");

      familyMember.add(cartDetailController.cartDetailModel!.familyMember.first.id);

      setState(() {});
    });
  }

  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());

  bool switchValue = false;
  bool frontGateSwitch = false;
  bool buttonEnabled = true;
  List value_1 = [];
  List familyMember = [];
  int currentIndex = 0;
  int paymentSelect = 0;
  double commission = 0;

  CartDetailController cartDetailController = Get.put(CartDetailController());
  PaymentDetailController paymentDetailController = Get.put(PaymentDetailController());
  AddPetController addPetController = Get.put(AddPetController());
  HomeController homeController = Get.put(HomeController());
  AddOrderController addOrderController = Get.put(AddOrderController());
  StripController stripController = Get.put(StripController());
  PayStackController payStackController = Get.put(PayStackController());
  FlutterWaveController flutterWaveController = Get.put(FlutterWaveController());
  MidTransController midTransController = Get.put(MidTransController());
  SenangPayController senangPayController = Get.put(SenangPayController());
  PayfastPaymentController payfastPaymentController = Get.put(PayfastPaymentController());

  TextEditingController caregiverController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  PayPalController payPalController = Get.put(PayPalController());

  SucceseeControllerController succeseeControllerController = Get.put(SucceseeControllerController());

  void onButtonPressed() {
    setState(() {
      buttonEnabled = false;
    });
  }

  addOrderApi({String? trId}) {
    paymentLoading = true;
    setState(() {});
    addOrderController.addOrderApi(
        doctorId: widget.doctorId.toString(),
        departmentID: widget.departmentId.toString(),
        hospitalID: widget.hospitalId.toString(),
        showType: widget.serviceType.toString(),
        showTypePrice: "${widget.price}",
        time: widget.time,
        dateTime: widget.date,
        dateType: widget.day.toString(),
        subDepId: widget.subDepartmentId.toString(),
        familyId: familyMember.join(",").toString(),
        message: caregiverController.text,
        couponId: cartDetailController.couponId.toString(),
        couponAmount: cartDetailController.couponAmt.toString(),
        address: cartDetailController.addressId.toString(),
        totalPrice: cartDetailController.total.toString(),
        additionalPrice: cartDetailController.additionalPetCharge.toString(),
        doctorCommission: cartDetailController.sitterCharge.toString(),
        siteCommission: cartDetailController.commission.toString(),
        paymentType: paymentSelect.toString(),
        walletAmount: useWallet.toString(),
        context: context,
        transactionId: trId ?? ""
    ).then((value) {
      debugPrint("-------------------------------------------- $value");
      if (value["Result"] == true) {
        paymentLoading = false;
        successFully(
          appointmentID: "${value["appointment_id"]}",
        );
        setState(() {});
      } else {
        paymentLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
      }
    });
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("dd, MMM yyyy").format(parsedDate);
  }

  @override
  void dispose() {
    numberController.removeListener(getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    cartDetailController.isLoading = false;
    cartDetailController.additionalPetCharge = 0;
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (addOrderController.isOrderLoading != true) {
          if (widget.cartStatus == "1") {
            cartDetailController.changeIndex(0);
          } else if (widget.cartStatus == "2") {
            Get.back();
          }
        }
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            color: BlackColor,
            onPressed: () {
              cartDetailController.addresTitle = "";
              if (addOrderController.isOrderLoading != true) {
                if (widget.cartStatus == "1") {
                  cartDetailController.changeIndex(0);
                } else if (widget.cartStatus == "2") {
                  Get.back();
                }
              }
              Get.back();
            },
          ),
          title: Text(
            "Review & Pay".tr,
            style: TextStyle(
              color: BlackColor,
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<CartDetailController>(
          builder: (cartDetailController) {
            return Container(
              width: Get.size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: WhiteColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${getData.read("currency")}${cartDetailController.total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "View Detailed Bill".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                            color: gradient.defoultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 2.3,
                    child: paymentLoading
                        ? loaderButton(borderRadius: BorderRadius.circular(15))
                        : button(
                      text: "Proceed".tr,
                      color: primeryColor,
                      borderRadius: BorderRadius.circular(15),
                      onPress: () {
                        if (familyMember.isNotEmpty) {
                          cartDetailController.total == 0
                              ? addOrderApi()
                              : paymentSheet();
                        } else {
                          Fluttertoast.showToast(msg: "Please Select Patient".tr);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        body: GetBuilder<CartDetailController>(
          builder: (cartDetailController) {
            return cartDetailController.isLoading
                ? Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: Get.size.width,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/ezgif.com-crop.gif",
                                placeholderCacheHeight: 150,
                                placeholderCacheWidth: 200,
                                placeholderFit: BoxFit.cover,
                                image: "${Config.imageBaseurlDoctor}${cartDetailController.cartDetailModel!.doctor.logo}",
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              cartDetailController.cartDetailModel!.doctor.name,
                              maxLines: 1,
                              style: TextStyle(
                                color: BlackColor,
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 19,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              cartDetailController.cartDetailModel!.depSubSerList.departmentName,
                              maxLines: 1,
                              style: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: SvgPicture.asset(
                                    "assets/star.svg",
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(width: 1),
                                Text(
                                  cartDetailController.cartDetailModel!.doctor.avgStar.toStringAsFixed(1),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: greytext,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: greytext,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${cartDetailController.cartDetailModel!.doctor.yearOfExperience} ${"Year Experience".tr}",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: greytext,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detail appointment".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 17,
                                color: BlackColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/ezgif.com-crop.gif",
                                        placeholderCacheHeight: 55,
                                        placeholderCacheWidth: 55,
                                        placeholderFit: BoxFit.cover,
                                        image: "${Config.imageBaseurlDoctor}${cartDetailController.cartDetailModel!.hospital.image}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.serviceType == "1"
                                              ? "In Person appointment".tr
                                              : "Video Visit appointment".tr,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          cartDetailController.cartDetailModel!.hospital.name,
                                          style: TextStyle(
                                            color: greytext,
                                            fontSize: 13,
                                            fontFamily: FontFamily.gilroyMedium,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 19,
                                              child: Image.asset(
                                                "assets/calendar1.png",
                                                color: greytext,
                                              ),
                                            ),
                                            SizedBox(width: 5),

                                            // --- FIXED OVERFLOW HERE ---
                                            Flexible(
                                              child: Text(
                                                formatDate(widget.date),
                                                style: TextStyle(
                                                  color: greytext,
                                                  fontSize: 13,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(
                                                color: greytext,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                widget.time,
                                                style: TextStyle(
                                                  color: greytext,
                                                  fontSize: 13,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            // ---------------------------

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${widget.price.toStringAsFixed(1)}${getData.read("currency")}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 17,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(cartDetailController.cartDetailModel!.walletAmount != 0)...[
                        SizedBox(height: 10),
                        Container(
                          width: Get.size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 5),
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
                                      activeTrackColor: gradient.defoultColor,
                                      value: status,
                                      onChanged: (value) {
                                        setState(() {
                                          status = value;
                                          walletCalculation(value);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10),
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
                                      "${getData.read("currency")}${tempWallet.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 16,
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 10),

                      //! ---------- Select Patient -----------!//

                      Container(
                        width: Get.size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: WhiteColor,
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
                            SizedBox(height: 10),
                            Text(
                              "Message".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 16,
                                color: BlackColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: caregiverController,
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
                                contentPadding: const EdgeInsets.only(top: 20, left: 12, right: 12),
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

                      SizedBox(height: 10),

                      //! ---------- Coupon Widget -----------!//
                      Container(
                        width: Get.size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (couponCode == "") {
                              status = false;
                              walletCalculation(false);
                              setState(() {});
                              Get.toNamed(Routes.couponScreen, arguments: {
                                "price": cartDetailController.total,
                                "labPackCart": false
                              })!.then((value) {
                                setState(() {
                                  couponCode = value;
                                });
                                couponSucsessFullyApplyed(couponAmt: "${cartDetailController.couponAmt}");
                              });
                            } else {
                              status = false;
                              walletCalculation(false);
                              setState(() {});
                              useWallet = 0;
                              cartDetailController.couponAmt = 0;
                              couponCode = "";
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
                                            couponCode != ""
                                                ? Row(
                                              children: [
                                                Text(
                                                  "${"Use code".tr} : ",
                                                  style: TextStyle(
                                                    color: textcolor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                                Text(
                                                  couponCode,
                                                  style: TextStyle(
                                                    color: textcolor,
                                                    fontFamily: FontFamily.gilroyBold,
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
                                          useWallet = 0;
                                          cartDetailController.couponAmt = 0;
                                          couponCode = "";
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
                                          if (couponCode == "") {
                                            status = false;
                                            walletCalculation(false);
                                            setState(() {});
                                            Get.toNamed(
                                                Routes.couponScreen,
                                                arguments: {
                                                  "price": cartDetailController.total,
                                                  "labPackCart": false,
                                                })!.then((value) {
                                              setState(() {
                                                couponCode = value;
                                              });
                                              couponSucsessFullyApplyed(couponAmt: "${cartDetailController.couponAmt}");
                                            });
                                          } else {
                                            status = false;
                                            walletCalculation(false);
                                            setState(() {});
                                            useWallet = 0;
                                            cartDetailController.couponAmt = 0;
                                            couponCode = "";
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
                                  if (couponCode == "") {
                                    status = false;
                                    walletCalculation(false);
                                    setState(() {});
                                    Get.toNamed(
                                        Routes.couponScreen,
                                        arguments: {
                                          "price": cartDetailController.total,
                                          "labPackCart": false,
                                        })!.then((value) {
                                      setState(() {
                                        couponCode = value;
                                      });
                                      couponSucsessFullyApplyed(couponAmt: "${cartDetailController.couponAmt}");
                                    });
                                  } else {
                                    status = false;
                                    walletCalculation(false);
                                    setState(() {});
                                    useWallet = 0;
                                    cartDetailController.couponAmt = 0;
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
                                        fontFamily: FontFamily.gilroyMedium,
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
                      //! ---------- Total Bill ----------!/

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
                              subtitle: "${widget.price.toStringAsFixed(2)}${getData.read("currency")}",
                            ),
                            if(cartDetailController.additionalPetCharge != 0)...[
                              SizedBox(height: 8),
                              DottedLine(dashColor: greyColor),
                              SizedBox(height: 8),
                              billSummaryTextCart(
                                title: "Additional Patient Charge".tr,
                                subtitle: cartDetailController.isLoading ? "${cartDetailController.additionalPetCharge}${getData.read("currency")}" : "",
                              ),
                            ],

                            if(status)...[
                              SizedBox(height: 8),
                              DottedLine(dashColor: greyColor),
                              SizedBox(height: 8),
                              billSummaryTextCart(
                                title: "Wallet".tr,
                                subtitle: "${useWallet.toStringAsFixed(2)}${getData.read("currency")}",
                              ),
                            ],
                            if(couponCode != "")...[
                              SizedBox(height: 8),
                              DottedLine(dashColor: greyColor),
                              SizedBox(height: 8),
                              billSummaryTextCart(
                                title: "Coupon".tr,
                                subtitle: "- ${cartDetailController.couponAmt}${getData.read("currency")}",
                              ),
                            ],

                            SizedBox(height: 8),
                            DottedLine(dashColor: greyColor),
                            SizedBox(height: 8),
                            InkWell(
                              key: buttonKey,
                              onTap: cartDetailController.sitterCharge != 0 ? () => toggleTooltip() : null,
                              child: billSummaryTextCart(
                                title: cartDetailController.cartDetailModel!.commissionData.commisiionType == "fix"
                                    ? "${"Service Fee & Tax".tr} (${cartDetailController.cartDetailModel!.commissionData.commisiionType})"
                                    : "${"Service Fee & Tax".tr} (${cartDetailController.cartDetailModel!.commissionData.commissionRate}${cartDetailController.cartDetailModel!.commissionData.commisiionType})",
                                subtitle: "${cartDetailController.serviceTax}${getData.read("currency")}",
                                image: cartDetailController.sitterCharge != 0 ? "assets/info-circle.png" : null,
                              ),
                            ),

                            SizedBox(height: 8),
                            DottedLine(dashColor: greyColor),
                            SizedBox(height: 8),
                            billSummaryTextCart(
                              fontFamily: FontFamily.gilroyBold,
                              title: "Total Payable Amount".tr,
                              subtitle: "${cartDetailController.total.toStringAsFixed(2)}${getData.read("currency")}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
          },
        ),
      ),
    );
  }

  //!--------- Address Sheet -----------!//
  Future addressShit({String? isCheck}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                Container(
                  height: Get.height * 0.72,
                  width: Get.size.width,
                  decoration: BoxDecoration(
                    color: bgcolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  walletCalculation(value) {
    if (value == true) {
      if (double.parse(cartDetailController.cartDetailModel!.walletAmount.toString()) < double.parse(cartDetailController.total.toString())) {
        useWallet = double.parse(cartDetailController.cartDetailModel!.walletAmount.toString());
        tempWallet = 0;
        setState(() {});
      } else {
        cartDetailController.total = 0;
      }
    } else {
      status = false;
      tempWallet = 0;
      tempWallet = double.parse(cartDetailController.cartDetailModel!.walletAmount.toString());
      cartDetailController.total = cartDetailController.total + useWallet;
      useWallet = 0;
      setState(() {});
    }
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
        return Container(
          constraints: BoxConstraints(maxHeight: Get.height / 1.2),
          child: StatefulBuilder(
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
                  Flexible(
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
                                  debugPrint("xaxbashgsvcvdgcvdcvd $paymentSelect");
                                  paymentLoading = false;
                                  setState(() {});
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
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
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
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
                        if (paymentLoading == false && paymentSelect != 0) {
                          paymentLoading = true;
                          setState(() {});
                          if (paymenttital == "Razorpay") {
                            addOrderController.setOrderLoading();
                            Get.back();
                            openCheckout();
                          } else if (paymenttital == "Paypal") {
                            addOrderController.setOrderLoading();
                            List<String> keyList = razorpaykey.split(",");
                            paypalPayment(
                              function: (e , t) {
                                addOrderApi(trId: t);
                              },
                              context: context,
                              amt: cartDetailController.total.toString(),
                              clientId: keyList[0],
                              secretKey: keyList[1],
                            );
                          } else if (paymenttital == "Cash") {
                            if (widget.serviceType == "1") {
                              addOrderApi();
                            } else {
                              Get.back();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You have selected a video visit, so cash payment is not available. Your payment has been made online or wallet.".tr,
                                    style: const TextStyle(
                                      fontFamily: "Gilroy Bold",
                                      fontSize: 14,
                                    ),
                                  ),
                                  backgroundColor: primeryColor,
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 0,
                                  duration: const Duration(seconds: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          } else if (paymenttital == "Stripe") {
                            stripController.stripApi(
                              uid: getData.read("UserLogin")["id"].toString(),
                              amount: cartDetailController.total.toString(),
                            ).then((value) {
                              if (value["status"] == true) {
                                Get.to(
                                  PaymentWebVIew(
                                    initialUrl: value["StripeURL"],
                                    navigationDelegate: (request) {
                                      final uri = Uri.parse(request.url);

                                      if (request.url.toString().contains("success") == true) {
                                        stripController.stripSuccessGetDataApi(paymentIntent: "${uri.queryParameters["payment_intent"]}").then((value) {
                                          if (value["status"] == true) {
                                            debugPrint("************ transactionId: ${value["transactionId"]}");
                                            addOrderApi(trId: value["transactionId"]);
                                          } else {
                                            paymentLoading = false;
                                            setState(() {});
                                            Get.back();
                                            showToastMessage("${value["message"]}");
                                          }
                                        });
                                        return NavigationDecision.prevent;
                                      } else if (request.url.toString().contains("cancel") == false) {
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
                                paymentLoading = false;
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                              }
                            });
                          } else if (paymenttital == "PayStack") {
                            payStackController.payStackApi(
                              uid: getData.read("UserLogin")["id"].toString(),
                              amount: cartDetailController.total.toString(),
                            ).then((value) {
                              if (value["status"] == true) {
                                Get.to(PaymentWebVIew(
                                  initialUrl: value["PaystackURL"],
                                  navigationDelegate: (request) {
                                    final uri = Uri.parse(request.url);

                                    if (uri.queryParameters["trxref"] != null && uri.queryParameters["reference"] != null) {
                                      payStackController.payStackSuccessGetDataApi(
                                        trxref: "${uri.queryParameters["trxref"]}",
                                        reference: "${uri.queryParameters["reference"]}",
                                      ).then((value) {
                                        debugPrint("************ value: $value");
                                        if (value["status"] == true) {
                                          addOrderApi(trId: "${value["transactionId"]}");
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
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order not placed")));
                                      return NavigationDecision.navigate;
                                    }
                                  },
                                ));
                              } else {
                                paymentLoading = false;
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${value["message"]}")));
                              }
                            });
                          } else if (paymenttital == "FlutterWave") {
                            flutterWaveController.flutterWaveApi(
                              amount: cartDetailController.total.toString(),
                              uid: getData.read("UserLogin")["id"].toString(),
                            ).then((value) {
                              if (value["status"] == true) {
                                Get.to(
                                  PaymentWebVIew(
                                    initialUrl: value["FlutterwaveURL"],
                                    navigationDelegate: (request) {
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
                                              addOrderApi(trId: "${value["transactionId"]}");
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
                          } else if (paymenttital == "Paytm") {
                          } else if (paymenttital == "SenangPay") {
                            senangPayController.senangPayApi(amount: "${cartDetailController.total}").then((value) {
                              if (value["status"] == true) {
                                Get.to(
                                  PaymentWebVIew(
                                    initialUrl: value["SenangPayURL"],
                                    navigationDelegate: (request) {
                                      final uri = Uri.parse(request.url);

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
                              amount: cartDetailController.total.toString(),
                            ).then((value) {
                              if (value["status"] == true) {
                                debugPrint("-------------- value[payFastLink] ----------- ${value["payFastLink"]}");
                                Get.to(
                                  PaymentWebVIew(
                                    initialUrl: value["payFastLink"],
                                    navigationDelegate: (request) async {
                                      final uri = Uri.parse(request.url);

                                      if (uri.queryParametersAll.isNotEmpty) {
                                        Uri returnUrl = Uri.parse("${uri.queryParameters["return_url"]}");
                                        String transactionId = "${returnUrl.queryParameters['transactionId']}";
                                        debugPrint("-------------- transactionId ----------- $transactionId");
                                        await payfastPaymentController.payfastSuccessGetDataApi(transactionId: transactionId).then((value) {
                                          if (value["status"] == true) {
                                            addOrderApi(trId: "${value["transactionId"]} ");
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
                              amount: cartDetailController.total.toString(),
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
                                              addOrderApi(trId: "${value["transactionId"]} ");
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
          ),
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
      'amount': (double.parse(cartDetailController.total.toString()) * 100).toStringAsFixed(2),
      'name': username,
      'description': "",
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };
    debugPrint("---------- options ---------- $options");
    try {
      _razorpay.open(options);
    } catch (e) {
      paymentLoading = false;
      setState(() {});
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("---------- response ---------- $response");
    addOrderApi(trId: "${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: ${"ERROR: ${response.code} - ${response.message!}"}');
    setState(() {
      addOrderController.isOrderLoading = false;
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

  // var paymentData;
  paypalPayment({
    required String amt,
    required String clientId,
    required String secretKey,
    var function,
    context,
  }) {
    // Get.back();
    debugPrint("============ clientId ============ $clientId");
    debugPrint("=========== secretKey ============ $secretKey");

    payPalController.paypalApi(
      uid: getData.read("UserLogin")["id"].toString(),
      amount: cartDetailController.total.toString(),
    ).then((value) {
      debugPrint("------------ value :-----  $value");
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
          // onSuccess: (Map params) {
          //   log("$params",name: "-------------- SUCCESS PAYMENT :-- ");
          //   paymentData = response.data['transactions'][0]['related_resources'][0]['sale']['id'];
          //   log("$paymentData",name: "-------------- paymentData :-- ");
          //   function(params);
          //   Fluttertoast.showToast(msg: 'SUCCESS PAYMENT : ${params["status"]}', timeInSecForIosWeb: 4);
          //   paymentLoading = false;
          //   setState(() {});
          // },
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

  final GlobalKey buttonKey = GlobalKey();
  OverlayEntry? overlayEntry;
  bool tooltipVisible = false;

  void toggleTooltip() {
    if (tooltipVisible) {
      hideTooltip();
    } else {
      showTooltip();
    }
  }

  void showTooltip() {
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: hideTooltip, // Tap outside to close
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx + 62,
            top: position.dy - 75,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(cartDetailController.commission != 0)...[
                          billSummaryTextDetaile(title: "Service Fee & Tax".tr, subtitle: "${getData.read("currency")} ${cartDetailController.commission}"),
                        ],
                        if(cartDetailController.sitterCharge != 0)...[
                          SizedBox(height: 5),
                          billSummaryTextDetaile(title: "Doctor Commission".tr, subtitle: "${getData.read("currency")} ${cartDetailController.sitterCharge}"),
                        ],
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: DownwardTrianglePainter(),
                    child: SizedBox(width: 15, height: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    tooltipVisible = true;
  }

  void hideTooltip() {
    overlayEntry?.remove();
    overlayEntry = null;
    tooltipVisible = false;
  }

  // void successFully({required String appointmentID}) {
  //   Get.offAll(() => SucsessFullOrder(appointmentId: appointmentID));
  // }

  void showCouponDialog({required String couponAmt}) {
    couponSucsessFullyApplyed(couponAmt: couponAmt);
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget loaderButton({BorderRadius? borderRadius}) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: gradient.defoultColor,
        borderRadius: borderRadius ?? BorderRadius.circular(30),
      ),
      child: Center(
        child: CircularProgressIndicator(color: WhiteColor),
      ),
    );
  }
}

class DownwardTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// queryParamiter: {
//.  merchant_id: [10000100],
//.  merchant_key: [46f0cd694581a],
//.  amount: [110],
//.  item_name: [test1],
//.  email_address: [test1@gmail.com],
//.  return_url: [http://192.168.1.12:3006/customer/payfast-success?transactionId=ORDER-1751957121860145&status=1],
//.  cancel_url: [http://192.168.1.12:3006/customer/payfast-cancel?transactionId=ORDER-1751957121860145&status=1],
//.  notify_url: [http://192.168.1.12:3006/customer/payfast-notify?transactionId=ORDER-1751957121860145&status=1]
// }