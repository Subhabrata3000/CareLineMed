import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import '../../model/font_family_model.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import '../controller_doctor/doctor_detail_controller.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {

  TabController? tabController;

  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: overViewWidget(),
      ),
    );
  }

  Widget overViewWidget() {
    return GetBuilder<DoctorDetailController>(
        builder: (doctorDetailController) {
      return doctorDetailController.doctorDetailModel!.aboutData!.isEmpty
          ? Center(
        child: Text(
          "Sorry, there are no about \nto display at this time".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 15,
          ),
        ),
      )
          : Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${doctorDetailController.doctorDetailModel!.doctor!.address}",
                            maxLines: 1,
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: doctorDetailController.doctorDetailModel!.aboutData!.length,
                  itemBuilder: (context, index1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${index1 + 1}. ${doctorDetailController.doctorDetailModel!.aboutData![index1].head}",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyExtraBold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "${doctorDetailController.doctorDetailModel!.aboutData![index1].description}",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${doctorDetailController.doctorDetailModel!.aboutData![index1].title}",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: doctorDetailController.doctorDetailModel!.aboutData![index1].about!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].subtitle!.isNotEmpty
                                    ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                       image: DecorationImage(
                                         fit: BoxFit.cover,
                                         image: NetworkImage("${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].icon}"),
                                       ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        "${doctorDetailController.doctorDetailModel!.aboutData![index1].about![index].subtitle}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ) : SizedBox(),
                                SizedBox(height: 5),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget catDRow({String? img, text}) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Image.asset(
            img ?? "",
            height: 15,
            width: 15,
            color: BlackColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
