// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/screen/my%20booking/vital_list_screen.dart';
import 'package:carelinemed/utils/customwidget.dart';
import 'package:carelinemed/widget/custom_title.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Api/data_store.dart';
import '../../controller/send_notification_controller.dart';
import '../../controller_doctor/add_review_controller.dart';
import 'package:path_provider/path_provider.dart';
import '../../controller_doctor/appointment_detail_controller.dart';
import '../../controller_doctor/cancel_order_controller.dart';
import '../../controller_doctor/patient_health_controller.dart';
import '../../controller_doctor/pdf_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import '../../widget/button.dart';
import '../chat/message.dart';
import 'diagnosis_list.dart';
import 'medicine_list_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final String appointmentId;
  const BookingDetailScreen({super.key, required this.appointmentId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  AppointmentDetailDoctorController apointmentDetailDoctorController = Get.put(AppointmentDetailDoctorController());
  PatientHealthController patientHealthController = Get.put(PatientHealthController());
  CancelBookController cancelOrderController = Get.put(CancelBookController());
  AddReviewController addReviewController = Get.put(AddReviewController());
  PdfController pdfController = Get.put(PdfController());

  @override
  void initState() {
    cancelOrderController.cancelOrderListApi();
    apointmentDetailDoctorController.appointmentDoctorApi(appointmentId: widget.appointmentId.toString()).then(
      (value) {
        var data = jsonDecode(value);
        if (data["Result"] == true) {
          setState(() {
            currentMarker(
              image: Config.imageBaseurlDoctor + apointmentDetailDoctorController.appointmentDetailModel!.doctor!.logo!,
              lat: apointmentDetailDoctorController.appointmentDetailModel!.hospital!.latitude.toString(),
              long: apointmentDetailDoctorController.appointmentDetailModel!.hospital!.longitude.toString(),
            );
          });
        } else {}
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    apointmentDetailDoctorController.isLoading = false;
    pdfController.isLoading = false;
  }

  Future<void> _makingPhoneCall({required String number}) async {
    await Permission.phone.request();
    var status = await Permission.phone.status;

    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      var url = Uri.parse('tel:$number');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(msg: "Please allow calls Permission".tr);
      await openAppSettings();
    } else {
      Fluttertoast.showToast(msg: "Please allow calls Permission".tr);
      await openAppSettings();
    }
  }

  get picker => ImagePicker();
  GoogleMapController? controller;
  Map<MarkerId, Marker> markers11 = {};

  Future<void> currentMarker({
    required String lat,
    required String long,
    required String image,
  }) async {
    String pinAssetPath = "assets/Location.png";
    final Uint8List markIcon = await createPinMarker(image, pinAssetPath, WhiteColor);

    markers11[MarkerId("origin")] = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(double.parse(lat.toString()), double.parse(long.toString())),
      icon: BitmapDescriptor.fromBytes(markIcon),
    );

    debugPrint("<><><> lat  <><><>${lat.toString()}");
    debugPrint("<><><> long <><><>${long.toString()}");

    setState(() {});
  }

  Future<Uint8List> createPinMarker(String profileUrl, String pinAssetPath, Color pinColor) async {
    // Load the pin background from assets
    final ByteData pinData = await rootBundle.load(pinAssetPath);
    final Uint8List pinBytes = pinData.buffer.asUint8List();
    ui.Codec pinCodec = await ui.instantiateImageCodec(pinBytes, targetWidth: 130);
    ui.FrameInfo pinFrameInfo = await pinCodec.getNextFrame();
    ui.Image pinImage = pinFrameInfo.image;

    // Change the color of the pin
    ui.Image coloredPin = await recolorImage(pinImage, pinColor);

    // Load the profile image from the network
    final http.Response response = await http.get(Uri.parse(profileUrl));
    if (response.statusCode != 200)
      throw Exception("Failed to load profile image".tr);

    Uint8List profileData = response.bodyBytes;
    ui.Codec profileCodec = await ui.instantiateImageCodec(profileData, targetWidth: 80);
    ui.FrameInfo profileFrameInfo = await profileCodec.getNextFrame();
    ui.Image profileImage = profileFrameInfo.image;

    // Create canvas to draw the final marker
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..isAntiAlias = true;

    // Draw the colored pin background
    canvas.drawImage(coloredPin, Offset(0, 0), paint);

    // Draw the profile image inside a circular clip
    double profileSize = 80;
    double profileOffsetX = (coloredPin.width - profileSize) / 2;
    double profileOffsetY = 20; // Adjust this to position the profile inside the pin

    Path clipPath = Path()..addOval(Rect.fromLTWH(profileOffsetX, profileOffsetY, profileSize, profileSize));

    canvas.clipPath(clipPath);
    canvas.drawImage(profileImage, Offset(profileOffsetX, profileOffsetY), paint);

    // Finalize image
    final ui.Picture picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(coloredPin.width, coloredPin.height);

    ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> recolorImage(ui.Image image, Color newColor) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..colorFilter = ColorFilter.mode(newColor, BlendMode.srcATop);
    canvas.drawImage(image, Offset(0, 0), paint);

    final ui.Picture picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }

  var radio;
  int selectedPatientId = 0;

  SendNotificationController sendNotificationController = Get.put(SendNotificationController());

  bool isDownload = false;

  Future<void> downloadPDF(String url, String fileName) async {
    isDownload = true;
    setState(() {});
    try {
      if (!await requestStoragePermission()) {
        debugPrint("❌ Error: Storage permission denied");
        return;
      }

      Dio dio = Dio();
      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download/Meet Doctor');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      String filePath = "${directory.path}/$fileName";
      await dio.download(url, filePath);
      debugPrint("✅ PDF Downloaded to: $filePath");

      // ✅ Open the file using open_filex
      OpenFilex.open(filePath);
      showToastMessage("File Downloaded".tr);
      isDownload = false;
      setState(() {});
    } catch (e) {
      debugPrint("❌ Error downloading PDF: $e");
    }
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: BackButton(
            color: WhiteColor,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text(
          "Appointment Detail".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: FontFamily.gilroyExtraBold,
          ),
        ),
      ),
      body: GetBuilder<AppointmentDetailDoctorController>(
        builder: (context) {
          return apointmentDetailDoctorController.isLoading
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      image: "${Config.imageBaseurlDoctor}${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.logo}",
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.name}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: FontFamily.gilroyExtraBold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${apointmentDetailDoctorController.appointmentDetailModel!.sebservice!.departmentName} • ${apointmentDetailDoctorController.appointmentDetailModel!.sebservice!.subTitle}",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontFamily: FontFamily.gilroyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
                            SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for(int i = 0; i < apointmentDetailDoctorController.communicationIcon.length; i++)...[
                                  GestureDetector(
                                    onTap: () {
                                      if(i == 0){
                                        _makingPhoneCall(number: "${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.countryCode}${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.phone}");
                                      } else if (i == 1) {
                                        Get.to(
                                          MessageScreen(
                                            userImage: "${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.logo}",
                                            username: "${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.name}",
                                            receiverId: "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.doctorId}",
                                            senderId: getData.read("UserLogin")["id"].toString(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            color: gradient.defoultColor.withOpacity(0.05),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: gradient.defoultColor.withOpacity(0.2)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: SvgPicture.asset(
                                              apointmentDetailDoctorController.communicationIcon[i],
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          apointmentDetailDoctorController.communicationText[i],
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appointment Details".tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: FontFamily.gilroyExtraBold,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Date".tr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: FontFamily.gilroyMedium)),
                                          SizedBox(height: 4),
                                          Text("${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.appointmentDate.toString().split(" ").first}", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: FontFamily.gilroyBold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Time".tr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: FontFamily.gilroyMedium)),
                                          SizedBox(height: 4),
                                          Text("${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.appointmentTime}", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: FontFamily.gilroyBold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Mode".tr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: FontFamily.gilroyMedium)),
                                          SizedBox(height: 4),
                                          Text(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.showType == "2" ? "Video".tr : "In-Person".tr, style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: FontFamily.gilroyBold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Amount".tr, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: FontFamily.gilroyMedium)),
                                          SizedBox(height: 4),
                                          Text("${getData.read("currency") ?? "₹"}${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.totPrice}", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: FontFamily.gilroyBold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Hospital".tr,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontFamily: FontFamily.gilroyMedium,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${apointmentDetailDoctorController.appointmentDetailModel!.hospital!.name}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              ),
                              apointmentDetailDoctorController.appointmentDetailModel!.appoint!.showType == "2"
                                  ? apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "4" || apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "5"
                                      ? SizedBox()
                                      : apointmentDetailDoctorController.remainingTime == 0
                                          ? Column(
                                              children: [
                                                SizedBox(height: 14),
                                                GetBuilder<SendNotificationController>(
                                                  builder: (sendNotificationController) {
                                                    return sendNotificationController.sendNotifiactionLoding
                                                    ? loaderButton()
                                                    : button(
                                                      text: "Send Notification".tr,
                                                      color: primeryColor,
                                                      onPress: () {
                                                        sendNotificationController.sendNotificationApi(context: context, doctorId: apointmentDetailDoctorController.appointmentDetailModel!.appoint!.doctorId.toString());
                                                      },
                                                    );
                                                  }
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                SizedBox(height: 14),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                    borderRadius: BorderRadius.circular(25),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${"Join video Call".tr} - ",
                                                          style: TextStyle(
                                                            color: Colors .black,
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.gilroyBold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${apointmentDetailDoctorController.formatTime(apointmentDetailDoctorController.remainingTime)} ",
                                                          style: TextStyle(
                                                            color: primeryColor,
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.gilroyBold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "left".tr,
                                                          style:  TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.gilroyBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "4" || apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "5"
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "1"
                                                        ? "Start OTP".tr
                                                        : "End OTP".tr} : ",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 13,
                                                      color: greytext,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.otp}",
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
                                        Center(child: Image.memory( apointmentDetailDoctorController.bytes)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "4" || apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "5"
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          "Patient Info".tr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: FontFamily.gilroyExtraBold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for(int i = 0; i < apointmentDetailDoctorController.appointmentDetailModel!.familyMember!.length; i++)...[
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          patientHealthController.diseaseController.text = "";
                                                          patientInfoDetail(
                                                            id: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].id.toString(),
                                                            image: Config.imageBaseurlDoctor + apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].profileImage!,
                                                            name: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].name!,
                                                            gender: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].gender!,
                                                            years: "${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].patientAge}",
                                                          ).then((value) {
                                                            setState(() {
                                                              patientHealthController.isLoading = false;
                                                            });
                                                          });
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(65),
                                                          child: FadeInImage.assetNetwork(
                                                            placeholder: "assets/ezgif.com-crop.gif",
                                                            placeholderCacheHeight: 80,
                                                            placeholderCacheWidth: 80,
                                                            placeholderFit: BoxFit.cover,
                                                            image: "${Config.imageBaseurlDoctor}${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].profileImage}",
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].name!,
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.gilroyBold,
                                                          color: greytext,
                                                          overflow: TextOverflow.ellipsis,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          patientHealthController.diseaseController.text = "";
                                                          patientInfoDetail(
                                                            id: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].id.toString(),
                                                            image: Config.imageBaseurlDoctor + apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].profileImage!,
                                                            name: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].name!,
                                                            gender: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].gender!,
                                                            years: "${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].patientAge}",
                                                          ).then((value) {
                                                            setState(() {
                                                              patientHealthController.isLoading = false;
                                                            });
                                                          });
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          color: primeryColor,
                                                          borderRadius: BorderRadius.circular(40),
                                                        ),
                                                        child: Text(
                                                          "Upload",
                                                          style: TextStyle(
                                                            color: WhiteColor,
                                                            fontFamily: FontFamily.gilroyBold,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if(i != apointmentDetailDoctorController.appointmentDetailModel!.familyMember!.length - 1)...[SizedBox(width: 10)],
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Appointment Checklists".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  for(int i = 0; i < apointmentDetailDoctorController.appointmentDetailModel!.familyMember!.length; i++)...[
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              apointmentDetailDoctorController.checkDoctorAppointmentUploadApi(
                                                appointmentId: "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.id}",
                                                fid: "${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].id}",
                                              );
                                              pdfController.isLoading = false;
                                              selectedPatientId = i;
                                              apointmentDetailDoctorController.patientID = apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].id.toString();
                                              pdfController.downloadPdf(appointmentId: widget.appointmentId.toString(), familyId: apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].id.toString());
                                            });
                                          },
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedPatientId == i ? primeryColor : Colors.grey.withOpacity(0.4),
                                                width: selectedPatientId == i ? 2 : 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(65),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: "assets/ezgif.com-crop.gif",
                                                placeholderCacheHeight: 80,
                                                placeholderCacheWidth: 80,
                                                placeholderFit: BoxFit.cover,
                                                image: "${Config.imageBaseurlDoctor}${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].profileImage}",
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            "${apointmentDetailDoctorController.appointmentDetailModel!.familyMember![i].name}",
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: selectedPatientId == i
                                                ? FontFamily.gilroyExtraBold
                                                : FontFamily.gilroyBold,
                                              color: selectedPatientId == i
                                                  ? primeryColor
                                                  : greycolor,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if(i != apointmentDetailDoctorController.appointmentDetailModel!.familyMember!.length - 1)...[SizedBox(width: 10)],
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: apointmentDetailDoctorController.appointmentChecklistsTitle.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {
                                          if(index == 0) {
                                            apointmentDetailDoctorController.vitalsPhysical == 0
                                              ? null
                                              : Get.to(
                                                  VitalScreen(
                                                    appointmentID: widget.appointmentId.toString(),
                                                    patientId: apointmentDetailDoctorController.patientID,
                                                  ),
                                                );
                                          } else if (index == 1) {
                                            apointmentDetailDoctorController.drugsPrescription == 0
                                              ? null
                                              : Get.to(MedicineListScreen(appointmentID: widget.appointmentId.toString(),patientId: apointmentDetailDoctorController.patientID));
                                          } else if (index == 2) {
                                            apointmentDetailDoctorController.diagnosisTest == 0
                                              ? null
                                              : Get.to(
                                                  DiagnosisScreen(
                                                    appointmentID: widget.appointmentId.toString(),
                                                    patientId: apointmentDetailDoctorController.patientID,
                                                  ),
                                                );
                                          }
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        visualDensity: VisualDensity.compact,
                                        leading: SvgPicture.asset(
                                          "assets/tick-circle.svg",
                                          color: index == 0
                                            ? (apointmentDetailDoctorController.vitalsPhysical != 0
                                                ? green1Color 
                                                : greyColor)
                                            : index == 1
                                              ? (apointmentDetailDoctorController.drugsPrescription != 0
                                                  ? green1Color
                                                  : greyColor)
                                              : apointmentDetailDoctorController.diagnosisTest != 0
                                                    ? green1Color
                                                    : greyColor,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text(
                                          "${apointmentDetailDoctorController.appointmentChecklistsTitle[index]}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontFamily: FontFamily.gilroyExtraBold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          "${apointmentDetailDoctorController.appointmentChecklistsSubTitle[index]}",
                                          style: TextStyle(
                                            color: greyColor,
                                            fontSize: 13,
                                            fontFamily: FontFamily.gilroyBold,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_circle_right_outlined,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            apointmentDetailDoctorController.checkDoctorAppointment 
                              ? loaderButton()
                              : (apointmentDetailDoctorController.drugsPrescription == 0 && apointmentDetailDoctorController.diagnosisTest == 0 && apointmentDetailDoctorController.vitalsPhysical == 0
                                  ? buttonGrey(
                                      text: "Download Prescription".tr,
                                      color: greycolor.withOpacity(0.2),
                                      onPress: () {
                                        Fluttertoast.showToast(msg: "Doctor hasn't uploaded your details. Please contact them to update your info.");
                                      },
                                    )
                                  : isDownload
                                      ? loaderButton()
                                      : button(
                                          text: "Download Prescription".tr,
                                          color: primeryColor,
                                          onPress: () {
                                            downloadPDF(Config.imageBaseurlDoctor + pdfController.pdfModel!.pdfUrl,'document_.pdf',);
                                          },
                                        ))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking Date & Time Info".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: FontFamily.gilroyExtraBold,
                              ),
                            ),
                            SizedBox(height: 10),
                            billSummaryTextDetaile(title: "Booking".tr, subtitle: "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.bookDate}"),
                          ],
                        ),
                      ),
                      if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.cancelTitle! != "" || apointmentDetailDoctorController.appointmentDetailModel!.appoint!.cancelReason! != "")...[
                        SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appointment Cancel".tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: FontFamily.gilroyExtraBold,
                                ),
                              ),
                              SizedBox(height: 10),
                              billSummaryTextDetaile(
                                title: "Cancel".tr,
                                subtitle: apointmentDetailDoctorController.appointmentDetailModel!.appoint!.cancelTitle != ""
                                  ?  "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.cancelTitle}"
                                  :  "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.cancelReason}",
                              ),
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
                              billSummaryTextDetaile(title: "Doctor Consultation Charge".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.showTypePrice}"),
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.additionalPrice != 0)...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Additional Price".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.additionalPrice}"),
                              ],
                              if(apointmentDetailDoctorController.serviceFeeTax != 0)...[
                                SizedBox(height: 5),
                                InkWell(
                                  key: buttonKey,
                                  onTap: () => toggleTooltip(),
                                  child: billSummaryTextDetaile(
                                    title: "Service Fee & Tax".tr,
                                    subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.serviceFeeTax}",
                                    image: "assets/info-circle.png",
                                  ),
                                ),
                              ],
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.walletAmount != 0)...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Wallet Amount".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.walletAmount}"),
                              ],
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.couponAmount != 0)...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Coupon Amount".tr, subtitle: "${getData.read("currency")} -${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.couponAmount}"),
                              ],
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.onlineAmount != 0)...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Payment".tr, subtitle: "(${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.paymentName}) ${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.onlineAmount}"),
                              ],
                              SizedBox(height: 5),
                              billSummaryTextDetaile(title: "Total Price".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.totPrice}"),
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.transactionId != "")...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Transaction Id".tr, subtitle: "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.transactionId}"),
                              ],
                              if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.additionalNote != "")...[
                                SizedBox(height: 5),
                                billSummaryTextDetaile(title: "Additional Note".tr, subtitle: "${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.additionalNote}"),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 15, left: 15, bottom: 10),
                              child: Text(
                                "Hospital Address".tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: FontFamily.gilroyExtraBold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(
                                    'google.navigation:q=${double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.latitude!)}, ${double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.longitude!)}&key="$googleMapKey"'));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                height: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.latitude.toString()),
                                            double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.longitude.toString()),
                                          ),
                                          zoom: 16,
                                        ),
                                        myLocationEnabled: true,
                                        tiltGesturesEnabled: true,
                                        compassEnabled: true,
                                        onTap: (argument) async {
                                          await launchUrl(Uri.parse('google.navigation:q=${double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.latitude!)}, ${double.parse(apointmentDetailDoctorController.appointmentDetailModel!.hospital!.longitude!)}&key="$googleMapKey"'));
                                        },
                                        scrollGesturesEnabled: true,
                                        zoomGesturesEnabled: true,
                                        myLocationButtonEnabled: false,
                                        zoomControlsEnabled: false,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          controller = controller;
                                        },
                                        markers:
                                            Set<Marker>.of(markers11.values),
                                      ),
                                      Positioned(
                                        bottom: 6,
                                        right: 6,
                                        left: 6,
                                        child: Container(
                                          // height: 55,
                                          width: Get.width,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: WhiteColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: primeryColor.withOpacity(0.2),
                                                ),
                                                child: SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child: Image.asset(
                                                    "assets/Location.png",
                                                    color: primeryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  apointmentDetailDoctorController.appointmentDetailModel!.hospital!.address!,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.gilroyExtraBold,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
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
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
        },
      ),
      bottomNavigationBar: GetBuilder<AppointmentDetailDoctorController>(
        builder: (apointmentDetailDoctorController) {
          return apointmentDetailDoctorController.isLoading
              ? apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "1"
                  ? Container(
                      color: WhiteColor,
                      padding: EdgeInsets.all(10),
                      child: button(
                        text: "Cancel".tr,
                        color: Colors.red,
                        onPress: () {
                          ticketCancel();
                        },
                      ),
                    )
                  : apointmentDetailDoctorController.appointmentDetailModel!.appoint!.status == "4" && apointmentDetailDoctorController.appointmentDetailModel!.appoint!.reviewCheck == 0
                      ? Container(
                          color: WhiteColor,
                          padding: EdgeInsets.all(10),
                          child: button(
                              text: "Review".tr,
                              color: primeryColor,
                              onPress: () {
                                reviewSheet();
                              }),
                        )
                      : SizedBox()
              : SizedBox();
        },
      ),
    );
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
                        if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.siteCommisiion != 0)...[
                          billSummaryTextDetaile(title: "Service Fee & Tax".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.siteCommisiion}"),
                        ],
                        if(apointmentDetailDoctorController.appointmentDetailModel!.appoint!.doctorCommission != 0)...[
                          SizedBox(height: 5),
                          billSummaryTextDetaile(title: "Doctor Commission".tr, subtitle: "${getData.read("currency")} ${apointmentDetailDoctorController.appointmentDetailModel!.appoint!.doctorCommission}"),
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

  ticketCancel() {
    cancelOrderController.rejectMsg = "";
    cancelOrderController.note.text = "";
    cancelOrderController.selectedRadioTile = "";
    radio = "";
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: WhiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Select Reason".tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Gilroy Bold',
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "${"Please select the reason for cancellation".tr} : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy Medium',
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelOrderController.cancelOrderModel!.cancelReason.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            setState(() {});
                            cancelOrderController.selectedRadioTile = cancelOrderController.cancelOrderModel!.cancelReason[i].id.toString();
                            debugPrint("******************* ${cancelOrderController.selectedRadioTile}");
                            cancelOrderController.rejectMsg = cancelOrderController.cancelOrderModel!.cancelReason[i].title;
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Radio(
                                  activeColor: primeryColor,
                                  value: cancelOrderController.cancelOrderModel!.cancelReason[i].title == cancelOrderController.rejectMsg ? true : false,
                                  groupValue: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    cancelOrderController.cancelOrderModel!
                                        .cancelReason[i].title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Gilroy Medium',
                                      color: BlackColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    cancelOrderController.rejectMsg == "Other".tr || cancelOrderController.rejectMsg == "other".tr
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: cancelOrderController.note,
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0xFF246BFD), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0xFF246BFD), width: 1),
                                ),
                                hintText: 'Enter reason'.tr,
                                hintStyle: TextStyle(
                                  fontFamily: 'Gilroy Medium',
                                  fontSize: Get.size.height / 55,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 7),
                        button2(
                          text: "Cancel".tr,
                          color: redgradient,
                          onPress: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 7),
                        button2(
                          text: "Confirm".tr,
                          color: Color(0xff10192B),
                          onPress: () {
                            cancelOrderController.cancelOrderApi(
                                appointmentId: widget.appointmentId.toString());
                          },
                        ),
                        SizedBox(width: 7),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future patientInfoDetail(
      {required String id,
      required String image,
      required String name,
      required String gender,
      required String years}) {
    patientHealthController.patientHealthApi(
        appointmentId: widget.appointmentId.toString(), familyId: id);
    return Get.bottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18), topLeft: Radius.circular(18)),
                color: bgcolor),
            child: GetBuilder<PatientHealthController>(builder: (context) {
              return patientHealthController.isLoading
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                          topLeft: Radius.circular(18)),
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: bgcolor,
                        appBar: AppBar(
                          elevation: 0,
                          toolbarHeight: 50,
                          backgroundColor: bgcolor,
                          titleSpacing: 10,
                          automaticallyImplyLeading: false,
                          title: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios, color: BlackColor)),
                        ),
                        bottomNavigationBar: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: patientHealthController.isLoadingApi
                              ? loaderButton()
                              : button(
                                  text: "Submit Details".tr,
                                  color: gradient.defoultColor,
                                  onPress: () {
                                    if (patientHealthController.isLoadingApi == false) {
                                      patientHealthController.isLoadingApi = true;
                                      setState(() {});
                                      patientHealthController.addHealthApi(
                                        appointmentId: widget.appointmentId,
                                        familyId: id,
                                      );
                                    }
                                  },
                                ),
                        ),
                        body: StatefulBuilder(
                          builder: (context, setState) {
                            return SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Share Health Concerns".tr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: FontFamily.gilroyExtraBold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "With ".tr,
                                              style: TextStyle(
                                                color: greytext,
                                                fontSize: 13,
                                                fontFamily: FontFamily.gilroyExtraBold,
                                              ),
                                            ),
                                            Text(
                                              "${apointmentDetailDoctorController.appointmentDetailModel!.doctor!.name} ",
                                              style: TextStyle(
                                                color: primeryColor,
                                                fontSize: 12,
                                                fontFamily: FontFamily.gilroyExtraBold,
                                              ),
                                            ),
                                            Text(
                                              "prior to your consultation".tr,
                                              style: TextStyle(
                                                color: greytext,
                                                fontSize: 12,
                                                fontFamily: FontFamily.gilroyExtraBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: Get.width,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey.shade300,
                                                image: DecorationImage(
                                                  image: NetworkImage(image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontSize: 17,
                                                    fontFamily: FontFamily.gilroyExtraBold,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  "$gender, $years ${"Yrs".tr}",
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.gilroyBold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Health Concerns".tr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: FontFamily.gilroyExtraBold,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        SizedBox(
                                          height: 60,
                                          child: TextFormField(
                                            controller: patientHealthController
                                                .diseaseController,
                                            style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyRegular,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor,
                                                letterSpacing: 0.3),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                                                  borderRadius: BorderRadius.circular(10)),
                                              hintText: "Enter Disease".tr,
                                              hintStyle: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyRegular,
                                                fontSize: 13,
                                                color: greyColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: gradient.defoultColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Add Health Documents".tr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily:
                                                  FontFamily.gilroyExtraBold),
                                        ),
                                        Text(
                                          "E.g. Past Prescription, Test Report, Photo, etc.".tr,
                                          style: TextStyle(
                                              color: greycolor,
                                              fontSize: 12,
                                              fontFamily: FontFamily.gilroyBold),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${"Maximum file upload size".tr} : ",
                                              style: TextStyle(
                                                color: greycolor,
                                                fontSize: 12,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),
                                            ),
                                            Text(
                                              "20 MB",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),
                                            ),
                                            Text(
                                              "/ ${"document".tr}",
                                              style: TextStyle(
                                                color: greycolor,
                                                fontSize: 12,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        patientHealthController.documentList.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 15),
                                                  SizedBox(
                                                    height: 150,
                                                    child: ListView.separated(
                                                      shrinkWrap: true,
                                                      physics: BouncingScrollPhysics(),
                                                      itemCount: patientHealthController.documentList.length,
                                                      scrollDirection: Axis.horizontal,
                                                      separatorBuilder: (context, index) => SizedBox(width: 10),
                                                      itemBuilder: (context, index) {
                                                        String filePath = patientHealthController.documentList[index];
                                                        bool isPdf = filePath.toLowerCase().endsWith(".pdf");
                                                        return Stack(
                                                          children: [
                                                            Container(
                                                              height: 150,
                                                              width: 120,
                                                              decoration: BoxDecoration(
                                                                color: isPdf
                                                                    ? bgcolor
                                                                    : WhiteColor,
                                                                borderRadius: BorderRadius.circular(8),
                                                                image: isPdf
                                                                    ? DecorationImage(
                                                                        image: AssetImage("assets/pdf_thumbnail.png"),
                                                                        fit: BoxFit.cover,
                                                                      )
                                                                    : DecorationImage(
                                                                        image: filePath.startsWith("uploads/")
                                                                            ? NetworkImage(Config.imageBaseurlDoctor + filePath)
                                                                            : FileImage(File(filePath)) as ImageProvider,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 5,
                                                              top: 5,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  patientHealthController.deleteHealthApi(
                                                                    appointmentId: widget.appointmentId,
                                                                    familyId: id,
                                                                    image: patientHealthController.documentList[index],
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.red.withOpacity(0.7),
                                                                  ),
                                                                  padding: EdgeInsets.all(4),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: Colors.white,
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: button(
                                                    text: "Add Photo".tr,
                                                    color: primeryColor,
                                                    onPress: () =>
                                                        patientHealthController
                                                            .selectImages())),
                                            SizedBox(width: 15),
                                            Expanded(
                                                child: button(
                                                    text: "Add Document".tr,
                                                    color: primeryColor,
                                                    onPress: () =>
                                                        patientHealthController
                                                            .selectPdf())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator(color: primeryColor));
            }),
          );
        }
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
    );
  }

  Widget button2(
      {required String text, required Color color, void Function()? onPress}) {
    return Expanded(
      child: SizedBox(
        height: 45,
        // width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          onPressed: onPress,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.gilroyBold,
              color: Color(0xffFFFFFF),
              // letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  Future reviewSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<AddReviewController>(
        builder: (addReviewController) {
          return Container(
            height: 520,
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Leave a Review".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Divider(
                    color: greytext,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "How was your experience".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RatingBar(
                  initialRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Image.asset(
                      'assets/starBold.png',
                      color: gradient.defoultColor,
                    ),
                    half: Image.asset(
                      'assets/star-half.png',
                      color: gradient.defoultColor,
                    ),
                    empty: Image.asset(
                      'assets/star.png',
                      color: gradient.defoultColor,
                    ),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    addReviewController.totalRateUpdate(rating);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Divider(
                    color: greytext,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Text(
                    "Write Your Review".tr,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: FontFamily.gilroyBold,
                      color: BlackColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: addReviewController.ratingText,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    cursorColor: BlackColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "Your review here...".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 16,
                      color: BlackColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Divider(
                    color: greytext,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: gradient.defoultColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Text(
                            "Maybe Later".tr,
                            style: TextStyle(
                              color: gradient.defoultColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          addReviewController
                              .addReviewApi(
                            appointmentId: widget.appointmentId.toString(),
                            review: addReviewController.ratingText.text,
                            starNo: addReviewController.tRate.toString(),
                            context: context,
                          )
                              .then((value) {
                            Get.back();
                            addReviewController.ratingText.clear();
                          });
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: gradient.defoultColor,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Text(
                            "Submit".tr,
                            style: TextStyle(
                              color: WhiteColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class DownwardTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFF1E1E1E);

    final path = Path();
    path.moveTo(size.width / 2, size.height);   // Bottom center
    path.lineTo(0, 0);                          // Top left
    path.lineTo(size.width, 0);                 // Top right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
