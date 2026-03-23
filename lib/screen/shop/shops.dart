// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/screen/shop/shop_detail_screen.dart';
import '../../Api/config.dart';
import '../../controller_doctor/category_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    categoryController.categoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: SvgPicture.asset(
            "assets/bottomIcons/medicine.svg",
            color: WhiteColor,
          ),
        ),
        title: Text(
          "Shops".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
          ),
        ),
      ),
      body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Shop by Categories".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyExtraBold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                            child: Stack(
                              children: [
                                GridView.builder(
                                  itemCount: categoryController.isLoading ? categoryController.categoryModel!.categoryList.length : 8,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: Get.height / 7.5),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent: 145,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if(categoryController.isLoading){
                                          Get.to(
                                            ShopDetails(
                                              serviceId: categoryController.categoryModel!.categoryList[index].id.toString(),
                                              name: categoryController.categoryModel!.categoryList[index].name,
                                              image: "${Config.imageBaseurlDoctor}${categoryController.categoryModel!.categoryList[index].image}",
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: bgcolor, width: 1.5),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: categoryController.isLoading
                                                    ?  FadeInImage.assetNetwork(
                                                        width: 72,
                                                        height: 72,
                                                        placeholder: "assets/ezgif.com-crop.gif",
                                                        image: "${Config.imageBaseurlDoctor}${categoryController.categoryModel!.categoryList[index].image}",
                                                        placeholderFit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        "assets/ezgif.com-crop.gif",
                                                        fit: BoxFit.cover,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              height: 40,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                image: categoryController.isLoading
                                                  ? null
                                                  : DecorationImage(
                                                      image: AssetImage("assets/ezgif.com-crop.gif"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                categoryController.isLoading ? categoryController.categoryModel!.categoryList[index].name : "",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: FontFamily.gilroyMedium,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if(categoryController.isLoading)...[
                                  if(categoryController.categoryModel!.categoryList.isEmpty)...[
                                    Center(
                                      child: SizedBox(
                                        width: Get.width / 1.8,
                                        child: Text(
                                          "The service is unavailable in your area.".tr,
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
