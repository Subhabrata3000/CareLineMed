import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/screen/shop/product.dart';
import '../../controller_doctor/store_list_controller.dart';
import '../../model/font_family_model.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/utils/custom_colors.dart';

class ShopDetails extends StatefulWidget {
  final String name;
  final String image;
  final String serviceId;
  const ShopDetails({
    super.key,
    required this.name,
    required this.image,
    required this.serviceId,
  });

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  StoreListController storeListController = Get.put(StoreListController());
  @override
  void initState() {
    storeListController.isLoading = false;
    setState(() {});
    storeListController.storeListApi(serviceId: widget.serviceId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    storeListController.isLoading = false;
  }

  final double expandedHeight = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: BlackColor),
        centerTitle: true,
        title: Text(
          widget.name,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 0.4,
            fontFamily: FontFamily.gilroyBold,
            fontSize: 20,
          ),
        ),
      ),
      body: GetBuilder<StoreListController>(
        builder: (storeListController) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: WhiteColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: storeListController.isLoading
                      ? Stack(
                          children: [
                            ListView.separated(
                              itemCount: storeListController.storeListModel!.storeList!.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              separatorBuilder: (context, index) => SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                debugPrint("------------ lat ----------- $lat");
                                debugPrint("----------- long ----------- $long");
                                debugPrint("---------- lat api --------- ${storeListController.storeListModel!.storeList![index].latitude}");
                                debugPrint("--------- long api --------- ${storeListController.storeListModel!.storeList![index].longitude}");
                                storeListController.distanceInMeters = storeListController.calculateDistance(
                                  startLat: lat,
                                  startLng: long,
                                  endLat: double.parse("${storeListController.storeListModel!.storeList![index].latitude}"),
                                  endLng: double.parse("${storeListController.storeListModel!.storeList![index].longitude}"),
                                );
                                storeListController.distanceInKm = storeListController.distanceInMeters / 1000;
                                debugPrint("--------- distanceInMeters --------- ${storeListController.distanceInMeters}");
                                debugPrint("----------- distanceInKm ----------- ${storeListController.distanceInKm}");
                                return InkWell(
                                  onTap: () async {
                                    save("changeIndex", true);
                                    Get.to(
                                      ProductScreen(
                                        categoryId: widget.serviceId.toString(),
                                        title: "${storeListController.storeListModel!.storeList![index].name}",
                                        doctorId: "${storeListController.storeListModel!.storeList![index].id}",
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: Get.size.width,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      border: Border.all(
                                        color: bordercolor,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(13),
                                          child: FadeInImage.assetNetwork(
                                            height: 80,
                                            width: 80,
                                            fadeInCurve: Curves.easeInCirc,
                                            placeholder: "assets/ezgif.com-crop.gif",
                                            placeholderCacheHeight: 70,
                                            placeholderCacheWidth: 70,
                                            placeholderFit: BoxFit.cover,
                                            image: "${Config.imageBaseurlDoctor}${storeListController.storeListModel!.storeList![index].image}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${storeListController.storeListModel!.storeList![index].name}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 17,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${storeListController.storeListModel!.storeList![index].address}",
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/destination.svg",
                                                    color: BlackColor,
                                                    height: 15,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      "${storeListController.distanceInKm.toStringAsFixed(2)} KM",
                                                      style: TextStyle(
                                                        color: greycolor,
                                                        fontFamily: FontFamily.gilroyMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (storeListController.isLoading) ...[
                              if (storeListController.storeListModel!.storeList!.isEmpty) ...[
                                Center(
                                  child: SizedBox(
                                    width: Get.width / 2.5,
                                    child: Text(
                                      'No store available in your area.'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 15,
                                        color: BlackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        )
                      : ListView.separated(
                          itemCount: 5,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(10),
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              width: Get.size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                border: Border.all(
                                  color: bordercolor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      "assets/ezgif.com-crop.gif",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.asset(
                                            "assets/ezgif.com-crop.gif",
                                            height: 20,
                                            width: Get.width / 2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            "assets/ezgif.com-crop.gif",
                                            height: 30,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.asset(
                                            "assets/ezgif.com-crop.gif",
                                            height: 15,
                                            width: Get.width / 3,
                                            fit: BoxFit.cover,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
