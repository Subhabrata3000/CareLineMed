import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundry/controller/delete_account_controller.dart';
import 'package:laundry/controller_doctor/home_controller.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/faq_list_screen.dart';
import 'package:laundry/screen/lab/lab_booking_list_screen.dart';
import 'package:laundry/screen/medicine_reminder/medicine_reminder_screen.dart';
import 'package:laundry/screen/shop/my%20order/my_order_screen.dart';
import 'package:laundry/screen/shop/product.dart';
import 'package:laundry/widget/button.dart';
import 'package:laundry/widget/custom_title.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../controller_doctor/cart_detail_controller.dart';
import '../controller_doctor/edit_profile_controller.dart';
import '../controller_doctor/pages_list_controller.dart';
import '../helpar/routes_helper.dart';
import '../model/font_family_model.dart';
import '../model/model.dart';
import '../screen/language/language_screen.dart';
import '../utils/custom_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String ccode = "";
  bool obscureText = true;

  EditProfileController editProfileController = Get.put(EditProfileController());
  PageListController pageListController = Get.put(PageListController());
  CartDetailController cartDetailController = Get.put(CartDetailController());
  HomeController homeController = Get.put(HomeController());
  DeleteAccountController deleteAccountController = Get.put(DeleteAccountController());

  @override
  void initState() {
    super.initState();
    pageListController.pageListApi(context);
    debugPrint("=================== ${getData.read("UserLogin")}");
  }

  @override
  void dispose() {
    super.dispose();
    pageListController.isLoading = false;
  }

  get picker => ImagePicker();

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
                padding: const EdgeInsets.only(left: 20,top: 15),
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
                          backgroundColor: WidgetStatePropertyAll(primeryColor),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {
                          editProfileController.photoUplodLoading = true;
                          setState(() {});
                          getImage(ImageSource.gallery,context);
                          setState(() {});
                        },
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.photo_library,color: Colors.white,size: 22,),
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
                          backgroundColor: WidgetStatePropertyAll(primeryColor),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: (){
                          editProfileController.photoUplodLoading = true;
                          setState(() {});
                          getImage(ImageSource.camera,context);
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.photo_camera,color: Colors.white,size: 22,),
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
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img, BuildContext context) async {
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      File selectedFile = File(pickedFile.path);

      // Update the controller variables
      editProfileController.coverimagepath = selectedFile.path;  // New local image path
      editProfileController.image = ""; // Clear the old image URL

      Get.back(); // Close the bottom sheet

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text('Nothing is selected'.tr),
        ),
      );
      Navigator.of(context).pop();
    }
    editProfileController.photoUplodLoading = false;
    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WhiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile Account".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<PageListController>(
        builder: (pageListController) {
          return pageListController.isLoading
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: Get.height / 7.5),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: Get.size.width,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: getData.read("UserLogin") == null
                        ? Container()
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                getData.read("UserLogin")["image"] == "" ? Container(
                                  height: 95,
                                  width: 95,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child:  Text(
                                    getData.read("UserLogin")["name"][0].toString().toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyExtraBold,
                                      fontSize: 23,
                                      color: primeryColor,
                                    ),
                                  ),) : Container(
                                  height: 95,
                                  width: 95,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: FadeInImage.assetNetwork(
                                      fadeInCurve: Curves.easeInCirc,
                                      placeholder:
                                      "assets/ezgif.com-crop.gif",
                                      placeholderCacheHeight: 95,
                                      placeholderCacheWidth: 95,
                                      placeholderFit: BoxFit.cover,
                                      image: Config.imageBaseurlDoctor + getData.read("UserLogin")["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      editProfileController.coverimagepath = null;
                                      nameController.clear();
                                      emailController.clear();
                                      mobileController.clear();
                                      setState(() {});
                                      nameController.text = getData.read("UserLogin")["name"];
                                      emailController.text = getData.read("UserLogin")["email"];
                                      mobileController.text = getData.read("UserLogin")["phone"];
                                      ccode = getData.read("UserLogin")["country_code"];
                                      editProfileController.image = getData.read("UserLogin")["image"];
                                      setState(() {});
                                      editProfileBottom(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primeryColor,
                                      ),
                                      child: SizedBox(
                                        height: 16,
                                        child: SvgPicture.asset(
                                          "assets/edit.svg",
                                          color: WhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              getData.read("UserLogin")["name"],
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 15,
                                color: BlackColor,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/phone-call.png",
                                  height: 15,
                                  width: 15,
                                  color: BlackColor.withOpacity(0.8),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${getData.read("UserLogin")["country_code"]} ${getData.read("UserLogin")["phone"]}",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyMedium,
                                    color: BlackColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 15),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: WhiteColor,borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "General".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 18,
                                color: BlackColor,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.separated(
                                itemCount: model().profileList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return customListTile(
                                    images: model().profileImg[index],
                                    title: model().profileList[index],
                                    onTap: () {
                                      if (index == 0) {
                                        Get.toNamed(Routes.myBookingScreen);
                                      } else if (index == 1) {
                                        Get.to(MyOrderScreen());
                                      } else if (index == 2) {
                                        Get.to(MedicineReminderScreen());
                                      } else if (index == 3) {
                                        Get.to(LabBookingListScreen());
                                      } else if (index == 4) {
                                        Get.toNamed(Routes.walletHistoryScreen);
                                      }
                                    },
                                  );
                                }, 
                                separatorBuilder: (BuildContext context, int index) { 
                                  return Container(
                                    height: 1,
                                    width: Get.width,
                                    color: Colors.grey.shade300,
                                  );
                                 },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 15),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: WhiteColor, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Others".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 18,
                                color: BlackColor,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.separated(
                                itemCount: model().profileList2.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return index == 2
                                      ? ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: pageListController.pageListModel!.pagesData.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                customListTile(
                                                  images: "assets/clipboard-text.svg",
                                                  title: pageListController.pageListModel!.pagesData[index].title,
                                                  onTap: () {
                                                    Get.toNamed(
                                                      Routes.loream,
                                                      arguments: {
                                                        "title": pageListController.pageListModel!.pagesData[index].title,
                                                        "discription": pageListController.pageListModel!.pagesData[index].description,
                                                      },
                                                    );
                                                  },
                                                ),
                                                index == pageListController.pageListModel!.pagesData.length - 1
                                                ? Container() 
                                                : Container(
                                                    height: 1,
                                                    width: Get.width,
                                                    color: Colors.grey.shade300,
                                                  ),
                                              ],
                                            );
                                          },
                                        )
                                      : customListTile(
                                          images: model().profileImg2[index],
                                          title: model().profileList2[index],
                                          onTap:  () {
                                            if (index == 0) {
                                              Get.toNamed(Routes.referFriendScreen);
                                            } else if (index == 1) {
                                              Get.to(FaqListScreen());
                                            } else if (index == 3) {
                                              Get.to(LanguageScreen());
                                            } else if (index == 4) {
                                              deleteSheet();
                                            } else if (index == 5) {
                                              logoutSheet();
                                            }
                                          },
                                        );
                                },
                                separatorBuilder: (BuildContext context, int index) { 
                                  return Container(
                                    height: 1,
                                    width: Get.width,
                                    color: Colors.grey.shade300,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator(color: primeryColor));
        },
      ),
    );
  }

  customListTile({
    required String images,
    required String title,
    required VoidCallback onTap,
  }) {
    return  InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: getImageExtention(images) == ".svg"
              ? SvgPicture.asset(
                  images,
                  color: BlackColor,
                )
              : Image.asset(
                  images,
                  color: BlackColor,
                ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                  color: BlackColor,
                ),
              ),
            ),
            Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(7),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/chevron-right.png",
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logoutSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: Get.size.width,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Logout".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Divider(color: greycolor),
            ),
            Text(
              "Are you sure you want to log out?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          color: gradient.defoultColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      loginSharedPreferencesSet(true);
                      cartDetailController.changeIndex(0);
                      final storage = GetStorage();
                      save("UserLogin", null);
                      storage.erase();
                      Get.offAll(BoardingPage());
                      homeController.isLoading = false;
                      productCartQuntityList.clear();
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: gradient.btnGradient,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Text(
                        "Yes, Logout".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future editProfileBottom(context) {
    return Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            color: bgcolor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Profile".tr,
                    style: TextStyle(
                      fontFamily:  FontFamily.gilroyBold,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: primeryColor,
                      radius: Radius.circular(15),
                      child: InkWell(
                        onTap: () {
                          _showPicker(context: context).then((value) {
                            setState((){});
                          });
                        },
                        child: Container(
                          height: 150,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: Get.size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: editProfileController.photoUplodLoading
                            ? Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: gradient.defoultColor.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: gradient.defoultColor,
                                    size: 25,
                                  ),
                                ),
                              )
                            : editProfileController.image.isEmpty
                                ? (editProfileController.coverimagepath == null
                                    ? Image.asset(
                                        "assets/uplodeimage.png",
                                        color: primeryColor,// Default "Select Image"
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(editProfileController.coverimagepath!),
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ))
                                : Image.network(
                                    "${Config.imageBaseurlDoctor}${editProfileController.image}",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: nameController,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                      letterSpacing: 0.3,
                    ),
                    decoration:  InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(top: 15,left: 12),
                      hintText: getData.read("UserLogin")["name"],
                      hintStyle:  TextStyle(
                        fontFamily: FontFamily.gilroyRegular,
                        fontSize: 16,
                        color: greyColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      border:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gradient.defoultColor,width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: emailController,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                      letterSpacing: 0.3,
                    ),
                    decoration:  InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(top: 15,left: 12),
                      hintText:  getData.read("UserLogin")["email"],
                      hintStyle:  TextStyle(
                        fontFamily: FontFamily.gilroyRegular,
                        fontSize: 16,
                        color: greyColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: gradient.defoultColor,width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  IntlPhoneField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                      letterSpacing: 0.3,
                    ),
                    decoration:  InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                      hintText: getData.read("UserLogin")["phone"],
                      hintStyle:  TextStyle(
                        fontFamily: FontFamily.gilroyRegular,
                        fontSize: 16,
                        color: textcolor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      border:  OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: gradient.defoultColor,width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    flagsButtonPadding: EdgeInsets.zero,
                    showCountryFlag: false,
                    showDropdownIcon: false,
                    initialCountryCode: 'IN',
                    dropdownTextStyle:  TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      fontSize: 15,
                      color: textcolor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    onChanged: (number) {
                      setState(() {
                        ccode  = getData.read("UserLogin")["country_code"];
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    obscureText: obscureText,
                    style: TextStyle(
                        fontFamily: FontFamily.gilroyRegular,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textcolor,
                        letterSpacing: 0.3),
                    decoration:  InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(top: 15,left: 12),
                      hintText: "Enter Password (Optional)".tr,
                      hintStyle:  TextStyle(
                        fontFamily: FontFamily.gilroyRegular,
                        fontSize: 16,
                        color: greyColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      suffixIcon: InkWell(
                          onTap: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: obscureText == false ? Icon(Icons.remove_red_eye,color: Greycolor,size: 19) : Icon(Icons.visibility_off_rounded,color: Greycolor,size: 19)),
                      border:  OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:  const BorderSide(color: gradient.defoultColor,width: 1.5),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  GetBuilder<EditProfileController>(
                      builder: (editProfileController) {
                        return editProfileController.isLoading ? loaderButton() : button(text: "Update".tr, color: gradient.defoultColor,
                            onPress: () {

                              setState(() {
                                editProfileController.updateLoading(true);
                                if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && mobileController.text.isNotEmpty){
                                  editProfileController.editProfileApi(name: nameController.text, email: emailController.text, cCode: ccode, phone: mobileController.text, password: "", context: context).then((value)  async {
                                    pageListController.pageListApi(context);
                                    editProfileController.updateLoading(false);
                                  });
                                } else {
                                  editProfileController.updateLoading(false);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all detail....!!!".tr)));
                                }
                              },);

                            }
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      ),
      isScrollControlled: true,
    );
  }

  Future deleteSheet() {
    return Get.bottomSheet(
      Container(
        width: Get.size.width,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Delete Account".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: greycolor,
              ),
            ),
            Text(
              "Are you sure you want to delete account?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gradient.defoultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          color: gradient.defoultColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      deleteAccountController.deleteAccountApi().then((value) {
                        if (value["Result"] == true) {
                          loginSharedPreferencesSet(true);
                          cartDetailController.changeIndex(0);
                          final storage = GetStorage();
                          save("UserLogin", null);
                          storage.erase();
                          Get.offAll(BoardingPage());
                          homeController.isLoading = false;
                          productCartQuntityList.clear();
                          setState(() {});
                        } else {
                          Fluttertoast.showToast(msg: "${value["message"]}");
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: gradient.btnGradient,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Text(
                        "Yes, Remove".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}








