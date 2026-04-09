// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/address_list_controller.dart';
import 'package:carelinemed/controller/shop_add_order_controller.dart';
import 'package:carelinemed/screen/bottombarpro_screen.dart';
import 'package:carelinemed/controller/payment_detail_controller.dart';
import 'package:carelinemed/screen/shop/my%20order/my_order_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/font_family_model.dart';
import '../utils/custom_colors.dart';

class OurProductCheckoutScreen extends StatefulWidget {
  const OurProductCheckoutScreen({super.key});

  @override
  State<OurProductCheckoutScreen> createState() =>
      _OurProductCheckoutScreenState();
}

class _OurProductCheckoutScreenState extends State<OurProductCheckoutScreen> {
  AddressListController addressListController =
      Get.put(AddressListController());
  ShopAddOrderController shopAddOrderController =
      Get.put(ShopAddOrderController());
  PaymentDetailController paymentDetailController =
      Get.put(PaymentDetailController());

  late Razorpay _razorpay;
  String razorpaykey = "";
  int paymentSelect = 1; // Default to Cash (ID 1)
  String paymenttital = "Cash";

  List<Map<String, dynamic>> cartItems = [];
  String currency = "";
  int? selectedAddressId;
  // String selectedPaymentMethod = "Cash"; // Replaced by paymentSelect/paymenttital
  bool isPlacingOrder = false;
  bool isPaymentLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
    currency = "${getData.read("currency") ?? "₹"}";
    addressListController.addressListApi(
        uid: "${getData.read("UserLogin")["id"]}");
    paymentDetailController.paymentDetailApi();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _placeOrder(transactionID: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => isPlacingOrder = false);
    Fluttertoast.showToast(msg: response.message ?? "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => isPlacingOrder = false);
    Fluttertoast.showToast(msg: response.walletName ?? "External Wallet");
  }

