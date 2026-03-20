// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:ui' as ui;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/lab_booking_details_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/full_screen_image.dart';
import 'package:laundry/screen/lab/packge_detail_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/utils/customwidget.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LabBookingDetailsScreen extends StatefulWidget {
  const LabBookingDetailsScreen({super.key, required this.labBookId});
  final String labBookId;

  @override
  State<LabBookingDetailsScreen> createState() => _LabBookingDetailsScreenState();
}

class _LabBookingDetailsScreenState extends State<LabBookingDetailsScreen> {
  LabBookingDetailsController labBookingDetailsController = Get.put(LabBookingDetailsController());
  var currency = "";

  static const platform = MethodChannel('com.example.myapp/scan');
  
  @override
  void initState() {
    labBookingDetailsController.isLoading = true;
    currency = getData.read("currency");
    setState(() {});
    labBookingDetailsController.labBookingDetailsApi(labBookId: widget.labBookId);
    super.initState();
  }

  @override
  void dispose() {
    labBookingDetailsController.packageTotal.clear();
    super.dispose();
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  final Map<int, GlobalKey> _globalKey = {};

  Future<void> saveLocalImage(int index) async {
    final key = _globalKey[index];
    if (key == null || key.currentContext == null) {
      debugPrint("Error: GlobalKey is null or context is null for index $index");
      showToastMessage("Error: Unable to capture image".tr);
      return;
    }
    RenderRepaintBoundary? boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      debugPrint("Error: boundary is null");
      showToastMessage("Error: Unable to capture image".tr);
      return;
    }
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      await ImageGallerySaverPlus.saveImage(byteData.buffer.asUint8List());
      showToastMessage("Image saved in gallery".tr);
    } else {
      showToastMessage("Error: Failed to save image".tr);
    }
  }



