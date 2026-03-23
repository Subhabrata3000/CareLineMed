import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller_doctor/book_vital_physical_controller.dart';

import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import '../../widget/button.dart';


class VitalScreen extends StatefulWidget {
  final String appointmentID;
  final String patientId;
  const VitalScreen({super.key, required this.appointmentID, required this.patientId});

  @override
  State<VitalScreen> createState() => _VitalScreenState();
}

class _VitalScreenState extends State<VitalScreen> {

  BookVitalPhysicalController bookVitalPhysicalController = Get.put(BookVitalPhysicalController());

  @override
  void initState() {
    bookVitalPhysicalController.bookVitalListApi(appointmentId: widget.appointmentID.toString(),patientId: widget.patientId.toString());
    super.initState();
  }

  @override
  void dispose() {
    bookVitalPhysicalController.isLoading = false;
    super.dispose();
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
          "Virtual and Physical",
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            fontFamily: FontFamily.gilroyBold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        elevation: 0,
      ),
      body: GetBuilder<BookVitalPhysicalController>(
          builder: (bookVitalPhysicalController) {
            return bookVitalPhysicalController.isLoading
                ? bookVitalPhysicalController.bookVitalPhysicalModel!.vitPhyList.isNotEmpty
                ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookVitalPhysicalController.bookVitalPhysicalModel!.vitPhyList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return textfield2(
                          readOnly: true,
                          type: bookVitalPhysicalController.bookVitalPhysicalModel!.vitPhyList[index].title,
                          controller: bookVitalPhysicalController.controllers[index],
                          labelText: bookVitalPhysicalController.bookVitalPhysicalModel!.vitPhyList[index].title,
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
