import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/controller_doctor/notification_controller.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController = Get.put(NotificationController());

  @override
  void initState() {
    notificationController.isLoading = true;
    setState(() {});
    notificationController.notificationLiatApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        iconTheme: IconThemeData(color: textcolor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notification".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<NotificationController>(
        builder: (notificationController) {
          return notificationController.isLoading
              ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
              : notificationController.notificationListApiModel!.nlist!.isNotEmpty
                  ? ListView.separated(
                      itemCount: notificationController.notificationListApiModel!.nlist!.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${notificationController.notificationListApiModel!.nlist![index].date}",
                                    style: TextStyle(
                                      color: textcolor,
                                      fontFamily: FontFamily.gilroyBold,
                                    ),
                                  ),
                                  Text(
                                    "#${notificationController.notificationListApiModel!.nlist![index].orderId}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: primeryColor,width: 2)
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/Notification.svg",
                                    ),
                                    
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if ("${notificationController.notificationListApiModel!.nlist![index].serviceUname}" != "") ...[
                                          Text(
                                            "${notificationController.notificationListApiModel!.nlist![index].serviceUname}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: FontFamily.gilroyBold,
                                              color: BlackColor,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                        Text(
                                          "${notificationController.notificationListApiModel!.nlist![index].notification}",
                                          style: TextStyle(
                                            color: greytext,
                                            fontFamily: FontFamily.gilroyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                    )
                  : Center(
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          "We'll let you know when we get news for you".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: greytext,
                            fontFamily: FontFamily.gilroyBold,
                          ),
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
