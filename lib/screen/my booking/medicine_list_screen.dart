// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller_doctor/book_medicine_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import 'medicine_detail.dart';


class MedicineListScreen extends StatefulWidget {
  final String appointmentID;
  final String patientId;
  const MedicineListScreen({super.key, required this.appointmentID, required this.patientId});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {

  BookMedicineController bookMedicineController = Get.put(BookMedicineController());

  @override
  void initState() {
    bookMedicineController.bookMedicineListApi(appointmentId: widget.appointmentID,patientId: widget.patientId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: WhiteColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Medicine",
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            fontFamily: FontFamily.gilroyBold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        elevation: 0,
      ),
      body: GetBuilder<BookMedicineController>(
          builder: (bookMedicineController) {
            return bookMedicineController.isLoading
                ? bookMedicineController.medicineListModel!.drugPresciption.isNotEmpty
                ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookMedicineController.medicineListModel!.drugPresciption.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            // Get.to(MedicineDetailScreen(data: bookMedicineController.medicineListModel!.drugPresciption[index]));
                            medicinceDetail(context, data: bookMedicineController.medicineListModel!.drugPresciption[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${bookMedicineController.medicineListModel!.drugPresciption[index].medicineName} ${bookMedicineController.medicineListModel!.drugPresciption[index].type}",
                                        // maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: BlackColor,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SvgPicture.asset("assets/capsule-svgrepo-com 1.svg"),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      bookMedicineController.medicineListModel!.drugPresciption[index].type,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: greyColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      bookMedicineController.medicineListModel!.drugPresciption[index].dosage,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: greyColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      bookMedicineController.medicineListModel!.drugPresciption[index].days,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.24),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            bookMedicineController.medicineListModel!.drugPresciption[index].time,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: FontFamily.gilroyMedium,
                                              color: Colors.red,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      bookMedicineController.medicineListModel!.drugPresciption[index].frequency,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "View Details",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: primeryColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/emptyOrder.png")),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No Virtual & Physical placed!",
                    style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        color: BlackColor,
                        fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Go and add Virtual & Physical",
                    style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        color: greyColor),
                  ),
                ],
              ),
            )
                : Center(child: CircularProgressIndicator(color: primeryColor));
          }
      ),
    );
  }
}
