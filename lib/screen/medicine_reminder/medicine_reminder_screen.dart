// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/medicine_reminder_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/medicine_reminder/add_medicine_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({super.key});

  @override
  State<MedicineReminderScreen> createState() => _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  MedicineReminderController medicineReminderController = Get.put(MedicineReminderController());

  @override
  void initState() {
    medicineReminderController.medicineReminderListApi();
    super.initState();
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
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: BackButton(
          color: WhiteColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: GetBuilder<MedicineReminderController>(
          builder: (medicineReminderController) {
            return Text(
              medicineReminderController.isLoding
                ? ""
                : medicineReminderController.medicineReminderListModel!.remiderList!.isEmpty ? "Drugs time".tr : "Drugs Reminder".tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: FontFamily.gilroyBold,
              ),
            );
          }
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(AddMedicineScreen())!.then((value) {
                setState(() {});
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(color: WhiteColor),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: WhiteColor,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<MedicineReminderController>(
          builder: (medicineReminderController) {
        return medicineReminderController.isLoding
            ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
            : medicineReminderController.medicineReminderListModel!.remiderList!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No drugs schedule".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          width: Get.width / 1.2,
                          child: Text(
                            "You can create a calendar to remind yourself the process of taking drugs.".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyMedium,
                              color: greytext,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: medicineReminderController.medicineReminderListModel!.remiderList!.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                AddMedicineScreen(
                                  reminderId: "${medicineReminderController.medicineReminderListModel!.remiderList![index].id}",
                                  medicineName: "${medicineReminderController.medicineReminderListModel!.remiderList![index].medicineName}",
                                  status: "${medicineReminderController.medicineReminderListModel!.remiderList![index].status}",
                                  timedata: medicineReminderController.medicineReminderListModel!.remiderList![index].time,
                                ),
                              )!.then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: greycolor.withOpacity(0.5)),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${medicineReminderController.medicineReminderListModel!.remiderList![index].medicineName}",
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 0.9,
                                            child: CupertinoSwitch(
                                              activeTrackColor: gradient.defoultColor,
                                              value: medicineReminderController.medicineReminderListModel!.remiderList![index].status == "1" ? true : false,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      for(int t = 0; t < medicineReminderController.medicineReminderListModel!.remiderList![index].time!.length; t++)...[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            for(int i = 1; i <= 2; i++)
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  i == 1 ? "assets/bottomIcons/medicine_fill.svg" : "assets/clock-circle-filled.svg",
                                                  color: i == 1 ? green1Color : gradient.defoultColor,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  i == 1 
                                                    ? "${medicineReminderController.medicineReminderListModel!.remiderList![index].time![t]["title"]}" 
                                                    : "${medicineReminderController.medicineReminderListModel!.remiderList![index].time![t]["time"]}",
                                                  textAlign: i == 1 ? TextAlign.start : TextAlign.end,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        medicineReminderController.medicineReminderListModel!.remiderList![index].time!.length - 1 != t
                                        ? SizedBox(height: 10)
                                        : SizedBox(),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -5,
                            top: -15,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  // barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      titlePadding: EdgeInsets.only(top: 15, left: 15, right: 15),
                                      contentPadding: EdgeInsets.only(bottom: 0, left: 15, right: 15),
                                      actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      title: Text(
                                        "Remove Dose".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          color: textcolor,
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to Remove Dose?".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyRegular,
                                          color: greycolor,
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
                                                "Cancel".tr,
                                                style: TextStyle(
                                                  color: gradient.defoultColor,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            medicineReminderController.deleteMedicinceReminderApi(
                                              id: "${getData.read("UserLogin")["id"]}",
                                              reminderId: "${medicineReminderController.medicineReminderListModel!.remiderList![index].id}",
                                            );
                                            Get.back();
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
                                                  fontFamily: FontFamily.gilroyMedium,
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
                                  color: RedColor,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  "assets/trash.svg",
                                  color: WhiteColor,
                                  height: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
                  );
        },
      ),
    );
  }
}
