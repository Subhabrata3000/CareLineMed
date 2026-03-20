// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../controller_doctor/mobile_check_controller.dart';
import '../../controller_doctor/msg_otp_controller.dart';
import '../../controller_doctor/otp_get_controller.dart';
import '../../controller_doctor/signupcontroller.dart';
import '../../controller_doctor/twilio_otp_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import '../../widget/button.dart';

// Helper function retained for compatibility if needed, but navigates to the new screen
Future? signUpBottom(context) {
  return Get.to(() => const SignUpScreen());
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  bool obscureText = true;
  String ccode = "";
  bool isLoading = false;
  int selectedRole = 0; // 0 for Patient, 1 for Doctor

  final SignUpController signUpController = Get.put(SignUpController());
  final CheckMobileController checkMobileController = Get.put(CheckMobileController());
  final OtpGetController otpGetController = Get.put(OtpGetController());
  final TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());
  final MsgOtpController msgOtpController = Get.put(MsgOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: textcolor, size: 22),
                    ),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        color: textcolor,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance the back button
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Join Meet Doctor and start your health journey!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      color: greyColor,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                
                // Role Selection
                Text(
                  "Select your role",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    color: textcolor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: roleCard(
                        title: "Patient",
                        icon: Icons.person_outline_rounded,
                        isSelected: selectedRole == 0,
                        onTap: () => setState(() => selectedRole = 0),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: roleCard(
                        title: "Doctor",
                        icon: Icons.medical_services_outlined,
                        isSelected: selectedRole == 1,
                        onTap: () => setState(() => selectedRole = 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                buildInputField(
                  controller: nameController,
                  label: "Full Name",
                  hintText: "Enter your full name",
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 20),
                buildInputField(
                  controller: emailController,
                  label: "Email Address",
                  hintText: "Enter your email address",
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    color: textcolor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                IntlPhoneField(
                  controller: mobileController,
                  style: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
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
                  onChanged: (number) => ccode = number.countryCode,
                ),
                const SizedBox(height: 20),
                buildInputField(
                  controller: passwordController,
                  label: "Password",
                  hintText: "Create a password",
                  icon: Icons.lock_rounded,
                  isPassword: true,
                  obscureText: obscureText,
                  onToggleVisibility: () => setState(() => obscureText = !obscureText),
                ),
                const SizedBox(height: 20),
                buildInputField(
                  controller: referralController,
                  label: "Referral Code",
                  hintText: "Enter referral code (optional)",
                  icon: Icons.card_giftcard_rounded,
                ),
                const SizedBox(height: 35),

                isLoading
                    ? loaderButton()
                    : button(
                        text: "Continue",
                        color: gradient.defoultColor,
                        onPress: () async {
                          if (nameController.text.isEmpty || emailController.text.isEmpty || mobileController.text.isEmpty || passwordController.text.isEmpty) {
                            Fluttertoast.showToast(msg: "Please fill all details!");
                          } else {
                            setState(() => isLoading = true);
                            checkMobileController.checkMobileApi(cCode: ccode, phone: mobileController.text).then(
                              (value) async {
                                Map<String, dynamic> decodedValue = json.decode(value);
                                if (decodedValue["Result"] == true) {
                                    otpGetController.otpGetApi(context: context).then((value) {
                                      if (value["Result"] == true && value["message"] == "MSG91") {
                                        msgOtpController.msgOtpApi(
                                          context: context,
                                          cCode: ccode,
                                          phone: mobileController.text,
                                        ).then((value) {
                                          Map<String, dynamic> msgOtp = json.decode(value);
                                          if (msgOtp["Result"] == true) {
                                            isLoading = false;
                                            otpApi(context: context, otpCodeMatch: msgOtp["otp"].toString());
                                            setState(() {});
                                          }
                                        });
                                      } else if (value["Result"] == true && value["message"] == "Twilio") {
                                        twilioOtpController.twilioOtpApi(
                                          context: context,
                                          cCode: ccode,
                                          phone: mobileController.text,
                                        ).then((value) {
                                          Map<String, dynamic> twilioOtp = json.decode(value);
                                          if (twilioOtp["Result"] == true) {
                                            isLoading = false;
                                            otpApi(context: context, otpCodeMatch: "${twilioOtp["otp"]}");
                                            setState(() {});
                                          }
                                        });
                                      } else if (value["Result"] == true && value["message"] == "No Auth") {
                                        signUpController.sighUpApi(
                                          context: context,
                                          name: nameController.text,
                                          email: emailController.text,
                                          cCode: ccode,
                                          phone: mobileController.text,
                                          password: passwordController.text,
                                          referralCode: referralController.text
                                        ).then((value) {
                                          nameController.clear();
                                          emailController.clear();
                                          mobileController.clear();
                                          passwordController.clear();
                                          referralController.clear();
                                          ccode = "";
                                        });
                                        isLoading = false;
                                        setState(() {});
                                      }
                                    });
                                } else {
                                  setState(() => isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(decodedValue["message"]), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget roleCard({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primeryColor : WhiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primeryColor : greyColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primeryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : primeryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : primeryColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: isSelected ? Colors.white : textcolor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: textcolor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: greyColor.withOpacity(0.5)),
            filled: true,
            fillColor: greyColor.withOpacity(0.03),
            prefixIcon: Icon(icon, color: greyColor),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off_rounded : Icons.remove_red_eye_rounded,
                      color: greyColor,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
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
      ],
    );
  }

  final OtpFieldController otpController = OtpFieldController();
  String otpCode = "";

  Future otpFirebase(context, String verificationId) {
    return Get.bottomSheet(
      GetBuilder<SignUpController>(
        builder: (signUpController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: bgcolor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Awesome",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textcolor,
                          fontFamily: 'urbani_extrabold',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "We have sent the OTP to $ccode ${mobileController.text}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          fontFamily: FontFamily.gilroyRegular,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OTPTextField(
                        length: 6,
                        controller: otpController,
                        width: MediaQuery.of(context).size.width,
                        otpFieldStyle: OtpFieldStyle(
                          disabledBorderColor: greyColor,
                          enabledBorderColor: greyColor,
                          focusBorderColor: gradient.defoultColor,
                        ),
                        fieldWidth: 45,
                        keyboardType: TextInputType.number,
                        outlineBorderRadius: 8,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyRegular,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          letterSpacing: 0.3,
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otpCode = pin;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      signUpController.isLoading
                          ? loaderButton()
                          : button(
                              text: "VERIFY OTP",
                              color: gradient.defoultColor,
                              onPress: () async {
                                try {
                                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);
                                  var response = await auth.signInWithCredential(credential);
                                  if (response.user != null) {
                                    signUpController.sighUpApi(
                                      cCode: ccode,
                                      email: emailController.text,
                                      context: context,
                                      name: nameController.text,
                                      password: passwordController.text,
                                      phone: mobileController.text,
                                      referralCode: referralController.text
                                    ).then((value) {
                                      nameController.clear();
                                      emailController.clear();
                                      mobileController.clear();
                                      passwordController.clear();
                                      referralController.clear();
                                      ccode = "";
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "OTP not valid",
                                    );
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Future otpApi({required context, required String otpCodeMatch}) {
    return Get.bottomSheet(
      GetBuilder<SignUpController>(
        builder: (signUpController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: bgcolor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Awesome",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textcolor,
                          fontFamily: 'urbani_extrabold',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "We have sent the OTP to $ccode ${mobileController.text}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          fontFamily: FontFamily.gilroyRegular,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OTPTextField(
                        length: 6,
                        controller: otpController,
                        width: MediaQuery.of(context).size.width,
                        otpFieldStyle: OtpFieldStyle(
                          disabledBorderColor: greyColor,
                          enabledBorderColor: greyColor,
                          focusBorderColor: gradient.defoultColor,
                        ),
                        fieldWidth: 45,
                        keyboardType: TextInputType.number,
                        outlineBorderRadius: 8,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyRegular,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          letterSpacing: 0.3,
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otpCode = pin;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      signUpController.isLoading
                          ? loaderButton()
                          : button(
                              text: "VERIFY OTP",
                              color: gradient.defoultColor,
                              onPress: () async {
                                if (otpCode.isNotEmpty) {
                                  if (otpCodeMatch == otpCode) {
                                    signUpController.sighUpApi(
                                      context: context,
                                      name: nameController.text,
                                      email: emailController.text,
                                      cCode: ccode,
                                      phone: mobileController.text,
                                      password: passwordController.text,
                                      referralCode: referralController.text
                                    ).then((value) {
                                      nameController.clear();
                                      emailController.clear();
                                      mobileController.clear();
                                      passwordController.clear();
                                      referralController.clear();
                                      ccode = "";
                                    });
                                    isLoading = false;
                                    setState(() {});
                                  } else {
                                    Fluttertoast.showToast(msg: "Enter Correct OTP".tr);
                                  }
                                } else {
                                  Fluttertoast.showToast(msg: "Enter OTP");
                                }
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

final FirebaseAuth auth = FirebaseAuth.instance;
