import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class LabBookingDetailsScreen extends StatefulWidget {
  const LabBookingDetailsScreen({
    super.key,
    required this.labBookId,
    required this.labName,
    required this.date,
    required this.price,
    required this.status,
    required this.logo,
  });

  final String labBookId;
  final String labName;
  final String date;
  final String price;
  final String status;
  final String logo;

  @override
  State<LabBookingDetailsScreen> createState() => _LabBookingDetailsScreenState();
}

class _LabBookingDetailsScreenState extends State<LabBookingDetailsScreen> {
  var currency = "";

  @override
  void initState() {
    currency = getData.read("currency") ?? "₹";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Determine status color and icon
    Color statusColor = widget.status == "Pending"
        ? yelloColor
        : widget.status == "Accepted"
            ? orangeColor
            : widget.status == "Assign Collector"
                ? blueColor
                : widget.status == "Ongoing"
                    ? Darkblue2
                    : widget.status == "Completed" || widget.status == "Success"
                        ? green1Color
                        : RedColor;

    IconData statusIcon = widget.status == "Completed" || widget.status == "Success"
        ? Icons.check_circle_outline
        : widget.status == "Pending"
            ? Icons.access_time
            : Icons.info_outline;

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgcolor,
        titleSpacing: 0,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Booking Confirmation".tr,
          style: TextStyle(
            color: BlackColor,
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // React-like Success Icon Area
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  statusIcon,
                  size: 50,
                  color: statusColor,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text(
              "Booking ${widget.status}!".tr,
              style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyExtraBold,
                fontSize: 26,
                letterSpacing: -0.5,
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              "Your lab test sample collection with ${widget.labName} has been successfully scheduled.".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: greycolor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Details Card
            Container(
              width: Get.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booking Details".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            color: statusColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  ),
                  
                  // Detail Rows
                  _buildDetailRow("Appointment ID".tr, "#${widget.labBookId}"),
                  const SizedBox(height: 15),
                  _buildDetailRow("Schedule Date".tr, widget.date),
                  const SizedBox(height: 15),
                  _buildDetailRow("Total Amount".tr, "$currency${widget.price}"),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  ),
                  
                  // Lab Info
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/ezgif.com-crop.gif",
                            image: "${Config.imageBaseurlDoctor}${widget.logo}",
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.local_hospital, color: gradient.defoultColor);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Laboratory".tr,
                              style: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.labName,
                              style: TextStyle(
                                color: BlackColor,
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: gradient.defoultColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.defoultColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ]
                      ),
                      child: Center(
                        child: Text(
                          "Back to My Bookings".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: greycolor,
              fontFamily: FontFamily.gilroyMedium,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: BlackColor,
              fontFamily: FontFamily.gilroyBold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
