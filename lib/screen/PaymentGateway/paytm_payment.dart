
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/font_family_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controller_doctor/add_order_controller.dart';

class PayTmPayment extends StatefulWidget {
  final String? uid;
  final String? totalAmount;

  const PayTmPayment({this.uid, this.totalAmount});

  @override
  State<PayTmPayment> createState() => _PayTmPaymentState();
}

class _PayTmPaymentState extends State<PayTmPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController controller;
  var progress;
  String? accessToken;
  String? payerID;
  bool isLoading = true;

  AddOrderController addOrderController = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return WillPopScope(
        onWillPop: () {
          addOrderController.setOrderLoadingOff();
          return Future.value(true);
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: CircularProgressIndicator(
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            SizedBox(
                              width: Get.width * 0.80,
                              child: Text(
                                'Please don`t press back until the transaction is complete'
                                    .tr,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(),
              ],
            ),
          ),
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          elevation: 0.0,
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(
              color: gradient.defoultColor,
            ),
          ),
        ),
      );
    }
  }
}
