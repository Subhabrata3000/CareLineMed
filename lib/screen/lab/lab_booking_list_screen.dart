// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/controller/lab_booking_list_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/lab/lab_package_complete_list.dart';
import 'package:carelinemed/screen/lab/lab_package_pending_list.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class LabBookingListScreen extends StatefulWidget {
  const LabBookingListScreen({super.key});

  @override
  State<LabBookingListScreen> createState() => _LabBookingListScreenState();
}

class _LabBookingListScreenState extends State<LabBookingListScreen> with SingleTickerProviderStateMixin{

  LabBookingListController labBookingListController = Get.put(LabBookingListController());
  TabController? tabController;

  @override
  void initState() {
    labBookingListController.isLoading = true;
    tabController = TabController(length: 2, vsync: this);
    labBookingListController.labBookingListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: WhiteColor,
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Booking Package".tr,
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: bgcolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                  child: TabBar(
                    controller: tabController,
                    unselectedLabelColor: greyColor,
                    labelStyle: const TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: WhiteColor,
                    ),
                    labelColor: gradient.defoultColor,
                    physics: BouncingScrollPhysics(),
                    tabs: [
                      Tab(text: "Pending".tr),
                      Tab(text: "Complete".tr),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: GetBuilder<LabBookingListController>(
                builder: (labBookingListController) {
                  return labBookingListController.isLoading
                  ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
                  : TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: tabController,
                    children: [
                      LabPackagePendingList(),
                      LabPackageCompleteList(),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

}
