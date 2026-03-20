import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/controller/packages_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/screen/lab/affordable_packages_tab.dart';
import 'package:laundry/screen/lab/lab_package_cart_screen.dart';
import 'package:laundry/screen/lab/popular_tests_tab.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/button.dart';

class PackagesScreen extends StatefulWidget {
  final String title;
  final String categoryId;
  final String labId;
  const PackagesScreen({super.key, required this.title, required this.categoryId, required this.labId});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> with SingleTickerProviderStateMixin{

  late final TabController tabController;

  PackagesController packagesController = Get.put(PackagesController());

  int tab = 0;
  
  @override
  void initState() {
    debugPrint("----------- title ----------- ${widget.title}");
    debugPrint("--------- categoryId -------- ${widget.categoryId}");
    debugPrint("----------- labId ----------- ${widget.labId}");
    packagesController.isLoading = true;
    setState(() {
      tabController = TabController(length: 2, vsync: this);
    });
    packagesController.packagesApi(categoryId: widget.categoryId, labId: widget.labId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: BlackColor),
        title: Text(
          widget.title,
          maxLines: 1,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<PackagesController>(
        builder: (packagesController) {
          return  packagesController.isLoading
          ? SizedBox()
          : packagesController.packagesApiModel!.cartCheck! <= 0
            ? SizedBox()
            : Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/shopping-cart.png",
                    height: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${packagesController.packagesApiModel!.cartCheck} ${"Item in Cart".tr}",
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyBold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: Get.width / 2.3,
                    child: button(
                      height: 45,
                      onPress: () {
                        debugPrint("--------------- labId ----- sds --------- ${widget.labId}");
                        debugPrint("------------- categoryId -- sds --------- ${widget.categoryId}");
                        Get.to(
                          LabPackageCartScreen(
                            categoryId: widget.categoryId,
                            labId: widget.labId,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      text: "Proceed".tr,
                      color: gradient.defoultColor,
                    ),
                  ),
                ],
              ),
            );
        }
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                child: TabBar(
                  controller: tabController,
                  unselectedLabelColor: greyColor,
                  labelStyle: const TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                  ),
                  physics: BouncingScrollPhysics(),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: WhiteColor,
                  ),
                  labelColor: gradient.defoultColor,
                  onTap: (value) {
                    if (value == 0) {
                    } else {
                    }
                  },
                  tabs: [
                    Tab(text: "Popular Tests".tr),
                    Tab(text: "Affordable Packages",
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          GetBuilder<PackagesController>(
            builder: (packagesController) {
              return Expanded(
                child: packagesController.isLoading
                ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
                : TabBarView(
                    controller: tabController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      PopularTestsTab(categoryId: widget.categoryId, labId: widget.labId),
                      AffordablePackagesTab(categoryId: widget.categoryId, labId: widget.labId),
                    ],
                  ),
              );
            }
          ),
        ],
      ),
    );
  }
}
