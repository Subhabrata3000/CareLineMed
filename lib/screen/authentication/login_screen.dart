// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controller_doctor/login_controller.dart';
import '../../controller_doctor/mobile_check_controller.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/screen/authentication/sign_up_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import '../../widget/button.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String ccode = "";
  bool mobileCheck = false;
  bool obscureText = true;

  bool isLoading = false;

  int loginType = 0;

  TabController? tabController;
  bool showLoginFields = false;

  CheckMobileController checkMobileController = Get.put(CheckMobileController());
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    mobileController.clear();
    passwordController.clear();
    emailController.clear();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showLoginFields ? buildLoginFields() : buildWelcomeView(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWelcomeView() {
    return Column(
      key: const ValueKey("WelcomeView"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        // Premium Icon with Glow
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: primeryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primeryColor.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: primeryColor,
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primeryColor, primeryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 35),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          "Meet Doctor",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: primeryColor,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your health, simplified. 👋\nJoin us today!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FontFamily.gilroyMedium,
            color: greyColor,
            fontSize: 17,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 50),
        // Social Buttons
        socialButton(
          icon: SvgPicture.network(
            "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
            height: 22,
            width: 22,
          ),
          text: "Continue with Google",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        socialButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: textcolor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.email_rounded, color: textcolor, size: 18),
          ),
          text: "Sign Up with Email",
          onTap: () {
            Get.to(() => const SignUpScreen());
          },
        ),
        const SizedBox(height: 40),
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: greyColor.withOpacity(0.2), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("OR", style: TextStyle(color: greyColor.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
            Expanded(child: Divider(color: greyColor.withOpacity(0.2), thickness: 1)),
          ],
        ),
        const SizedBox(height: 40),
        // Main Action Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primeryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: primeryColor.withOpacity(0.4),
            ),
            onPressed: () {
              setState(() {
                showLoginFields = true;
              });
            },
            child: Text(
              "Log In to my Account",
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Terms
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text.rich(
            TextSpan(
              text: "By continuing, you agree to Meet Doctor\n",
              style: TextStyle(color: greyColor, fontSize: 12, height: 1.5),
              children: [
                TextSpan(text: "Terms of Service", style: TextStyle(color: textcolor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                TextSpan(text: " and "),
                TextSpan(text: "Privacy Policy", style: TextStyle(color: textcolor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget socialButton({required Widget icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: WhiteColor,
          border: Border.all(color: greyColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: textcolor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginFields() {
    return Column(
      key: const ValueKey("LoginFields"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button and Title
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => showLoginFields = false),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primeryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: primeryColor, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Welcome Back",
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: textcolor,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Custom TabBar
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: greyColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            labelColor: primeryColor,
            unselectedLabelColor: greyColor,
            labelStyle: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 14),
            tabs: [Tab(text: "Phone".tr), Tab(text: "Email".tr)],
            onTap: (index) => setState(() => loginType = index),
          ),
        ),
        const SizedBox(height: 30),
        // Input Title
        Text(
          loginType == 0 ? "Phone Number" : "Email Address",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: textcolor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        // Input Fields (Phone/Email)
        loginType == 0
            ? IntlPhoneField(
                controller: mobileController,
                style: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Enter mobile number",
                  hintStyle: TextStyle(color: greyColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: greyColor.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: greyColor.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primeryColor, width: 2),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) => ccode = phone.countryCode,
              )
            : TextFormField(
                controller: emailController,
                style: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Enter email address",
                  hintStyle: TextStyle(color: greyColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: greyColor.withOpacity(0.03),
                  prefixIcon: Icon(Icons.email_outlined, color: greyColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: greyColor.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primeryColor, width: 2),
                  ),
                ),
              ),
        const SizedBox(height: 20),
        // Password Field
        Text(
          "Password",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: textcolor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: passwordController,
          obscureText: obscureText,
          style: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16),
          decoration: InputDecoration(
            hintText: "Enter password",
            hintStyle: TextStyle(color: greyColor.withOpacity(0.5)),
            filled: true,
            fillColor: greyColor.withOpacity(0.03),
            prefixIcon: Icon(Icons.lock_outline_rounded, color: greyColor),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_rounded : Icons.remove_red_eye_rounded,
                color: greyColor,
                size: 20,
              ),
              onPressed: () => setState(() => obscureText = !obscureText),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: greyColor.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primeryColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 30),
        isLoading
            ? SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(0),
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStateProperty.all(
                      gradient.defoultColor.withOpacity(0.15),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: gradient.defoultColor,
                    size: 25,
                  ),
                ),
              )
            : button(
                text: "Continue",
                color: gradient.defoultColor,
                onPress: () {
                  if (loginType == 0) {
                    if (mobileController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      checkMobileController.checkMobileApi(
                        cCode: ccode,
                        phone: mobileController.text,
                      ).then((value) {
                        Map<String, dynamic> decodedValue = json.decode(value);
                        mobileCheck = decodedValue["Result"];
                        setState(() {});
                        if (mobileCheck = decodedValue["Result"] == false) {
                          if (mobileController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                            loginController.loginApi(
                              cCode: ccode,
                              phone: mobileController.text,
                              password: passwordController.text,
                              context: context,
                            ).then((_) {
                              setState(() {
                                isLoading = false;
                                mobileCheck = false;
                              });
                            }).catchError((_) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Enter valid Number...!!!");
                        }
                      }).catchError((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Enter Number...!!!");
                    }
                  } else {
                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      loginController.loginApi(
                        cCode: "",
                        phone: emailController.text,
                        password: passwordController.text,
                        context: context,
                      ).then((_) {
                        setState(() {
                          isLoading = false;
                          mobileCheck = false;
                        });
                      }).catchError((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    } else if (emailController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Email Address...!!!");
                    } else if (passwordController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Password...!!!");
                    }
                  }
                },
              ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            Get.offAllNamed(Routes.bottombarProScreen);
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: primeryColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                "Continue as guest",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: FontFamily.gilroyBold,
                  color: primeryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: InkWell(
            onTap: () {
              // Navigator.of(context).pop(); // No longer needed
              forgetPasswordBottom(context);
            },
            child: Text(
              "Forget Password?",
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 15,
                color: greyColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't Have an account yet?",
              style: TextStyle(
                fontFamily: FontFamily.gilroyRegular,
                fontSize: 15,
                color: textcolor,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                // Navigator.of(context).pop(); // No longer needed
                Get.to(() => const SignUpScreen());
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                  color: gradient.defoultColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}