import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carelinemed/controller_doctor/faq_list_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class FaqListScreen extends StatefulWidget {
  const FaqListScreen({super.key});

  @override
  State<FaqListScreen> createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {

  FaqListController faqListController = Get.put(FaqListController());

  @override
  void initState() {
    faqListController.faqListApi();
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
        title: Text(
          "Faq".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
      ),
      body: GetBuilder<FaqListController>(
        builder: (faqListController) {
          return faqListController.isLoading
          ? Center(child: CircularProgressIndicator(color: primeryColor))
          : faqListController.faqListModel!.faqList!.isNotEmpty
              ? Accordion(
                  disableScrolling: true,
                  flipRightIconIfOpen: true,
                  contentVerticalPadding: 0,
                  scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                  contentBorderColor: Colors.transparent,
                  maxOpenSections: 1,
                  headerBackgroundColorOpened: bgcolor,
                  headerPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  children: [
                    for (var j = 0; j < faqListController.faqListModel!.faqList!.length; j++)
                      AccordionSection(
                        rightIcon: Image.asset(
                          "assets/Arrow - Down.png",
                          height: 20,
                          width: 20,
                          color: gradient.defoultColor,
                        ),
                        headerPadding: const EdgeInsets.all(15),
                        headerBackgroundColor: bgcolor,
                        contentBorderColor: bgcolor,
                        header: Text(
                          "${faqListController.faqListModel!.faqList![j].title}",
                          style: TextStyle(
                            color: BlackColor,
                            fontSize: 15,
                            fontFamily: FontFamily.gilroyBold,
                          ),
                        ),
                        content: Text(
                          "${faqListController.faqListModel!.faqList![j].description}",
                          style: TextStyle(
                            color: greycolor,
                            fontSize: 14,
                            fontFamily: FontFamily.gilroyRegular,
                          ),
                        ),
                        contentHorizontalPadding: 20,
                        contentVerticalPadding: 10,
                        contentBorderWidth: 1,
                      ),
                  ],
                )
              : Center(
                  child: SizedBox(
                    width: Get.width / 1.5,
                    child: Text(
                      "Sorry, there are no faq available to display at this time".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 15,
                        color: BlackColor,
                      ),
                    ),
                  ),
                );
        }
      ),
    );
  }
}
