// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/utils/String.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

var lat;
var long;
var address;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
    getCurrentLatAndLong();
  }

  Future<void> getCurrentLatAndLong() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        // Permissions denied, close the app
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return;
      }

      // Get current position
      Position currentLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(const Duration(seconds: 5));

      lat = currentLocation.latitude;
      long = currentLocation.longitude;

      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, long!);
      Placemark place = placemarks.first;

      setState(() {
        address = '${place.name ?? ''}'
            '${place.thoroughfare != null && place.thoroughfare!.isNotEmpty ? ', ${place.thoroughfare}' : ''}'
            '${place.subLocality != null && place.subLocality!.isNotEmpty ? ', ${place.subLocality}' : ''}'
            '${place.locality != null && place.locality!.isNotEmpty ? ', ${place.locality}' : ''}'
            '${place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty ? ', ${place.subAdministrativeArea}' : ''}'
            '${place.postalCode != null && place.postalCode!.isNotEmpty ? ', ${place.postalCode}' : ''}'
            '${place.administrativeArea != null && place.administrativeArea!.isNotEmpty ? ', ${place.administrativeArea}' : ''}';
      });
    } catch (e) {
      debugPrint("Error getting location or placemark: $e");
    }
  }

  void initialization() async {
    bool isLogin = await loginSharedPreferencesGet(); // Your shared prefs logic
    await Future.delayed(const Duration(seconds: 3), () {
      debugPrint("--------------- isLogin ----------- $isLogin");
      if (isLogin) {
        Get.offAll(BoardingPage());
      } else {
        Get.offAll(BottomBarScreen());
      }
    });
  }

  DateTime? lastBackPressed;

  Future popScopeBack() async {
    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > Duration(seconds: 2)) {
      lastBackPressed = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await popScopeBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/appLogo.svg", height: 120, width: 120),
              SizedBox(height: 10),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  BoardingScreenState createState() => BoardingScreenState();
}

class BoardingScreenState extends State<BoardingPage> {
  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _slides = [
      Slide("assets/doc.jpeg", "Your Health, Simplified", provider.healthy),
      Slide("assets/doc.jpeg", "Healthcare at Your Fingertips",
          provider.orderthe),
      Slide("assets/doc.jpeg", "Welcome to Better Health", provider.cooking),
    ];

    _pageController = PageController(initialPage: _currentPage);
  }

  int _currentPage = 0;
  List<Slide> _slides = [];
  PageController _pageController = PageController();

  Widget _buildFloatingCard({
    required Widget child,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Top Headline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: "Gilroy Bold",
                    color: BlackColor,
                    height: 1.1,
                  ),
                  children: [
                    const TextSpan(text: "Let's Get to Know You and "),
                    TextSpan(
                      text: "Your Health Goals",
                      style: TextStyle(color: primeryColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Middle Section: Doctor Image with Floating Cards
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Doctor Image
                  Positioned(
                    bottom: 20,
                    left: 30,
                    child: Container(
                      height: Get.height * 0.45,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/doc1.png"),
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Floating Card 1: Review/Quote (Top Left)
                  _buildFloatingCard(
                    top: 2,
                    left: 20,
                    child: SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.format_quote,
                              color: primeryColor, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            "This app is really helpful in providing fast and quality care.",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "Gilroy Medium",
                              color: greycolor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 8,
                                  backgroundImage:
                                      AssetImage("assets/user1.png"),
                                  backgroundColor:
                                      primeryColor.withOpacity(0.2)),
                              const SizedBox(width: 4),
                              Text(
                                "Rahmat W.",
                                style: TextStyle(
                                    fontSize: 8, fontFamily: "Gilroy Bold"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // Floating Card 2: Blue Status Card (Right)
                  Positioned(
                    top: 100,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primeryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primeryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Caring\nfrom Afar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "Gilroy Bold",
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Your Health Our Priority",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "More details >",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Card 3: Doctor Name Card (Bottom Left)
                  _buildFloatingCard(
                    bottom: 100,
                    left: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage("assets/doc.jpeg"),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Dr. Fata Hibban",
                              style: TextStyle(
                                  fontSize: 10, fontFamily: "Gilroy Bold"),
                            ),
                            Text(
                              "Endocrinologist",
                              style: TextStyle(fontSize: 8, color: greycolor),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.star, color: Colors.orange, size: 10),
                        const SizedBox(width: 2),
                        Text("4.8",
                            style: TextStyle(
                                fontSize: 10, fontFamily: "Gilroy Bold")),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Shaping a Healthier Future by Making the Right\nChoices to Maintain and Improve Your Wellbeing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: greycolor,
                      fontFamily: "Gilroy Medium",
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const LoginScreen());
                      save("isBack", true);
                    },
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primeryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Gilroy Bold",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void loginSharedPreferencesSet(bool value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool("userLogin", value);
}

Future<bool> loginSharedPreferencesGet() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool value = preferences.getBool("userLogin") ?? true;
  return value;
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}

Future<Position> locateUser() async {
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
