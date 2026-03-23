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
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/screen/bottombarpro_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/utils/String.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient.splashGradient,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Central Logo with subtle shadow/glow
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        "assets/logo/img.png",
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "CarelineMed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              // Bottom slogan and version
              Positioned(
                bottom: 50,
                child: Column(
                  children: [
                    Text(
                      "Your Health, Our Priority",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontFamily: FontFamily.poppins,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 3,
                      width: 100,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoardingPage extends StatefulWidget {
  const BoardingPage({Key? key}) : super(key: key);

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      icon: Icons.medication_rounded,
      title: 'Order Medicines\nAnytime',
      subtitle:
          'Search from thousands of medicines and get them delivered to your doorstep within hours.',
      color: const Color(0xFF00A89F),
    ),
    _OnboardData(
      icon: Icons.video_call_rounded,
      title: 'Consult Doctors\nOnline',
      subtitle:
          'Book appointments, video call, or chat with certified doctors from the comfort of your home.',
      color: const Color(0xFF00ACC1),
    ),
    _OnboardData(
      icon: Icons.local_shipping_rounded,
      title: 'Fast & Reliable\nDelivery',
      subtitle:
          'Track your order in real-time with our dedicated delivery network across your city.',
      color: const Color(0xFF43A047),
    ),
    _OnboardData(
      icon: Icons.security_rounded,
      title: 'Safe & Secure\nPayments',
      subtitle:
          'Pay via UPI, cards, net banking or wallet. Your transactions are always safe with us.',
      color: const Color(0xFF7B1FA2),
    ),
  ];

  void _finish() {
    loginSharedPreferencesSet(false);
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _finish,
                  child: Text('Skip',
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        color: greycolor,
                        fontSize: 15,
                      )),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (ctx, i) => _OnboardPage(data: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: primeryColor,
                      dotColor: greycolor.withOpacity(0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _currentPage < _pages.length - 1
                      ? InkWell(
                          onTap: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          ),
                          child: Container(
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: primeryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: _finish,
                          child: Container(
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: primeryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Get Started",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: FontFamily.gilroyBold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  const _OnboardPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 90, color: data.color),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: TextStyle(fontFamily: FontFamily.gilroyExtraBold, fontSize: 26, color: BlackColor, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: greycolor, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
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



Future<Position> locateUser() async {
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
