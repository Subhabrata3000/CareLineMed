import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/packages_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/lab/packge_detail_screen.dart';
import 'package:laundry/screen/lab/popular_tests_tab.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/custom_title.dart';

class AffordablePackagesTab extends StatefulWidget {
  const AffordablePackagesTab({super.key, required this.categoryId, required this.labId});
  final String categoryId;
  final String labId;

  @override
  State<AffordablePackagesTab> createState() => _AffordablePackagesTabState();
}

class _AffordablePackagesTabState extends State<AffordablePackagesTab> {

  PackagesController packagesController = Get.put(PackagesController());

  @override
  void initState() {
    setState(() {});
    debugPrint("--------- Affordab categoryId -------- ${widget.categoryId}");
    debugPrint("----------- Affordab labId ----------- ${widget.labId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            titlebar(
              title: "Recommended Packages",
            ),
            SizedBox(height: 10),
            Expanded(
              child: packagesController.packagesApiModel!.package!.isEmpty
              ? Center(
                  child: Image.asset(
                    "assets/emptyOrder.png",
                    height: Get.height / 5,
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: packagesController.packagesApiModel!.package!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return packageDetailsCustom(
                      onBook: () {
                        if (getData.read("UserLogin") == null) {
                          Get.offAll(BoardingPage());
                        } else {
                          packagesController.cartAffordableLoding[index] = true;
                          setState(() {});
                          packagesController.packageAddinCartApi(
                            labId: widget.labId,
                            pacakgeId: "${packagesController.packagesApiModel!.package![index].id}",
                          ).then((value) {
                            debugPrint("--------- value --------- $value");
                            if (value["Result"] == true) {
                              packagesController.packagesApi(
                                categoryId: widget.categoryId,
                                labId: widget.labId,
                              ).then((value1) {
                                if (value1["Result"] == true) {
                                  packagesController.cartAffordableLoding[index];
                                  setState(() {});
                                } 
                              });
                            }
                          });
                        }
                      },
                      isLoding: packagesController.cartAffordableLoding[index],
                      buttonColor: packagesController.packagesApiModel!.package![index].exist == 1 ? RedColor : gradient.defoultColor,
                      buttontext: packagesController.packagesApiModel!.package![index].exist == 1 ? "Remove" : "Book" ,
                      onTap: () => Get.to(PackgeDetailScreen(packageId: "${packagesController.packagesApiModel!.package![index].id}")),
                      image: "${packagesController.packagesApiModel!.package![index].logo}",
                      title: "${packagesController.packagesApiModel!.package![index].title}",
                      tests: "${packagesController.packagesApiModel!.package![index].packageName}",
                      price: "${packagesController.packagesApiModel!.package![index].packagePrice}",
                      fastingRequired: "${packagesController.packagesApiModel!.package![index].fastingRequire}",
                      testReportTime: "${packagesController.packagesApiModel!.package![index].testReportTime}",
                    );
                  }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                ),
            ),
          ],
        ),
      ),
    );
  }
}