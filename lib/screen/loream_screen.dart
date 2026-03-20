// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';

class Loream extends StatefulWidget {
  Loream({super.key});
  @override
  State<Loream> createState() => _LoreamState();
}

class _LoreamState extends State<Loream> {
  String title = Get.arguments["title"];
  String discription = Get.arguments["discription"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'Gilroy Medium',
            color: BlackColor,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    (discription != null && discription.isNotEmpty)
                      ? HtmlWidget(
                          discription,
                          textStyle: TextStyle(
                              color: BlackColor,
                              fontSize: 15,
                              fontFamily: FontFamily.gilroyMedium,
                            ),
                        )
                      : Text(""),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
