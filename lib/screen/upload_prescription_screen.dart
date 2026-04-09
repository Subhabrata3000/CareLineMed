import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/custom_colors.dart';
import '../model/font_family_model.dart';
import 'home_screen.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() => _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Failed to pick image",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _showPickerChoices() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Upload Via", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: FontFamily.gilroyBold)),
            const SizedBox(height: 15),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primeryColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.camera_alt, color: primeryColor),
              ),
              title: const Text("Camera", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primeryColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.photo_library, color: primeryColor),
              ),
              title: const Text("Gallery", style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      )
    );
  }

  Future<void> _uploadPrescription() async {
    if (_imageFile == null) {
      Get.snackbar("Required", "Please select an image first", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading = false;
    });

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                child: Icon(Icons.check_circle, color: Colors.green.shade500, size: 60),
              ),
              const SizedBox(height: 20),
              const Text("Success!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: FontFamily.gilroyBold)),
              const SizedBox(height: 10),
              const Text(
                "Your prescription has been uploaded successfully. Our pharmacist will review it shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5, fontFamily: FontFamily.gilroyMedium),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primeryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Get.offAll(() => const HomeScreen());
                  },
                  child: const Text("Back To Home", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text("Upload Prescription", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: FontFamily.gilroyBold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please upload a clear image of your prescription to proceed with your order.",
              style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.5, fontFamily: FontFamily.gilroyMedium),
            ),
            const SizedBox(height: 30),
            
            // Upload Box
            GestureDetector(
              onTap: _showPickerChoices,
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primeryColor.withOpacity(0.3), width: 2, style: BorderStyle.solid),
                ),
                child: _imageFile != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(_imageFile!, fit: BoxFit.cover),
                          Container(color: Colors.black.withOpacity(0.3)),
                          const Center(
                            child: Icon(Icons.edit, color: Colors.white, size: 40),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: primeryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.cloud_upload_outlined, size: 50, color: primeryColor),
                        ),
                        const SizedBox(height: 20),
                        const Text("Tap to upload image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: FontFamily.gilroyBold)),
                        const SizedBox(height: 8),
                        Text("Supported formats: JPEG, PNG, JPG", style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: FontFamily.gilroyMedium)),
                      ],
                    ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Guidelines
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.shade100)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text("Valid Prescription Guide", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: FontFamily.gilroyBold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _guideItem(Icons.check_circle_outline, "Don't crop out any part of the image"),
                  const SizedBox(height: 8),
                  _guideItem(Icons.check_circle_outline, "Ensure doctor details and date are visible"),
                  const SizedBox(height: 8),
                  _guideItem(Icons.check_circle_outline, "Image should not be blurred"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
          ]
        ),
        child: SafeArea(
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primeryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              onPressed: _imageFile == null || _isUploading ? null : _uploadPrescription,
              child: _isUploading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Submit Prescription", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: FontFamily.gilroyBold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _guideItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green.shade600),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontFamily: FontFamily.gilroyMedium))),
      ],
    );
  }
}
