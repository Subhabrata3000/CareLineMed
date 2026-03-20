import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/font_family_model.dart';
import '../../model_doctor/book_medicine_model.dart';
import '../../utils/custom_colors.dart';

medicinceDetail(context,{required DrugPresciption data}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Information",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: FontFamily.gilroyExtraBold,
                            color: BlackColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Icon(Icons.close,color: BlackColor,size: 24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Medicine Name",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${data.medicineName}, ${data.dosage}",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
      
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.time,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Dosage",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.dosage,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Duration",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.days,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Frequency",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.frequency,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Instruction",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyExtraBold,
                      color: BlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.instructions,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: greyColor2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
      
                ],
              ),
            ),
          ],
        );
    },
  );
}
