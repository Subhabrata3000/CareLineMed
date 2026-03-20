$path = 'lib/screen/home_screen.dart'
$content = Get-Content $path -Raw
$pattern = '(?s): homeController\.homeModel!\.dynamicList!\[index\]\.module == "Hospital".*?(: homeController\.homeModel!\.dynamicList!\[index\]\.module == "Lab")'

$replacement = @'
: homeController.homeModel!.dynamicList![index].module == "Hospital"
                                           ? Row(
                                               children: [
                                                 Expanded(
                                                   child: SingleChildScrollView(
                                                     clipBehavior: Clip.none,
                                                     physics: BouncingScrollPhysics(),
                                                     scrollDirection: Axis.horizontal,
                                                     child: Row(
                                                       children: [
                                                         for (int hospitalIndex = 0; hospitalIndex < homeController.homeModel!.dynamicList![index].details!.length; hospitalIndex++) ...[
                                                           InkWell(
                                                             onTap: () {
                                                               Get.to(
                                                                 DoctorInfoScreen(
                                                                   doctorid: "${homeController.homeModel!.dynamicList![index].details![hospitalIndex].id}",
                                                                   departmentId: "${homeController.homeModel!.dynamicList![index].details![hospitalIndex].departmentId}",
                                                                 ),
                                                               );
                                                             },
                                                             child: Container(
                                                               width: 280,
                                                               padding: EdgeInsets.all(10),
                                                               decoration: BoxDecoration(
                                                                 color: primeryColor.withOpacity(0.05),
                                                                 borderRadius: BorderRadius.circular(15),
                                                               ),
                                                               child: Row(
                                                                 children: [
                                                                   ClipRRect(
                                                                     borderRadius: BorderRadius.circular(12),
                                                                     child: FadeInImage.assetNetwork(
                                                                       placeholder: "assets/ezgif.com-crop.gif",
                                                                       image: "${Config.imageBaseurlDoctor}${homeController.homeModel!.dynamicList![index].details![hospitalIndex].logo}",
                                                                       height: 80,
                                                                       width: 80,
                                                                       fit: BoxFit.cover,
                                                                     ),
                                                                   ),
                                                                   SizedBox(width: 12),
                                                                   Expanded(
                                                                     child: Column(
                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                                       children: [
                                                                         Text(
                                                                           "${homeController.homeModel!.dynamicList![index].details![hospitalIndex].name}",
                                                                           style: TextStyle(
                                                                             fontFamily: FontFamily.gilroyBold,
                                                                             color: BlackColor,
                                                                             fontSize: 16,
                                                                           ),
                                                                           maxLines: 1,
                                                                           overflow: TextOverflow.ellipsis,
                                                                         ),
                                                                         SizedBox(height: 4),
                                                                         Row(
                                                                           children: [
                                                                             Icon(Icons.star, color: yelloColor, size: 16),
                                                                             SizedBox(width: 4),
                                                                             Text(
                                                                               "${homeController.homeModel!.dynamicList![index].details![hospitalIndex].avgStar} (${homeController.homeModel!.dynamicList![index].details![hospitalIndex].totReview})",
                                                                               style: TextStyle(
                                                                                 fontFamily: FontFamily.gilroyMedium,
                                                                                 fontSize: 12,
                                                                                 color: greycolor,
                                                                               ),
                                                                             ),
                                                                           ],
                                                                         ),
                                                                         SizedBox(height: 8),
                                                                         Container(
                                                                           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                           decoration: BoxDecoration(
                                                                             color: WhiteColor,
                                                                             borderRadius: BorderRadius.circular(20),
                                                                           ),
                                                                           child: Text(
                                                                             "Hospital",
                                                                             style: TextStyle(
                                                                               fontFamily: FontFamily.gilroyMedium,
                                                                               fontSize: 11,
                                                                               color: primeryColor,
                                                                             ),
                                                                           ),
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           ),
                                                           if (hospitalIndex != homeController.homeModel!.dynamicList![index].details!.length - 1) ...[Container(width: 10)],
                                                         ],
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             )
                                           $1
'@

$content -replace $pattern, $replacement | Set-Content $path
