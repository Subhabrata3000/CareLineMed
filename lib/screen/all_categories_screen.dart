import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller_doctor/home_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/category_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text(
          "Our Services",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: WhiteColor,
          ),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          if (!homeController.isLoading || homeController.homeModel == null) {
            return Center(child: CircularProgressIndicator(color: primeryColor));
          }

          final departments = homeController.homeModel!.departmentList!;

          if (departments.isEmpty) {
            return const Center(child: Text("No services available"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              mainAxisExtent: 135,
            ),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final item = departments[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => CategoryScreen(
                    departmentId: item.id.toString(),
                    name: item.name ?? "",
                    image: "${Config.imageBaseurlDoctor}${item.image}",
                  ));
                },
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Hero(
                        tag: "dept_${item.id}",
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          image: "${Config.imageBaseurlDoctor}${item.image}",
                          fit: BoxFit.contain,
                          imageErrorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.medical_services_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.name ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 13,
                        color: Color(0xFF2E3E5C),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
