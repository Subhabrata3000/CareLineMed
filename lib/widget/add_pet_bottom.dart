// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller_doctor/home_controller.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/widget/button.dart';
import '../controller_doctor/add_doctor_controller.dart';
import '../controller_doctor/add_doctor_detail_controller.dart';
import '../model/font_family_model.dart';
import '../screen/home_screen.dart';
import '../utils/custom_colors.dart';

GlobalKey<AutoCompleteTextFieldState<dynamic>> key = GlobalKey();
String breedId = "";

var selectedCategoryId;
var selectedGender;
var petSize;
var petYear;
var petNatured;
var decodeUid;
bool isNot = false;

class AddPetController extends GetxController implements GetxService {
  Future _showPicker({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text(
                  "Select Photo".tr,
                  style: TextStyle(
                    color: BlackColor,
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              gradient.defoultColor),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {
                          getImage(ImageSource.gallery, context);
                          update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Gallery".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              gradient.defoultColor),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {
                          getImage(ImageSource.camera, context);
                          update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Camera".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 18,
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
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img, context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      addPatientController.galleryFile = File(pickedFile!.path);
      addPatientController.xFileImage = xfilePick;
      update();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nothing is selected"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop();
    }
    update();
  }

  TextEditingController petNameController = TextEditingController();
  TextEditingController breedTypeController = TextEditingController();

  AddPatientController addPatientController = Get.put(AddPatientController());
  HomeController homeController = Get.put(HomeController());

  Future addPetBottom(context,{String? familyMemberId}) {
    if (familyMemberId != null) {
      addPatientController.familyMemberDetailApi(fid: familyMemberId);
    } else {
      addPatientController.nameController.clear();
      addPatientController.relationShipController.clear();
      addPatientController.bloodController.clear();
      addPatientController.ageController.clear();
      addPatientController.nationalController.clear();
      addPatientController.heightController.clear();
      addPatientController.weightController.clear();
      addPatientController.allergiesController.clear();
      addPatientController.historyController.clear();
      addPatientController.bloodId = "";
      addPatientController.relationShipId = "";
    }
    addPatientController.galleryFile = null;
    addPatientController.xFileImage = null;

    addPatientController.updateLoading(false);

    debugPrint("============== nameController =============== ${addPatientController.nameController.text}");
    debugPrint("========== relationShipController =========== ${addPatientController.relationShipController.text}");
    debugPrint("============= bloodController =============== ${addPatientController.bloodController.text}");
    debugPrint("============== ageController ================ ${addPatientController.ageController.text}");
    debugPrint("=========== nationalController ============== ${addPatientController.nationalController.text}");
    debugPrint("============ heightController =============== ${addPatientController.heightController.text}");
    debugPrint("============ weightController =============== ${addPatientController.weightController.text}");
    debugPrint("========== allergiesController ============== ${addPatientController.allergiesController.text}");
    debugPrint("============ historyController ============== ${addPatientController.historyController.text}");
    debugPrint("================ bloodId ==================== ${addPatientController.bloodId}");
    debugPrint("============ relationShipId ================= ${addPatientController.relationShipId}");
    debugPrint("============== galleryFile ================== ${addPatientController.galleryFile}");
    debugPrint("============== xFileImage =================== ${addPatientController.xFileImage}");

    AddDoctorDetailController addDoctorDetailController = Get.put(AddDoctorDetailController());

    return Get.bottomSheet(
      ignoreSafeArea: true,
      Container(
        constraints: BoxConstraints(maxHeight: Get.height / 1.2),
        child: StatefulBuilder(
          builder: (context, setState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: 700,
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: WhiteColor,
                ),
                child: Scaffold(
                  backgroundColor: WhiteColor,
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.all(10),
                    child:  GetBuilder<AddPatientController>(
                        builder: (addPatientController) {
                          return addPatientController.isLoading
                              ? loaderButton()
                              : button(
                                  text: familyMemberId != null ? "Update".tr : "SUBMIT".tr,
                                  color: gradient.defoultColor,
                                  onPress: () async {
                                    if (familyMemberId != null ) {
                                      addPatientController.updateLoading(true); // Show loader
                                      addPatientController.editPatientApi(
                                        context: context,
                                        fid: familyMemberId,
                                      ).then((value) {
                                        homeController.homeApiDoctor(lat: lat, lon: long);
                                        addPatientController.updateLoading(false); // Hide loader
                                        addPatientController.nameController.clear();
                                        addPatientController.relationShipController.clear();
                                        addPatientController.bloodController.clear();
                                        addPatientController.selectedGender.clear();
                                        addPatientController.ageController.clear();
                                        addPatientController.nationalController.clear();
                                        addPatientController.heightController.clear();
                                        addPatientController.weightController.clear();
                                        addPatientController.allergiesController.clear();
                                        addPatientController.historyController.clear();
                                        addPatientController.bloodId = "";
                                        addPatientController.relationShipId = "";
                                        addPatientController.galleryFile = null;
                                        addPatientController.xFileImage = null;
                                        update();
                                      }).catchError((error) {
                                        addPatientController.updateLoading(false); // Hide loader on error
                                      });
                                    } else {
                                      if (addPatientController.relationShipId != "") {
                                        if (addPatientController.bloodId != "") {
                                          if (addPatientController.galleryFile != null && addPatientController.nameController.text.isNotEmpty && addPatientController.relationShipController.text.isNotEmpty && addPatientController.bloodController.text.isNotEmpty && addPatientController.selectedGender.toString().isNotEmpty && addPatientController.ageController.text.isNotEmpty && addPatientController.nationalController.text.isNotEmpty && addPatientController.heightController.text.isNotEmpty && addPatientController.weightController.text.isNotEmpty && addPatientController.allergiesController.text.isNotEmpty && addPatientController.historyController.text.isNotEmpty) {
                                            addPatientController.updateLoading(true); // Show loader
                                            addPatientController.addPatientApi(context: context).then((value) {
                                              homeController.homeApiDoctor(lat: lat, lon: long);
                                              addPatientController.updateLoading(false); // Hide loader
                                              addPatientController.nameController.clear();
                                              addPatientController.relationShipController.clear();
                                              addPatientController.bloodController.clear();
                                              addPatientController.selectedGender.clear();
                                              addPatientController.ageController.clear();
                                              addPatientController.nationalController.clear();
                                              addPatientController.heightController.clear();
                                              addPatientController.weightController.clear();
                                              addPatientController.allergiesController.clear();
                                              addPatientController.historyController.clear();
                                              addPatientController.bloodId = "";
                                              addPatientController.relationShipId = "";
                                              addPatientController.galleryFile = null;
                                              addPatientController.xFileImage = null;
                                              update();
                                            }).catchError((error) {
                                              addPatientController.updateLoading(false); // Hide loader on error
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Enter all Fields".tr),
                                                behavior: SnackBarBehavior.floating,
                                                duration: Duration(seconds: 1),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Blood Not Found...!!!".tr),
                                              behavior: SnackBarBehavior.floating,
                                              duration: Duration(seconds: 1),
                                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("RelationShip Not Found...!!!".tr),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(seconds: 1),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                        );
                                      }  
                                    }
                                  },
                                );
                        },
                      ),
                  ),
                  body: GetBuilder<AddPatientController>(
                    builder: (addPatientController) {
                      return addPatientController.detailsLoding
                      ? Center(child: CircularProgressIndicator(color: primeryColor))
                      : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                addPatientController.galleryFile != null
                                  ? Center(
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: FileImage(addPatientController.galleryFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : familyMemberId != null
                                    ? Center(
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage("${Config.imageBaseurlDoctor}${addPatientController.familyMemberDetailModel!.data!.profileImage}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "assets/userbold.png",
                                            color: greycolor,
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  bottom: -10,
                                  left: 100,
                                  right: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context: context).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: gradient.defoultColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Add Photo".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 19,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            addPatientTextFormFile(
                              titel: "Patient Name".tr,
                              hintText: "Patient Name".tr,
                              controller: addPatientController.nameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Relationship".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 16,
                                          color: BlackColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TypeAheadField(
                                        controller: addPatientController.relationShipController,
                                        builder: (context, controller, focusNode) {
                                          return TextFormField(
                                            controller: addPatientController.relationShipController,
                                            focusNode: focusNode,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 15,
                                              color: textcolor,
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              hintText: "Relationship Type".tr,
                                              hintStyle: TextStyle(
                                                fontFamily: FontFamily.gilroyMedium,
                                                fontSize: 15,
                                                color: greyColor,
                                              ),
                                              contentPadding: EdgeInsets.only(top: 20, left: 12, right: 12),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: primeryColor,width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        },
                                        emptyBuilder: (context) => Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "No RelationShip Found...!!!".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 16,
                                              color: BlackColor,
                                            ),
                                          ),
                                        ),
                                        onSelected: (item) {
                                          debugPrint(item.name);
                                          setState(() {
                                            addPatientController.relationShipId = item.id.toString();
                                          });
                                          addPatientController.relationShipController.text = item.name;
                                        },
                                        suggestionsCallback: (pattern) async {
                                          return addDoctorDetailController.addDoctorDetailModel!.relationshipList.where((element) => element.name.toLowerCase().contains(pattern.toLowerCase())).toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.name,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 16,
                                                color: BlackColor,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Blood Type".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 16,
                                          color: BlackColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TypeAheadField(
                                        controller: addPatientController.bloodController,
                                        builder: (context, controller, focusNode) {
                                          return TextFormField(
                                            controller: addPatientController.bloodController,
                                            focusNode: focusNode,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 15,
                                              color: textcolor,
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              hintText: 'Blood Type'.tr,
                                              hintStyle: TextStyle(
                                                fontFamily: FontFamily.gilroyMedium,
                                                fontSize: 15,
                                                color: greyColor,
                                              ),
                                              contentPadding: EdgeInsets.only(top: 20,left: 12,right: 12),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: primeryColor,width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        },
                                        emptyBuilder: (context) => Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "No Blood Found...!!!".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 16,
                                              color: BlackColor,
                                            ),
                                          ),
                                        ),
                                        onSelected: (item) {
                                          debugPrint(item.name);
                                          setState(() {
                                            addPatientController.bloodId = item.id.toString();
                                          });
                                          addPatientController.bloodController.text = item.name;
                                        },
                                        suggestionsCallback: (pattern) async {
                                          return addDoctorDetailController.addDoctorDetailModel!.bloodGroupList.where((element) => element.name.toLowerCase().contains(pattern.toLowerCase())).toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion.name,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 16,
                                                color: BlackColor,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Patient Gender".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 16,
                                color: BlackColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        addPatientController.selectedGender = "Male";
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: addPatientController.selectedGender == "Male"
                                            ? gradient.defoultColor
                                            : Colors.grey.shade300,
                                        border: Border(
                                          right: BorderSide(color: greyColor, width: 1),
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.male,
                                              size: 20,
                                              color: addPatientController.selectedGender == "Male"
                                                  ? Colors.white
                                                  : textcolor),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Male".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 16,
                                              color: addPatientController.selectedGender == "Male"
                                                  ? Colors.white
                                                  : textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        addPatientController.selectedGender = "Female";
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: addPatientController.selectedGender == "Female"
                                            ? Colors.pinkAccent
                                            : Colors.grey.shade300,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.female,
                                            size: 20,
                                            color: addPatientController.selectedGender == "Female"
                                              ? Colors.white
                                              : textcolor,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Female".tr,
                                            style: TextStyle(
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 16,
                                              color: addPatientController.selectedGender == "Female"
                                                  ? Colors.white
                                                  : textcolor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: addPatientTextFormFile(
                                    titel: "Patient Age".tr,
                                    hintText: "Patient Age".tr,
                                    controller: addPatientController.ageController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: addPatientTextFormFile(
                                    titel: "National ID".tr,
                                    hintText: "National ID".tr,
                                    controller: addPatientController.nationalController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: addPatientTextFormFile(
                                    titel: "Height".tr,
                                    hintText: "Height".tr,
                                    controller: addPatientController.heightController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: addPatientTextFormFile(
                                    titel: "Weight".tr,
                                    hintText: "Weight".tr,
                                    controller: addPatientController.weightController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            addPatientTextFormFile(
                              titel: "Allergies".tr,
                              hintText: "Allergies".tr,
                              controller: addPatientController.allergiesController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),
                            addPatientTextFormFile(
                              titel: "Medical History".tr,
                              hintText: "Medical History".tr,
                              controller: addPatientController.historyController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 13),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }

  addPatientTextFormFile({
    required String titel,
    required String hintText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
  }){
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
             titel,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.words,
              textInputAction: textInputAction,
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
                hintText: hintText,
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
                  borderSide: const BorderSide(
                    color: gradient.defoultColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  updateEditPet({
    required String petName,
    required String breedType,
    required String petUpdate,
    required String genderUpdate,
    required String sizeUpdate,
    required String oldUpdate,
    required String natured,
    required String breedIds,
  }) {
    petNameController.text = petName;
    breedTypeController.text = breedType;
    breedId = breedIds;
    selectedCategoryId = int.parse(petUpdate);
    selectedGender = genderUpdate;
    petSize = int.parse(sizeUpdate);
    petYear = int.parse(oldUpdate);
    petNatured = natured;
    update();
  }
}
