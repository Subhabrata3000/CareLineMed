// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/screen/authentication/onbording_screen.dart';
import 'package:carelinemed/screen/doctor_info_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import '../controller/search_controller.dart';
import '../model/font_family_model.dart';
import 'package:geolocator/geolocator.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  TextEditingController search = TextEditingController();
  SearchHomeController searchHomeController = Get.put(SearchHomeController());

  String currentLat = "0.0";
  String currentLong = "0.0";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _searchWithFallback();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _searchWithFallback();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _searchWithFallback();
      return;
    }
    //it's find the user location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLat = position.latitude.toString();
      currentLong = position.longitude.toString();
    });

    getData.write("lat", currentLat);
    getData.write("long", currentLong);

    searchHomeController.searchApi(
      context: context,
      search: "",
      lat: currentLat,
      long: currentLong,
    );
  }

  void _searchWithFallback() {
    var savedLat = getData.read("lat");
    var savedLong = getData.read("long");

    if (savedLat != null && savedLat.toString() != "0.0") {
      setState(() {
        currentLat = savedLat.toString();
        currentLong = savedLong.toString();
      });
    }

    searchHomeController.searchApi(
      context: context,
      search: "",
      lat: currentLat,
      long: currentLong,
    );
  }

  @override
  void dispose() {
    searchHomeController.isLoading = false;
    super.dispose();
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
        titleSpacing: 0,
        elevation: 0,
        title: Container(
          width: Get.width,
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: search,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              searchHomeController.searchApi(
                context: context,
                search: value,
                lat: currentLat,
                long: currentLong,
              );
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: InputBorder.none,
              hintText: "Enter the doctor you are looking for",
              hintStyle: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                color: greytext,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<SearchHomeController>(
          builder: (searchHomeController) {
            return searchHomeController.isLoading
                ? searchHomeController.searchModel?.doctorList != null &&
                searchHomeController.searchModel!.doctorList!.isNotEmpty
                ? ListView.separated(
              itemCount: searchHomeController.searchModel!.doctorList!.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(15),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Get.to(
                      DoctorInfoScreen(
                        doctorid: "${searchHomeController.searchModel!.doctorList![index].id}",
                        departmentId: "0",
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: greycolor.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: FadeInImage.assetNetwork(
                                      fadeInCurve: Curves.easeInCirc,
                                      placeholder: "assets/ezgif.com-crop.gif",
                                      placeholderCacheHeight: 70,
                                      placeholderCacheWidth: 70,
                                      placeholderFit: BoxFit.cover,
                                      image: "${Config.imageBaseurlDoctor}${searchHomeController.searchModel!.doctorList![index].logo}",
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
                                        "${searchHomeController.searchModel!.doctorList![index].name}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 17,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "${searchHomeController.searchModel!.doctorList![index].title}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${searchHomeController.searchModel!.doctorList![index].subtitle}",
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyMedium,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (searchHomeController.searchModel!.doctorList![index].totFavorite == "1") ...[
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/heart.png",
                                        height: 18,
                                        width: 18,
                                        color: gradient.defoultColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "${searchHomeController.searchModel!.doctorList![index].totFavorite} ${"Love this".tr}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/location-pin_filled.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${searchHomeController.searchModel!.doctorList![index].distance?.toStringAsFixed(2) ?? "0.0"} KM",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: BlackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/ic_star_review.png",
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${searchHomeController.searchModel!.doctorList![index].avgStar ?? 0.0} ${"Reviews".tr}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: BlackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/emptyOrder.png", height: Get.height / 5),
                  const SizedBox(height: 10),
                  Text(
                    "No Doctor yet!".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      color: BlackColor,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: Get.width / 1.6,
                    child: Text(
                      "Currently you don’t have any doctor in you area!.".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        color: greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
                : Center(child: CircularProgressIndicator(color: gradient.defoultColor));
          },
        ),
      ),
    );
  }
}