  void _openRazorpay() {
    final tax = subtotal * 0.05;
    final total = subtotal + tax;

    var options = {
      'key': razorpaykey,
      'amount': (total * 100).toStringAsFixed(0),
      'name': "${getData.read("UserLogin")["name"]}",
      'description': "Order Payment",
      'timeout': 300,
      'prefill': {
        'contact': "${getData.read("UserLogin")["phone"]}",
        'email': "${getData.read("UserLogin")["email"]}"
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay Error: $e");
      setState(() => isPlacingOrder = false);
    }
  }

  void _loadCart() {
    final stored = getData.read("OurProductCart");
    if (stored != null && stored is List) {
      cartItems = List<Map<String, dynamic>>.from(
          stored.map((e) => Map<String, dynamic>.from(e)));
    }
    setState(() {});
  }

  void _saveCart() {
    save("OurProductCart", cartItems);
  }

  void _updateQty(int index, int delta) {
    setState(() {
      int newQty = (cartItems[index]["qty"] as int) + delta;
      if (newQty <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index]["qty"] = newQty;
      }
      _saveCart();
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      _saveCart();
    });
  }

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      total += (item["price"] as num) * (item["qty"] as int);
    }
    return total;
  }

  int get totalItemCount {
    int count = 0;
    for (var item in cartItems) {
      count += item["qty"] as int;
    }
    return count;
  }

  String _getImageUrl(String imageName) {
    if (imageName.isEmpty) return '';
    if (imageName.startsWith('http')) return imageName;
    return '${Config.socketUrlDoctor}/images/$imageName';
  }

  void _placeOrder({String? transactionID}) {
    if (cartItems.isEmpty) {
      Fluttertoast.showToast(msg: "Your cart is empty");
      return;
    }

    if (selectedAddressId == null) {
      Fluttertoast.showToast(msg: "Please select a delivery address".tr);
      return;
    }

    setState(() => isPlacingOrder = true);

    // If Razorpay is selected and no transactionID yet, open Razorpay
    if (paymenttital == "Razorpay" && transactionID == null) {
      _openRazorpay();
      return;
    }

    final productList = cartItems
        .map((e) => {
              "id": int.tryParse(e["id"].toString()) ?? 0,
              "qty": e["qty"],
              "ptype": e["ptype"] ?? "Regular",
              "price": e["price"],
              "pre_require": "Unrequired",
            })
        .toList();

    shopAddOrderController
        .shopAddOrderApi(
      uid: "${getData.read("UserLogin")["id"]}",
      sitterId: "our_product",
      totalPrice: subtotal,
      couponId: "",
      couponAmount: 0,
      sitterCommission: 0,
      address: selectedAddressId.toString(),
      walletAmount: 0,
      paymentId: paymentSelect.toString(),
      transactionId: transactionID ?? "TXN-${DateTime.now().millisecondsSinceEpoch}",
      productList: productList,
    )
        .then((value) {
      setState(() => isPlacingOrder = false);
      if (value["Result"] == true) {
        // Clear cart on success
        cartItems.clear();
        _saveCart();
        Fluttertoast.showToast(msg: "${value["message"]}");
        Get.offAll(() => BottomBarScreen());
        Get.to(() => MyOrderScreen());
      } else {
        Fluttertoast.showToast(
            msg: value["message"] ?? "Failed to place order");
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
        centerTitle: true,
        title: Text(
          "Checkout".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: WhiteColor,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === ORDER ITEMS ===
                        _buildOrderItemsSection(),
                        const SizedBox(height: 16),

                        // === ADDRESS SELECTION ===
                        _buildAddressSection(),
                        const SizedBox(height: 16),

                        // === PAYMENT METHOD ===
                        _buildPaymentMethodSection(),
                        const SizedBox(height: 16),

                        // === ORDER SUMMARY ===
                        _buildOrderSummary(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // === PLACE ORDER BUTTON ===
                _buildPlaceOrderButton(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add products from Our Products to get started".tr,
            style: TextStyle(
              fontSize: 14,
              fontFamily: FontFamily.gilroyMedium,
              color: greycolor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: gradient.defoultColor,
              foregroundColor: WhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              "Browse Products".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
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
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            separatorBuilder: (_, __) => Divider(color: greyColor),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              final imageUrl = _getImageUrl(item["image"] ?? "");

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                              ),
                            )
                          : Icon(Icons.image_not_supported,
                              color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"] ?? "",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 14,
                            color: BlackColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$currency${(item["price"] as num).toStringAsFixed(0)}",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                            color: BlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: gradient.defoultColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _updateQty(index, -1),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.remove,
                                size: 18, color: gradient.defoultColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "${item["qty"]}",
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 14,
                              color: gradient.defoultColor,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _updateQty(index, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.add,
                                size: 18, color: gradient.defoultColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Delete button
                  InkWell(
                    onTap: () => _removeItem(index),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.delete_outline,
                          size: 22, color: Colors.red.shade400),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
            ),
          ),
          const SizedBox(height: 12),
          GetBuilder<AddressListController>(
            builder: (controller) {
              if (!controller.isLoading) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                        color: gradient.defoultColor),
                  ),
                );
              }

              if (controller.addressListModel?.addressList?.isEmpty ?? true) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.location_off,
                          size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        "No addresses saved yet".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          color: greycolor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: controller.addressListModel!.addressList!.map((addr) {
                  final isSelected = selectedAddressId == addr.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAddressId = addr.id;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? gradient.defoultColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? gradient.defoultColor.withOpacity(0.05)
                            : WhiteColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? gradient.defoultColor
                                : Colors.grey,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addr.addressAs ?? "Address",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: BlackColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    addr.houseNo,
                                    addr.landmark,
                                    addr.address
                                  ]
                                      .where((e) =>
                                          e != null && e.isNotEmpty)
                                      .join(", "),
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyMedium,
                                    fontSize: 12,
                                    color: greycolor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final tax = subtotal * 0.05;
    final total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary".tr,
            style: TextStyle(
              fontSize: 18,
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow("Subtotal ($totalItemCount ${"items".tr})",
              "$currency${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _summaryRow("Tax (5%)", "$currency${tax.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _summaryRow("Shipping Fee".tr, "FREE",
              valueColor: Colors.green),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Payable".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: FontFamily.gilroyBold,
                  color: BlackColor,
                ),
              ),
              Text(
                "$currency${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: FontFamily.gilroyBold,
                  color: gradient.defoultColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: FontFamily.gilroyMedium,
            color: greycolor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: FontFamily.gilroyBold,
            color: valueColor ?? BlackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Payment Method".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.gilroyBold,
                  color: BlackColor,
                ),
              ),
              const Spacer(),
              GetBuilder<PaymentDetailController>(
                builder: (controller) {
                  if (controller.isLoading && controller.paymentDetailModel != null) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(strokeWidth: 2, color: gradient.defoultColor),
                  );
                }
              )
            ],
          ),
          const SizedBox(height: 12),
          GetBuilder<PaymentDetailController>(
            builder: (controller) {
              if (!controller.isLoading || controller.paymentDetailModel == null) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.money, color: Colors.green),
                      const SizedBox(width: 12),
                      Text("Cash".tr, style: TextStyle(fontFamily: FontFamily.gilroyMedium)),
                      const Spacer(),
                      Icon(Icons.radio_button_checked, color: gradient.defoultColor),
                    ],
                  ),
                );
              }

              return Column(
                children: controller.paymentDetailModel!.paymentList.map((payment) {
                  final isSelected = paymentSelect == payment.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentSelect = payment.id;
                        paymenttital = payment.name;
                        razorpaykey = payment.attribute;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? gradient.defoultColor : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? gradient.defoultColor.withOpacity(0.05) : WhiteColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: NetworkImage("${Config.imageBaseurlDoctor}${payment.image}"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment.name.tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: BlackColor,
                                  ),
                                ),
                                if (payment.subTitle.isNotEmpty)
                                  Text(
                                    payment.subTitle.tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 11,
                                      color: greycolor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? gradient.defoultColor : Colors.grey,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    final tax = subtotal * 0.05;
    final total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$currency${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontFamily.gilroyBold,
                      color: BlackColor,
                    ),
                  ),
                  Text(
                    "Including all taxes".tr,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.gilroyMedium,
                      color: greycolor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradient.defoultColor,
                  foregroundColor: WhiteColor,
                  disabledBackgroundColor:
                      gradient.defoultColor.withOpacity(0.6),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isPlacingOrder
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Place Order".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
