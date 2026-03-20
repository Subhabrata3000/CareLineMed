import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/patient_health_model.dart';

class PatientHealthController extends GetxController implements GetxService {

  PatientHealthModel? patientHealthModel;
  bool isLoading = false;
  List documentList = [];

  List<File> galleryFiles = []; // Selected images & PDFs
  List<XFile> xFileImages = [];// Existing files from API

  final ImagePicker picker = ImagePicker();

  TextEditingController diseaseController = TextEditingController();

  patientHealthApi({required String appointmentId, required String familyId}) async{

    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "fam_mem_id": familyId
    };

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.patentHealth),body: jsonEncode(body),headers: userHeader);


    debugPrint("patientHealthApi BODY:- ${response.body}");
    debugPrint("patientHealthApi BODY:- $body");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        patientHealthModel = patientHealthModelFromJson(response.body);
        if(patientHealthModel!.result == true){
          diseaseController.text = patientHealthModel!.healthConcern != "" ? patientHealthModel!.healthConcern : "";
          documentList.clear();
          documentList.addAll(patientHealthModel!.document);
          debugPrint("*********************************************** $documentList");
          isLoading = true;
          update();
        }else{
          Fluttertoast.showToast(msg: patientHealthModel!.message.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }



  Future<void> selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Allow images & PDFs
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        double fileSizeMB = file.size / (1024 * 1024); // Convert bytes to MB

        if (fileSizeMB > 20) {
          Get.snackbar("Error", "${file.name} is larger than 20MB");
          continue;
        }

        if (file.extension == "pdf") {
          documentList.add(file.path!);
          galleryFiles.add(File(file.path!)); // Store PDF separately if needed
        } else {
          documentList.add(file.path!);
          galleryFiles.add(File(file.path!)); // Store images
        }
      }
      update();
    }
  }

  Future<void> selectPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow images & PDFs
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        double fileSizeMB = file.size / (1024 * 1024); // Convert bytes to MB

        if (fileSizeMB > 20) {
          Get.snackbar("Error", "${file.name} is larger than 20MB");
          continue;
        }

        if (file.extension == "pdf") {
          documentList.add(file.path!);
          galleryFiles.add(File(file.path!)); // Store PDF separately if needed
        } else {
          documentList.add(file.path!);
          galleryFiles.add(File(file.path!)); // Store images
        }
      }
      update();
    }
  }

  // Remove a file
  void removeFile(int index, {bool fromApi = false}) {
    if (fromApi) {
      documentList.removeAt(index);
    } else {
      galleryFiles.removeAt(index);
      xFileImages.removeAt(index);
    }
    update();
  }


  bool isLoadingApi = false;

  // Upload files to API
  Future<void> addHealthApi({required String appointmentId, required String familyId}) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Config.baseUrlDoctor + Config.addPatentHealth),
    );

    request.fields.addAll({
      'id': getData.read("UserLogin")["id"].toString(),
      'appointment_id': appointmentId,
      'fam_mem_id': familyId,
      'health_concern': diseaseController.text,
    });

    // Iterate through documentList and check if it's a local file or an API file
    for (var file in documentList) {
      if (!file.startsWith("uploads/")) {
        // Local file, add it to request as a multipart file
        request.files.add(
          await http.MultipartFile.fromPath('document', file),
        );
        debugPrint("Uploading File: $file");
      } else {
        debugPrint("API File: $file");
      }
    }

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = jsonDecode(responseBody);
        debugPrint("API Response: $data");

        if (data["Result"] == true) {
          // Fetch updated data
          isLoadingApi = false;
          Get.back();
          patientHealthApi(appointmentId: appointmentId, familyId: familyId);
          Fluttertoast.showToast(msg: "${data["message"]}");
          update();
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        debugPrint(response.reasonPhrase);
        Fluttertoast.showToast(msg: "Error uploading files. Check backend.");
        isLoadingApi = false;
        update();
      }
    } catch (e) {
      debugPrint("Error: $e");
      isLoadingApi = false;
      update();
    } finally {
      isLoadingApi = false;
      update();
    }
  }

  deleteHealthApi({required String appointmentId, required String familyId,required String image}) async{
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "fam_mem_id": familyId,
      "removed_image": image
    };

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.deletePatentHealth),body: jsonEncode(body),headers: userHeader);


    debugPrint("deleteHealthApi- ${response.body}");
    debugPrint("deleteHealthApi:- $body");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        Fluttertoast.showToast(msg: "${data["message"]}");
        patientHealthApi(appointmentId: appointmentId, familyId: familyId);
        update();
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}