Future<void> downloadPDF({required String url, required String fileName, bool? isOpen}) async {
  try {
    if (!await requestStoragePermission()) {
      debugPrint("❌ Error: Storage permission denied");
      return;
    }

    Directory? baseDir;
    if (Platform.isAndroid) {
      baseDir = Directory('/storage/emulated/0/Download/Meet Doctor');
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

    // ✅ Ensure unique file name
    String nameWithoutExt = fileName.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
    String finalFileName = '$nameWithoutExt.pdf';
    int count = 1;

    String fullPath = '${baseDir.path}/$finalFileName';
    while (File(fullPath).existsSync()) {
      finalFileName = '$nameWithoutExt($count).pdf';
      fullPath = '${baseDir.path}/$finalFileName';
      count++;
    }

    final Dio dio = Dio();
    await dio.download(url, fullPath);
    debugPrint("✅ PDF Downloaded to: $fullPath");

    try {
      await platform.invokeMethod('scanFile', {'path': fullPath});
    } catch (e) {
      debugPrint("❌ Error scanning file: $e");
    }
    if (isOpen == true) {
      await OpenFilex.open(fullPath);
    }
    showToastMessage("File Downloaded");
  } catch (e) {
    debugPrint("❌ Error downloading PDF: $e");
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        iconTheme: IconThemeData(color: BlackColor),
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Your Service".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
        actions: [
          GetBuilder<LabBookingDetailsController>(
            builder: (labBookingDetailsController) {
              return labBookingDetailsController.isLoading
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          checkOutStatusBottomSheet();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: primeryColor,width: 2),
                            borderRadius: BorderRadius.circular(60)
                          ),
                          child: Text(
                            "Check Status".tr,
                            style: TextStyle(
                              color: primeryColor,
                              fontFamily: FontFamily.gilroyBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
            }
          ),
        ],
      ),
      body: GetBuilder<LabBookingDetailsController>(
        builder: (labBookingDetailsController) {
          return labBookingDetailsController.isLoading
            ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Lab details".tr,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          "${"Appointment Id".tr} : ${labBookingDetailsController.labBookingDetailsModel!.appoint!.id}",
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 14,
                            color: primeryColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: Get.height / 8,
                                width: Get.height / 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: greyColor,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: FadeInImage.assetNetwork(
                                    height: Get.height / 8,
                                    width: Get.height / 8,
                                    fit: BoxFit.cover,
                                    placeholder: "assets/ezgif.com-crop.gif",
                                    placeholderFit: BoxFit.cover,
                                    placeholderCacheWidth: 60,
                                    placeholderCacheHeight: 60,
                                    image: "${Config.imageBaseurlDoctor}${labBookingDetailsController.labBookingDetailsModel!.lab!.logo}",
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${labBookingDetailsController.labBookingDetailsModel!.lab!.name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${labBookingDetailsController.labBookingDetailsModel!.lab!.address}",
                                      style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: FontFamily.gilroyMedium,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/star.svg",
                                          color: yelloColor,
                                        ),
                                        SizedBox(width: 5),
                                        RichText(
                                          text: TextSpan(
                                            text: "${labBookingDetailsController.labBookingDetailsModel!.lab!.totReview}",
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontSize: 16,
                                              fontFamily: FontFamily.gilroyBlack,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " (${labBookingDetailsController.labBookingDetailsModel!.lab!.avgStar}+ ${"Ratings".tr})",
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
                    SizedBox(height: 10),
                    Text(
                      "Test Details & Package Details".tr,
                      style: TextStyle(
                        color: BlackColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    ListView.separated(
                      itemCount: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: Get.height / 20,
                                    width: Get.height / 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: greyColor,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        height: Get.height / 20,
                                        width: Get.height / 20,
                                        fit: BoxFit.cover,
                                        placeholder: "assets/ezgif.com-crop.gif",
                                        placeholderFit: BoxFit.cover,
                                        placeholderCacheWidth: 60,
                                        placeholderCacheHeight: 60,
                                        image:  "${Config.imageBaseurlDoctor}${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].logo}",
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].title}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {packageInfoBottomsheet(bindex: index);},
                                              child: Image.asset(
                                                "assets/info-circle.png",
                                                height: 20,
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].subtitle}",
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: FontFamily.gilroyMedium,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${"Includes".tr} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].totPackageName} ${"tests".tr}",
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
                                                    fontSize: 15,
                                                    fontFamily: FontFamily.gilroyBold,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: "$currency ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].totPackagePrice} X ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f!.length}",
                                                      style: TextStyle(
                                                        color: greycolor,
                                                        fontSize: 15,
                                                        fontFamily: FontFamily.gilroyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "$currency ${labBookingDetailsController.packageTotal[index]}",
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontSize: 16,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(left: Get.width / 10),
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for(int i = 0; i < labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f!.length; i++)...[
                                            Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 73,
                                                        width: 73,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].c!.isNotEmpty
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
                                                            image: "${Config.imageBaseurlDoctor}${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].fmember!.profileImage}",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].c!.isNotEmpty
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
                                                    "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].fmember!.name}",
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.gilroyBold,
                                                      fontSize: 16,
                                                      color: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].c!.isNotEmpty
                                                        ? gradient.defoultColor
                                                        : textcolor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      if (labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].c!.isNotEmpty) {
                                                        downloadPrescription(bindex1: index, bindex2: i);
                                                      } else {
                                                        Fluttertoast.showToast(msg: "No lab report uploaded yet. You’ll be notified once it's available.".tr);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      decoration: BoxDecoration(
                                                        color: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f![i].c!.isEmpty
                                                          ? greycolor
                                                          : primeryColor,
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: Text(
                                                        "View Report".tr,
                                                        style: TextStyle(
                                                          color: WhiteColor,
                                                          fontFamily: FontFamily.gilroyBold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(i != labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![index].f!.length - 1)...[Container(width: 10)],
                                          ],
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Otp Info".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "OTP : ",
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      Text(
                                        "${labBookingDetailsController.labBookingDetailsModel!.appoint!.otp}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: primeryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Text(
                              "QR Code".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(child: Image.memory(labBookingDetailsController.bytes)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Date & Time Info".tr,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          billSummaryTextDetaile(title: "Booking".tr, subtitle: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.date}"),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Appointment Date & Time Info".tr,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          billSummaryTextDetaile(title: "Appointment".tr, subtitle: DateFormat("EEE, MMM d, yyyy, hh:mm a").format(DateFormat("dd-MM-yyyy h:mm a").parse("${labBookingDetailsController.labBookingDetailsModel!.appoint!.bookDate} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.bookTime}"))),
                        ],
                      ),
                    ),
                    if("${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCUser}" != "")...[
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home Collect Person".tr,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  billSummaryTextDetaile(title: "Name".tr, subtitle: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCUser}"),
                                  SizedBox(height: 8),
                                  billSummaryTextDetaile(title: "Email".tr, subtitle: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCEmail}"),
                                  SizedBox(height: 8),
                                  billSummaryTextDetaile(title: "Mobile".tr, subtitle: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCCcode} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCPhone}"),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makingPhoneCall(context, number: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeCPhone}");
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: WhiteColor,
                                  border: Border.all(
                                    color: gradient.defoultColor.withOpacity(0.4),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/Call.svg",
                                    color: gradient.defoultColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (labBookingDetailsController.labBookingDetailsModel!.appoint!.otp != "")...[
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Otp Info".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${"OTP".tr} :",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${labBookingDetailsController.labBookingDetailsModel!.appoint!.otp}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: primeryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "QR Code".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily:FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(child: Image.memory(labBookingDetailsController.bytes)),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 10),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bill Summary".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 10),
                            billSummaryTextDetaile(title: "Package Charge".tr, subtitle: "${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.totPackagePrice}"),
                            if (labBookingDetailsController.labBookingDetailsModel!.appoint!.homeExtraPrice != 0)...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(title: "Home Collection Fee".tr, subtitle: "${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.homeExtraPrice}"),
                            ],
                            if(labBookingDetailsController.labBookingDetailsModel!.appoint!.siteCommission != 0)...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(title: "Service Fee & Tax".tr, subtitle: "${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.siteCommission}"),
                            ],
                            if (labBookingDetailsController.labBookingDetailsModel!.appoint!.walletAmount != 0)...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(
                                title: "Wallet Amount".tr,
                                subtitle: "${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.walletAmount}",
                              ),
                            ],
                            if(labBookingDetailsController.labBookingDetailsModel!.appoint!.onlineAmount != 0 || labBookingDetailsController.labBookingDetailsModel!.appoint!.cashAmount != 0)...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(
                                title: "Payment".tr,
                                subtitle: "(${labBookingDetailsController.labBookingDetailsModel!.appoint!.paymentName}) : ${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.onlineAmount == 0 ? labBookingDetailsController.labBookingDetailsModel!.appoint!.cashAmount :labBookingDetailsController.labBookingDetailsModel!.appoint!.onlineAmount}",
                              ),
                            ],
                            if (labBookingDetailsController.labBookingDetailsModel!.appoint!. couponAmount != 0)...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(title: "Coupon Amount".tr, subtitle: "${getData.read("currency")} -${labBookingDetailsController.labBookingDetailsModel!.appoint!.couponAmount}"),
                            ],
                            SizedBox(height: 5),
                            billSummaryTextDetaile(title: "Total Price".tr, subtitle: "${getData.read("currency")} ${labBookingDetailsController.labBookingDetailsModel!.appoint!.totPrice}"),
                            if (labBookingDetailsController.labBookingDetailsModel!.appoint!.transactionId! != "")...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(title: "Transaction Id".tr, subtitle: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.transactionId}"),
                            ],
                            if(labBookingDetailsController.labBookingDetailsModel!.appoint!.message != "")...[
                              SizedBox(height: 5),
                              billSummaryTextDetaile(
                                title: "Additional Note".tr,
                                subtitle: labBookingDetailsController.labBookingDetailsModel!.appoint!.message ?? "",
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
        }
      ),
    );
  }

  packageInfoBottomsheet ({required int bindex}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: WhiteColor,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:  EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Test Details & Package Details".tr,
                style: TextStyle(
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: DottedLine(dashColor: greyColor),
              ),
              details(image: "assets/bottomIcons/Home.svg", title: "Home Collect Extra Price".tr, text: "$currency ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].homeExtraPrice}", fontFamily: FontFamily.gilroyMedium),
              details(image: "assets/bottomIcons/test_tube.svg", title: "Sample Type".tr, text: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].sampleType!.join(", "), fontFamily: FontFamily.gilroyMedium),
              details(image: "assets/restaurant.svg", title: "Fasting Required".tr, text: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].fastingRequire}", fontFamily: FontFamily.gilroyMedium),
              details(image: "assets/clock-circle.svg", title: "Test Report Time".tr, text: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].testReportTime}", fontFamily: FontFamily.gilroyMedium),
              SizedBox(height: 10),
              Row(
                children: [
                  Image.asset(
                    "assets/note-text.png",
                    color: BlackColor,
                    height: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Package Description".tr,
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].description}",
                  style: TextStyle(
                    color: greycolor,
                    fontFamily: FontFamily.gilroyRegular,
                  ),
                ),
              ), 
              SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/package-box.svg",
                    color: textcolor,
                    height: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Package Includes".tr,
                    style: TextStyle(
                      color: textcolor,
                      fontFamily: FontFamily.gilroyMedium,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "$currency ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].totPackagePrice}",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyBold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for(int i = 0; i < labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packageName!.length; i++)...[
                      i < 3
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Container(
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: BlackColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packageName![i],
                                style: TextStyle(
                                  color: greycolor,
                                  fontFamily: FontFamily.gilroyRegular,
                                ),
                              ),
                              Spacer(), 
                              Text(
                                "$currency ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packagePrice![i]}",
                                style: TextStyle(
                                  color: greycolor,
                                  fontFamily: FontFamily.gilroyRegular,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                    ],
                    labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packageName!.length < 3
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          Get.back();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: WhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/package-box.svg",
                                          color: BlackColor,
                                          height: 25,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Package Includes".tr,
                                          style: TextStyle(
                                            color: BlackColor,
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ListView.separated(
                                          padding: EdgeInsets.only(left: 15),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packageName!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, pIndex) {
                                            return Row(
                                              children: [
                                                Container(
                                                  height: 5,
                                                  width: 5,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: gradient.defoultColor,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packageName![pIndex],
                                                  style: TextStyle(
                                                    color: greycolor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                                Spacer(), 
                                                Text(
                                                  "$currency ${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex].packagePrice![pIndex]}",
                                                  style: TextStyle(
                                                    color: greycolor,
                                                    fontFamily: FontFamily.gilroyMedium,
                                                  ),
                                                ), 
                                              ],
                                            );
                                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          "Show More".tr,
                          style: TextStyle(
                            color: gradient.defoultColor,
                            fontSize: 16,
                            fontFamily: FontFamily.gilroyBold,
                          ),
                        ),
                      ),
                  ],
                )
              ),
            ],
          ),
        );
      },
    );
  }

  downloadPrescription ({required int bindex1, required int bindex2}) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: WhiteColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: Get.height / 1.2),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Reports".tr,
                style: TextStyle(
                  color: textcolor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 18,
                ),
              ),
              Divider(color: greycolor.withOpacity(0.3)),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primeryColor,
                      ),
                    ),
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/ezgif.com-crop.gif",
                        placeholderCacheWidth: 50,
                        placeholderCacheHeight: 50,
                        height: 50,
                        width: 50,
                        image: "${Config.imageBaseurlDoctor}${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].fmember!.profileImage}",
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
                          "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].fmember!.name}",
                          style: TextStyle(
                            color: textcolor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].d}",
                          style: TextStyle(
                            color: greycolor,
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                itemCount: labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r!.length,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: primeryColor,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: bgcolor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  labBookingDetailsController.getFileIcon(labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index]),
                                  color: primeryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Lab report",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: primeryColor,
                                    fontFamily: FontFamily.gilroyRegular,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  labBookingDetailsController.isPdf(labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index])
                                    ? downloadPDF(
                                        url: Config.imageBaseurlDoctor + labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index],
                                        fileName: 'report_document_${index + 1}.pdf',
                                        isOpen: true,
                                      )
                                    : Get.to(FullScreenImage(imageUrl: Config.imageBaseurlDoctor + labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index], tag: "image",));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: gradient.defoultColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    color: WhiteColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                              if(labBookingDetailsController.isPdf(labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index]))...[
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    labBookingDetailsController.isPdf(labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index])
                                      ? downloadPDF(
                                          url: Config.imageBaseurlDoctor + labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].r![index],
                                          fileName: 'report_document_${index + 1}.pdf',
                                          isOpen: true,
                                        )
                                      : saveLocalImage(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: gradient.defoultColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.file_download_outlined,
                                      color: WhiteColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                           ],
                          ),
                        ),
                      ),
                    ],
                  );
                }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "${"Comments".tr} : ",
                  style: TextStyle(
                    color: greycolor,
                    fontSize: 17,
                    fontFamily: FontFamily.gilroyBold,
                  ),
                  children: [
                    TextSpan(
                      text: "${labBookingDetailsController.labBookingDetailsModel!.appoint!.packageId![bindex1].f![bindex2].c}",
                      style: TextStyle(
                        color: Greycolor,
                        fontSize: 15,
                        fontFamily: FontFamily.gilroyRegular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  checkOutStatusBottomSheet () {
    return showModalBottomSheet(
      context: context,
      backgroundColor: WhiteColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "Order Status".tr,
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 18,
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: labBookingDetailsController.statusoresrList.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final showTopLine = index != 0;
                        final showBottomLine = index != labBookingDetailsController.statusoresrList.length - 1;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                labBookingDetailsController.statusoresrList[index].timestamp,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: greyColor,
                                  fontFamily: FontFamily.gilroyRegular,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Timeline section
                            SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  if (!showTopLine)
                                    AnimatedContainer(
                                      duration: Duration(seconds: 2),
                                      height: 30,
                                    ),
                                  if (showTopLine)
                                    AnimatedContainer(
                                      duration: Duration(seconds: 2),
                                      height: 30,
                                      width: 1,
                                      color: greycolor.withOpacity(0.3),
                                    ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: labBookingDetailsController.statusoresrList[index].isCompleted == true ? gradient.defoultColor : greyColor,
                                      ),
                                      color: labBookingDetailsController.statusoresrList[index].isCompleted == true ? gradient.defoultColor : Colors.transparent,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 15,
                                          color: WhiteColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Bottom line: animate only if the current step is reached or passed
                                  if (showBottomLine)
                                    AnimatedContainer(
                                      duration: Duration(seconds: 2),
                                      height: 30,
                                      width: 1,
                                      color: greycolor.withOpacity(0.3),
                                    ),
                                  if (!showBottomLine)
                                    AnimatedContainer(
                                      duration: Duration(seconds: 2),
                                      height: 30,
                                    ),
                                  
                                ],
                              ),
                            ),
                            // Step text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    labBookingDetailsController.statusoresrList[index].title,
                                    style: TextStyle(
                                      color: textcolor,
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    labBookingDetailsController.statusoresrList[index].subtitle,
                                    style: TextStyle(
                                      color: greyColor,
                                      fontFamily: FontFamily.gilroyRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
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
}