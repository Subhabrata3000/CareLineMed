import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controller_doctor/appointment_diagnosis_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';



class DiagnosisScreen extends StatefulWidget {
  final String appointmentID;
  final String patientId;
  const DiagnosisScreen({super.key, required this.appointmentID, required this.patientId});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {

  BookDiagnosisController bookDiagnosisController = Get.put(BookDiagnosisController());

  @override
  void initState() {
    bookDiagnosisController.bookDiagnosisListApi(appointmentId: widget.appointmentID.toString(),patientId: widget.patientId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Diagnosis Test",
          maxLines: 2,
          style: TextStyle(
            fontSize: 16,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        elevation: 0,
        backgroundColor: WhiteColor,
      ),
      body: GetBuilder<BookDiagnosisController>(
          builder: (bookVitalPhysicalController) {
            return bookVitalPhysicalController.isLoading
                ? bookDiagnosisController.appointmentDiagnosisModel!.appoint.isNotEmpty
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
                      itemCount: bookDiagnosisController.appointmentDiagnosisModel!.appoint.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset("assets/diagnosis.svg"),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bookVitalPhysicalController.appointmentDiagnosisModel!.appoint[index].name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      bookVitalPhysicalController.appointmentDiagnosisModel!.appoint[index].description,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FontFamily.gilroyRegular,
                                        color: BlackColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
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
