// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:carelinemed/controller_doctor/forgot_password_controller.dart';
import 'package:carelinemed/controller_doctor/mobile_check_controller.dart';
import 'package:carelinemed/controller_doctor/msg_otp_controller.dart';
import 'package:carelinemed/controller_doctor/otp_get_controller.dart';
import 'package:carelinemed/controller_doctor/twilio_otp_controller.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../model/font_family_model.dart';
import '../../widget/button.dart';

ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
String ccode = "";

TextEditingController mobileController = TextEditingController();

bool isLoadingNumber = false;

Future forgetPasswordBottom(context) {
  mobileController.clear();
  CheckMobileController checkMobileController = Get.put(CheckMobileController());
  OtpGetController otpGetController = Get.put(OtpGetController());
  TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
    return Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            color: bgcolor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Number",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                    fontSize: 24,
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
                      letterSpacing: 0.3),
                  decoration:  InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                    hintText: "Enter mobile number",
                    hintStyle:  TextStyle(
                      fontFamily: FontFamily.gilroyRegular,
                      fontSize: 16,
                      color: greyColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    border:  OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:  const BorderSide(color: gradient.defoultColor,width: 1.5),
                        borderRadius: BorderRadius.circular(10)
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
                      ccode  = number.countryCode;
                    });
                  },
                ),

                const SizedBox(height: 15),


                isLoadingNumber
                    ? loaderButton()
                    : button(
                    text: "Continue", color: gradient.defoultColor,
                    onPress: () async {
                      if (mobileController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Enter mobile number....!!!");
                      } else {
                        if (isLoadingNumber == false) {
                          isLoadingNumber = true;
                          setState(() {});
                          checkMobileController.checkMobileApi(cCode: ccode, phone: mobileController.text).then((value) async {
                            Map<String, dynamic> decodedValue = json.decode(value);
                            debugPrint("============== decodedValue ============== $decodedValue");
                            if(decodedValue["Result"] == false){
  
                                otpGetController.otpGetApi(context: context).then((value) {
                                      if (value["Result"] == true && value["message"] == "MSG91") {
                                        msgOtpController.msgOtpApi(
                                          context: context,
                                          cCode: ccode,
                                          phone: mobileController.text,
                                        ).then((value) {
                                          Map<String, dynamic> msgOtp = json.decode(value);
                                          if (msgOtp["Result"] == true) {
                                            Get.back();
                                            isLoadingNumber = false;
                                            otpApi(context);
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
                                            Get.back();
                                            isLoadingNumber = false;
                                            otpApi(context);
                                            setState(() {});
                                          }
                                        });
                                      } else if (value["Result"] == true && value["message"] == "No Auth") {
                                        newPasswordBottom().then((value) {
                                          Get.back();
                                        });
                                        isLoadingNumber = false;
                                        setState(() {});
                                      } else {
                                        Fluttertoast.showToast(msg: "${value["message"]}");
                                        isLoadingNumber = false;
                                        setState(() {});
                                      }
                                    });
                            } else {
                              isLoadingNumber = false;
                              setState(() {});
                              Get.back();
                              Fluttertoast.showToast(msg: "PhoneNo not Register...!!!");
                            }
                          });
                        }
                      }
                    },
                ),
              ],
            ),
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}


OtpFieldController otpController = OtpFieldController();
String otpCode = "";

Future otpBottomFirebase(context,String verificationId){
  return Get.bottomSheet(
    StatefulBuilder(builder: (context, setState) {return Container(
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        color: bgcolor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15 ),
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
                  focusBorderColor: gradient.defoultColor
              ),
              fieldWidth: 45,
              keyboardType: TextInputType.number,
              outlineBorderRadius: 8,
              style: TextStyle(
                  fontFamily: FontFamily.gilroyRegular,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                  letterSpacing: 0.3),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onChanged: (value) {
                setState((){
                  otpCode = value;
                });
              },
              onCompleted: (pin) {

                setState((){
                  otpCode = pin;
                });
              },
            ),
            const SizedBox(height: 20),

            button(text: "VERIFY OTP", color: gradient.defoultColor,onPress: () async {
              try{
                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);
                var response = await auth.signInWithCredential(credential);
                if (response.user != null) {
                  newPasswordBottom().then((value) {
                    Get.back();
                  });
                }else{
                  Fluttertoast.showToast(msg: "OPT not valid",);
                }
              }catch(e){
                Fluttertoast.showToast(msg: e.toString(),);
              }

            }),
          ],
        ),
      ),
    );},),
    isScrollControlled: true,
  );
}

Future otpApi(context){
  return Get.bottomSheet(
    StatefulBuilder(builder: (context, setState) {return Container(
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        color: bgcolor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15 ),
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
                  focusBorderColor: gradient.defoultColor
              ),
              fieldWidth: 45,
              keyboardType: TextInputType.number,
              outlineBorderRadius: 8,
              style: TextStyle(
                  fontFamily: FontFamily.gilroyRegular,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                  letterSpacing: 0.3),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onChanged: (value) {
                setState((){
                  otpCode = value;
                });
              },
              onCompleted: (pin) {

                setState((){
                  otpCode = pin;
                });
              },
            ),
            const SizedBox(height: 20),

            button(text: "VERIFY OTP", color: gradient.defoultColor,onPress: () async {
                newPasswordBottom().then((value) {
                    Get.back();
                  });
            }),
          ],
        ),
      ),
    );},),
    isScrollControlled: true,
  );
}

FirebaseAuth auth = FirebaseAuth.instance;

TextEditingController newPassword = TextEditingController();
TextEditingController confirmPassword = TextEditingController();
bool obscureText = true;
bool obscureText1 = true;

Future newPasswordBottom() {
  newPassword.clear();
  confirmPassword.clear();
  return Get.bottomSheet(
    StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          color: bgcolor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Create A New Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textcolor,
                  fontFamily: 'urbani_extrabold',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: newPassword,
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
                  hintText: "New Password",
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
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: gradient.defoultColor,width: 1.5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: confirmPassword,
                obscureText: obscureText1,
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
                  hintText: "Confirm Password",
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
                          obscureText1 = !obscureText1;
                        });
                      },
                      child: obscureText1 == false ? Icon(Icons.remove_red_eye,color: Greycolor,size: 19) : Icon(Icons.visibility_off_rounded,color: Greycolor,size: 19)),
                  border:  OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: gradient.defoultColor,width: 1.5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),

              const SizedBox(height: 15),

              forgotPasswordController.isLoading
              ? loaderButton()
              : button(
                text: "Confirm",
                color: gradient.defoultColor,
                onPress: () {
                  if(newPassword.text == confirmPassword.text){
                    if (forgotPasswordController.isLoading == false) {
                      forgotPasswordController.isLoading = true;
                      setState(() {});
                      forgotPasswordController.forgotPasswordApi(
                        ccode: ccode,
                        phone: mobileController.text,
                        password: confirmPassword.text,
                      ).then((value) {
                        debugPrint("--------- value ------ $value");
                        Get.back();
                        forgotPasswordController.isLoading = false;
                        setState(() {});
                      });
                    }
                  }else{
                    Fluttertoast.showToast(msg: "Password did not match..!!!");
                  }
                }
              ),

            ],
          ),
        ),
      );
    },),
    isScrollControlled: true,
  );
}
