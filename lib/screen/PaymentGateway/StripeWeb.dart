// ignore_for_file: deprecated_member_use, file_names, prefer_typing_uninitialized_variables, prefer_const_constructors, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/font_family_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../yourcart_screen.dart';

class StripePaymentWeb extends StatefulWidget {
  final String initialUrl;
  final FutureOr<NavigationDecision> Function(NavigationRequest request) navigationDelegate;
  const StripePaymentWeb({super.key, required this.initialUrl, required this.navigationDelegate});

  @override
  State<StripePaymentWeb> createState() => _StripePaymentWebState();
}

class _StripePaymentWebState extends State<StripePaymentWeb> {
  late WebViewController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var progress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return WillPopScope(
        onWillPop: (() async => true),
        child: Scaffold(
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
                icon: const Icon(Icons.arrow_back,color: Colors.white),
                onPressed: () => Get.to(YourCartScreen(doctorId: "",subDepartmentId: "",hospitalId: "",serviceType: "",time: "",date: "",price: 0,departmentId: "",day: "",))),
            elevation: 0.0),
        body: Center(
          child: CircularProgressIndicator(
            color: gradient.defoultColor,
          ),
        ),
      );
    }
  }


  jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

}

