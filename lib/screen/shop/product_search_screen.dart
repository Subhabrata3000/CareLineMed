import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/screen/shop/product_details.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/product_search_controller.dart';
import '../../model/font_family_model.dart';



class ProductSearchScreen extends StatefulWidget {
  final String doctorId;
  final String title;
  const ProductSearchScreen({super.key, required this.doctorId, required this.title});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  
  String currency = "";

  @override
  void initState() {
    currency = "${getData.read("currency")}";
    productSearchController.productSearchApi(doctorId: widget.doctorId, searchField: "");
    setState(() {});
    super.initState();
  }

  TextEditingController search = TextEditingController();
  ProductSearchController productSearchController = Get.put(ProductSearchController());

  @override
  void dispose() {
    productSearchController.isLoading = false;
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: GetBuilder<ProductSearchController>(
            builder: (productSearchController) {
              return productSearchController.isLoading
                  ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            width: Get.size.width,
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2, right: 8),
                              child: TextField(
                                controller: search,
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  productSearchController.productSearchApi(doctorId: widget.doctorId, searchField: value);
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(10, 12, 10, 6),
                                  border: InputBorder.none,
                                  hintText: "Search for product".tr,
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamily.gilroyMedium,
                                    color: greytext,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: BlackColor,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    productSearchController.productSearchModel!.productList!.isNotEmpty
                        ? Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // SizedBox(height: 15),
                            ListView.separated(
                              itemCount: productSearchController.productSearchModel!.productList!.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) => SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    Get.to(ProductDetails(title: widget.title,sitterId: widget.doctorId.toString(),prodId: productSearchController.productSearchModel!.productList![index].id.toString()));
                                  },
                                  child: Container(
                                    width: Get.size.width,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: FadeInImage.assetNetwork(
                                              fadeInCurve: Curves.easeInCirc,
                                              placeholder:
                                              "assets/ezgif.com-crop.gif",
                                              placeholderCacheHeight: 50,
                                              placeholderCacheWidth: 50,
                                              placeholderFit: BoxFit.cover,
                                              image:
                                              "${Config.imageBaseurlDoctor}${productSearchController.productSearchModel!.productList![index].productImage}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${productSearchController.productSearchModel!.productList![index].productName}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 17,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  RichText(
                                                   text: TextSpan(
                                                     text: "$currency${productSearchController.productSearchModel!.productList![index].priceDetail!.first.price} ",
                                                     style: TextStyle(
                                                       fontSize: 16,
                                                       fontFamily: FontFamily.gilroyBold,
                                                       color: BlackColor,
                                                     ),
                                                     children: <TextSpan>[
                                                       TextSpan(
                                                         text: "$currency${productSearchController.productSearchModel!.productList![index].priceDetail!.first.basePrice}",
                                                         style: TextStyle(
                                                           fontSize: 14,
                                                           fontFamily: FontFamily.gilroyMedium,
                                                           color: greycolor,
                                                           decoration: TextDecoration.lineThrough,
                                                           decorationStyle: TextDecorationStyle.solid,
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                                 SizedBox(width: 5),
                                                 Container(
                                                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                   decoration: BoxDecoration(
                                                     color: Color(0xffFEB902),
                                                     borderRadius: BorderRadius.circular(60),
                                                   ),
                                                   child: Text(
                                                     "${productSearchController.productSearchModel!.productList![index].priceDetail!.first.discount}% OFF",
                                                     style: TextStyle(
                                                       color: WhiteColor,
                                                       fontSize: 11,
                                                       fontFamily: FontFamily.gilroyBold,
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
                          ],
                        ),
                      ),
                    )
                        : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 150,
                                width: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/emptyOrder.png"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10
                              ),
                              Text(
                                "No product yet!",
                                style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Currently you don’t have any product in you area!.",
                                style: TextStyle(
                                    fontFamily: FontFamily.gilroyMedium,
                                    color: greyColor),
                              ),
                            ],
                          ),
                        ),
                    
                                    ],
                                  ),
                  )
                  : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              );
            }
        ),
      ),
    );
  }
}


