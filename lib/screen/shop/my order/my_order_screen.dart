import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller_doctor/shop_order_cancel_controller.dart';
import 'package:carelinemed/screen/shop/my%20order/store_wise_screen.dart';
import '../../../Api/config.dart';
import '../../../controller/shop_order_detail_controller.dart';
import '../../../controller/myorder_list_controller.dart';
import '../../../model/font_family_model.dart';
import '../../../utils/custom_colors.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> with TickerProviderStateMixin {
  MyOrderListController myOrderListController = Get.put(MyOrderListController());
  ShopOrderCancelController shopOrderCancelController = Get.put(ShopOrderCancelController());

  var currency;
  TabController? _tabController;
  final note = TextEditingController();
  String rejectmsg = "";
  String cancelId = "";

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _function();
    super.initState();
    _tabController?.index == 0;
    if (_tabController?.index == 0) {}
  }

  _function() async {
    currency = getData.read("currency");
    myOrderListController.myOrderListApi(uid: "${getData.read("UserLogin")["id"]}");
    setState(() {});
  }

  @override
  void dispose() {
    myOrderListController.isLoading = false;
    _tabController?.dispose();
    super.dispose();
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
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: WhiteColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "My Order".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
          ),
        ),
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
                  controller: _tabController,
                  unselectedLabelColor: greyColor,
                  labelStyle: const TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 15,
                  ),
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
                    Tab(text: "Current Order".tr),
                    Tab(text: "Past Order".tr),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                currentOrder(),
                pastOrder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget currentOrder() {
    ShopOrderDetailController shopOrderDetailController = Get.put(ShopOrderDetailController());
    return GetBuilder<MyOrderListController>(builder: (myOrderListController) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: myOrderListController.isLoading
            ? myOrderListController.myOrderListModel!.running!.isNotEmpty
                ? ListView.builder(
                    itemCount: myOrderListController.myOrderListModel!.running!.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          shopOrderDetailController.shopOrderDetailApi(
                            uid: "${getData.read("UserLogin")["id"]}",
                            orderId: "${myOrderListController.myOrderListModel!.running![index].id}",
                            doctorId: "${myOrderListController.myOrderListModel!.running![index].doctorId}",
                          );
                          Get.to(StoreWiseScreen(
                            orderId: myOrderListController.myOrderListModel!.running![index].id.toString(),
                            doctorId: myOrderListController.myOrderListModel!.running![index].doctorId.toString(),
                            statusSummary: myOrderListController.myOrderListModel!.running![index].status.toString(),
                            totPriceSummary: myOrderListController.myOrderListModel!.running![index].totPrice.toString(),
                            nameSummary: myOrderListController.myOrderListModel!.running![index].name.toString(),
                            addressSummary: myOrderListController.myOrderListModel!.running![index].address.toString(),
                            dateSummary: myOrderListController.myOrderListModel!.running![index].date.toString(),
                            totProductSummary: myOrderListController.myOrderListModel!.running![index].totProduct.toString(),
                            imageSummary: myOrderListController.myOrderListModel!.running![index].image.toString(),
                          ));
                        },
                        child: Container(
                          width: Get.size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "${myOrderListController.myOrderListModel!.running![index].date}",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${"Order ID".tr}: #${myOrderListController.myOrderListModel!.running![index].id}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                        image: NetworkImage("${Config.imageBaseurlDoctor}${myOrderListController.myOrderListModel!.running![index].image}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${myOrderListController.myOrderListModel!.running![index].name}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "$currency${double.parse("${myOrderListController.myOrderListModel!.running![index].totPrice}").toStringAsFixed(2)}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 15,
                                                color: BlackColor,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 7),
                                        Row(
                                          children: [
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "${"item".tr} :",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 13,
                                                  color: BlackColor,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${myOrderListController.myOrderListModel!.running![index].totProduct}",
                                              maxLines: 1,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 15,
                                                color: BlackColor,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  myOrderListController.myOrderListModel!.running![index].status != "0"
                                      ? SizedBox()
                                      : Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              debugPrint("--------- order Id --------- ${myOrderListController.myOrderListModel!.running![index].id}");
                                              shopOrderCancel(orderId: "${myOrderListController.myOrderListModel!.running![index].id}");
                                            },
                                            child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: RedColor,
                                                ),
                                              ),
                                              child: Text(
                                                "Cancel".tr,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyMedium,
                                                  color: RedColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        shopOrderDetailController.shopOrderDetailApi(
                                          uid: "${getData.read("UserLogin")["id"]}",
                                          orderId: "${myOrderListController.myOrderListModel!.running![index].id}",
                                          doctorId: "${myOrderListController.myOrderListModel!.running![index].doctorId}",
                                        );
                                        Get.to(StoreWiseScreen(
                                          orderId: myOrderListController.myOrderListModel!.running![index].id.toString(),
                                          doctorId: myOrderListController.myOrderListModel!.running![index].doctorId.toString(),
                                          statusSummary: myOrderListController.myOrderListModel!.running![index].status.toString(),
                                          totPriceSummary: myOrderListController.myOrderListModel!.running![index].totPrice.toString(),
                                          nameSummary: myOrderListController.myOrderListModel!.running![index].name.toString(),
                                          addressSummary: myOrderListController.myOrderListModel!.running![index].address.toString(),
                                          dateSummary: myOrderListController.myOrderListModel!.running![index].date.toString(),
                                          totProductSummary: myOrderListController.myOrderListModel!.running![index].totProduct.toString(),
                                          imageSummary: myOrderListController.myOrderListModel!.running![index].image.toString(),
                                        ));
                                      },
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: gradient.defoultColor,
                                          ),
                                        ),
                                        child: Text(
                                          "Info".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            color: gradient.defoultColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
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
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Order placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any Order.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(child: CircularProgressIndicator(color: gradient.defoultColor)),
      );
    });
  }

  Widget pastOrder() {
    ShopOrderDetailController shopOrderDetailController = Get.put(ShopOrderDetailController());
    return GetBuilder<MyOrderListController>(builder: (myOrderListController) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: myOrderListController.isLoading
            ? myOrderListController.myOrderListModel!.complete!.isNotEmpty
                ? ListView.builder(
                    itemCount: myOrderListController.myOrderListModel!.complete!.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          shopOrderDetailController.shopOrderDetailApi(
                              uid: "${getData.read("UserLogin")["id"]}",
                              orderId: myOrderListController.myOrderListModel!.complete![index].id.toString(),
                              doctorId: myOrderListController.myOrderListModel!.complete![index].doctorId.toString());
                          Get.to(StoreWiseScreen(
                            orderId: myOrderListController.myOrderListModel!.complete![index].id.toString(),
                            doctorId: myOrderListController.myOrderListModel!.complete![index].doctorId.toString(),
                            statusSummary: myOrderListController.myOrderListModel!.complete![index].status.toString(),
                            totPriceSummary: myOrderListController.myOrderListModel!.complete![index].totPrice.toString(),
                            nameSummary: myOrderListController.myOrderListModel!.complete![index].name.toString(),
                            addressSummary: myOrderListController.myOrderListModel!.complete![index].address.toString(),
                            dateSummary: myOrderListController.myOrderListModel!.complete![index].date.toString(),
                            totProductSummary: myOrderListController.myOrderListModel!.complete![index].totProduct.toString(),
                            imageSummary: myOrderListController.myOrderListModel!.complete![index].image.toString(),
                          ));
                        },
                        child: Container(
                          width: Get.size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    myOrderListController.myOrderListModel!.complete![index].date.toString(),
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  myOrderListController.myOrderListModel!.complete![index].status == "3"
                                      ? Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/check_seal_verified.svg",
                                              height: 20,
                                              width: 20,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Image.asset(
                                              "assets/life-ring.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${"Order ID".tr}: #${myOrderListController.myOrderListModel!.complete![index].id}",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${Config.imageBaseurlDoctor}${myOrderListController.myOrderListModel!.complete![index].image}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "${myOrderListController.myOrderListModel!.complete![index].name}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "$currency${double.parse("${myOrderListController.myOrderListModel!.complete![index].totPrice}").toStringAsFixed(1)}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyBold,
                                                fontSize: 15,
                                                color: BlackColor,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "${"item".tr} :",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 13,
                                                  color: BlackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${myOrderListController.myOrderListModel!.complete![index].totProduct}",
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        shopOrderDetailController.shopOrderDetailApi(
                                          uid: "${getData.read("UserLogin")["id"]}",
                                          orderId: "${myOrderListController.myOrderListModel!.complete![index].id}",
                                          doctorId: "${myOrderListController.myOrderListModel!.complete![index].doctorId}",
                                        );
                                        Get.to(StoreWiseScreen(
                                          orderId: "${myOrderListController.myOrderListModel!.complete![index].id}",
                                          doctorId: "${myOrderListController.myOrderListModel!.complete![index].doctorId}",
                                          statusSummary: myOrderListController.myOrderListModel!.complete![index].status.toString(),
                                          totPriceSummary: myOrderListController.myOrderListModel!.complete![index].totPrice.toString(),
                                          nameSummary: myOrderListController.myOrderListModel!.complete![index].name.toString(),
                                          addressSummary: myOrderListController.myOrderListModel!.complete![index].address.toString(),
                                          dateSummary: myOrderListController.myOrderListModel!.complete![index].date.toString(),
                                          totProductSummary: myOrderListController.myOrderListModel!.complete![index].totProduct.toString(),
                                          imageSummary: myOrderListController.myOrderListModel!.complete![index].image.toString(),
                                        ));
                                      },
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: gradient.defoultColor,
                                          ),
                                        ),
                                        child: Text(
                                          "Info".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            color: gradient.defoultColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
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
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Order placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any Order.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
      );
    });
  }

  List cancelList = [
    {"id": 1, "title": "Financing fell through".tr},
    {"id": 2, "title": "Inspection issues".tr},
    {"id": 3, "title": "Change in financial situation".tr},
    {"id": 4, "title": "Title issues".tr},
    {"id": 5, "title": "Seller changes their mind".tr},
    {"id": 6, "title": "Competing offer".tr},
    {"id": 7, "title": "Personal reason".tr},
    {"id": 8, "title": "Others".tr},
  ];

  shopOrderCancel({required String orderId}) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: WhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Select Reason".tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Gilroy Bold',
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "${"Please select the reason for cancellation".tr} : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy Medium',
                        color: BlackColor,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            cancelId = "${cancelList[i]["id"]}";
                            rejectmsg = cancelList[i]["title"];
                            setState(() {});
                            debugPrint("----------- value ---------- $i");
                            debugPrint("--------- cancelId --------- $cancelId");
                            debugPrint("--------- rejectmsg -------- $rejectmsg");
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(width: 25),
                                Radio(
                                  activeColor: gradient.defoultColor,
                                  value: cancelList[i]["title"] == rejectmsg ? true : false,
                                  groupValue: true,
                                  onChanged: (value) {
                                    cancelId = "${cancelList[i]["id"]}";
                                    rejectmsg = cancelList[i]["title"];
                                    setState(() {});
                                    debugPrint("----------- value ---------- $value");
                                    debugPrint("--------- cancelId --------- $cancelId");
                                    debugPrint("--------- rejectmsg -------- $rejectmsg");
                                  },
                                ),
                                SizedBox(width: 15),
                                Text(
                                  cancelList[i]["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Medium',
                                    color: BlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    rejectmsg == "Others".tr
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              onChanged: (value) {
                                debugPrint("--------- value -------- $value");
                                rejectmsg = value;
                                debugPrint("------ rejectmsg text -------- $rejectmsg");
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(0xFF246BFD),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(0xFF246BFD),
                                      width: 1,
                                    ),
                                  ),
                                  hintText: 'Enter reason'.tr,
                                  hintStyle: TextStyle(
                                    fontFamily: 'Gilroy Medium',
                                    fontSize: Get.size.height / 55,
                                    color: Colors.grey,
                                  ),
                                ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketButton(
                            title: "Cancel".tr,
                            bgColor: RedColor,
                            titleColor: Colors.white,
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ),
                        GetBuilder<ShopOrderCancelController>(
                          builder: (ShopOrderCancelController) {
                            return SizedBox(
                              width: Get.width * 0.35,
                              height: Get.height * 0.05,
                              child: ticketButton(
                                title: "Confirm".tr,
                                gradient1: gradient.btnGradient,
                                titleColor: Colors.white,
                                onTap: () {
                                  shopOrderCancelController.shopOrderCancelApi(
                                    orderId: orderId,
                                    reason: rejectmsg,
                                    cancelId: cancelId
                                  ).then((value) {
                                   Get.back();
                                   _function();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ticketButton({
    Function()? onTap,
    String? title,
    Color? bgColor,
    titleColor,
    Gradient? gradient1,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient1,
          borderRadius: (BorderRadius.circular(18)),
        ),
        child: Center(
          child: Text(title!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontFamily: 'Gilroy Medium',
            ),
          ),
        ),
      ),
    );
  }
}
