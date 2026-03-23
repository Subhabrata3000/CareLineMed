import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/home_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/widget/button.dart';
import '../Api/config.dart';
import '../model/checkout_model.dart';
import '../screen/bottombarpro_screen.dart';

class CheckOutController extends GetxController implements GetxService {

  CheckOutModel? checkOutModel;

  String addresTitle = "";
  String addressId = "";

  List coverimagepath = [];
  String image = "";
  int prescriptionRequire = 0;

  double total = 0;
  double subtotal = 0;

  var tempWallet = 0.0;
  var useWallet = 0.0;
  int couponAmt = 0;
  double commission = 0;
  double salesTax = 0;
  double sitterCharge = 0;

  int paymentSelect = 0;

  String couponId = "";

  bool isLoading = false;

  bool isOrderLoading = false;

  setOrderLoading() {
    isOrderLoading = true;
    update();
  }

  setOrderLoadingOff() {
    isOrderLoading = false;
    update();
  }

  changeIndex(int index) {
    currentIndexBottom = index;
    update();
  }

  Future checkOutApi({required String sitterId}) async {
    prescriptionRequire = 0;
    update();
    Map body = {
      "uid": "${getData.read("UserLogin")["id"]}",
      "doctor_id": sitterId,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.checkOutList),body: jsonEncode(body),headers: userHeader);

    debugPrint("=========== check Out api body ============= $body");
    debugPrint("=========== check Out api url ============== ${Config.baseUrlDoctor + Config.checkOutList}");
    debugPrint("========= check Out api respons ============ ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if(data["Result"] == true){
        checkOutModel = checkOutModelFromJson(response.body);
        if(checkOutModel!.result == true){
          tempWallet = double.parse(checkOutModel!.walletAmount.toString());
          subtotal = double.parse(checkOutModel!.totPrice.toString());
          commission = checkOutModel!.comData!.commisiionType == "fix"
              ? double.parse("${checkOutModel!.comData!.commissionRate}")
              : subtotal * double.parse("${checkOutModel!.comData!.commissionRate}") / 100;
          for(int i = 0; i < checkOutModel!.productList!.length; i++){
            if (checkOutModel!.productList![i].prescriptionRequire == "Required") {
              prescriptionRequire++;
            }
          }
          debugPrint("========== prescriptionRequire ========== $prescriptionRequire");
          debugPrint("============== commission =============== $commission");
          debugPrint("=============== subtotal ================ $subtotal");
          salesTax = subtotal * 0.05; // Added 5% Sales Tax 
          debugPrint("============== salesTax =============== $salesTax");
          total = subtotal + commission + salesTax;
          isLoading = true;
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: checkOutModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }

  Future addPatientApi({required context, required String doctorId, required List images}) async {

    var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrlDoctor + Config.addPatientPrescription));
    request.fields.addAll({
      "uid" : getData.read("UserLogin")["id"].toString(),
      "doctor_id" : doctorId,
    });

    for (int i = 0; i < images.length; i++) {
      debugPrint(":|:|:|:|:|:|:|:|: image name :|:|:|:|:|:|:|:|: ${images[i]}");
      request.files.add(await http.MultipartFile.fromPath('image', images[i]),);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseBody);
      debugPrint("---------------- response ----------------: $data");
      debugPrint("------------- request fields -------------: ${request.fields}");

      if(data["Result"] == true) {
        update();
        return data;
      } else {
        snackBar(context: context, text: "${data["message"]}");
        update();
      }
    } else {
      debugPrint(response.reasonPhrase);
      snackBar(context: context, text: "SomeThing Went Wrong");
    }
  }

  Future getImage(ImageSource img, BuildContext context) async {
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      File selectedFile = File(pickedFile.path);
      coverimagepath.add(selectedFile.path);
      image = "";
      debugPrint("----------- coverimagepath ----------- $coverimagepath");
      Get.back();

    } else {
      Fluttertoast.showToast(msg: "Nothing is selected");
      Get.back();
    }
    update();
  }

  Future showPicker({required BuildContext context}) {
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
                          getImage(ImageSource.gallery,context);
                          update();
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
                        onPressed: () {
                          getImage(ImageSource.camera,context);
                          update();
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

}
