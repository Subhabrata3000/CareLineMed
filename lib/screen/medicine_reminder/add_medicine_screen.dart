// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/add_medicine_controller.dart';
import 'package:laundry/controller/medicine_reminder_controller.dart';
import 'package:laundry/model/font_family_model.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/widget/button.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({
    super.key,
    this.reminderId,
    this.medicineName,
    this.timedata,
    this.status,
  });

  final String? reminderId;
  final String? medicineName;
  final List<Map<String, dynamic>>? timedata;
  final String? status;

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  AddMedicineController addMedicineController = Get.put(AddMedicineController());
  MedicineReminderController medicineReminderController = Get.put(MedicineReminderController());

  bool addmedicinceLoading = false;

  @override
  void initState() {
    debugPrint("---------- reminder Id ------------ ${widget.reminderId}");
    debugPrint("--------- medicine Name ----------- ${widget.medicineName}");
    debugPrint("------------ status --------------- ${widget.status}");
    debugPrint("----------- timedata -------------- ${widget.timedata}");
    addMedicineController.searchMeditineListApi(text: "");
    if (widget.reminderId != null) {
      addMedicineController.remiderId = "${widget.reminderId}";
      addMedicineController.medicinceTextValue.text = "${widget.medicineName}";
      addMedicineController.reminder = widget.status == "1" ? true : false;
      addMedicineController.timedata = widget.timedata ?? [];
      setState(() {});
      for (var i = 0; i < widget.timedata!.length; i++) {
        addMedicineController.doseNames.add(widget.timedata![i]["title"]);

        final timeOfDay = parseTime("${widget.timedata![i]["time"]}"); // Gives TimeOfDay(hour: 15, minute: 15)
        debugPrint("---------- timeOfDay ------------ $timeOfDay");
        addMedicineController.doseTimes.add(timeOfDay);
      }
    } else {
      addMedicineController.doseTimes = [TimeOfDay.now()];
      addMedicineController.doseNames = ["Dose 1"];
      setState(() {});
    }

    debugPrint("---------- textvalue.text ------------ ${addMedicineController.medicinceTextValue.text}");
    debugPrint("---------- reminder Id 1 ------------ ${addMedicineController.remiderId}");
    debugPrint("--------- medicine Name 1 ----------- ${addMedicineController.medicinceTextValue.text}");
    debugPrint("------------ status 1 --------------- ${addMedicineController.reminder}");
    debugPrint("----------- timedata 1 -------------- ${addMedicineController.timedata}");
    debugPrint("---------- doseNames 1 -------------- ${addMedicineController.doseNames}");
    debugPrint("---------- doseTimes 1 -------------- ${addMedicineController.doseTimes}");
    super.initState();
  }

  TimeOfDay parseTime(String time) {
    // Remove any hidden characters or weird spaces
    time = time.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();

    final format = DateFormat.jm(); // Expects strings like '3:15 PM'
    final dateTime = format.parseLoose(time); // Use parseLoose instead of parse
    return TimeOfDay.fromDateTime(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: addMedicineController.medicinceTextValue.text == ""
          ? SizedBox(height: 0, width: 0)
          : addmedicinceLoading
            ? Padding(
              padding: const EdgeInsets.all(15),
              child: loaderButton(borderRadius: BorderRadius.circular(15),),
            )
            : InkWell(
              onTap: () {
                if (addmedicinceLoading == false) {
                  addmedicinceLoading = true;
                  setState(() {});
                  addMedicineController.timedata.clear();
                  for (var i = 0; i < addMedicineController.doseNames.length; i++) {
                    addMedicineController.timedata.add({
                      "title": addMedicineController.doseNames[i],
                      "time": addMedicineController.doseTimes[i].format(context),
                    });
                  }
                  if (widget.reminderId != null) {
                    addMedicineController.editMedicinceReminderApi(
                      id: "${getData.read("UserLogin")["id"]}",
                      medicineName: addMedicineController.medicinceTextValue.text,
                      reminderId: addMedicineController.remiderId,
                      time: addMedicineController.timedata,
                    ).then((value) {
                      addmedicinceLoading = false;
                      medicineReminderController.medicineReminderListApi();
                      setState(() {});
                    });
                  } else {
                    if (addMedicineController.medicinceTextValue.text != "") {
                      addMedicineController.addMedicinceReminderApi(
                        id: "${getData.read("UserLogin")["id"]}",
                        medicineName: addMedicineController.medicinceTextValue.text,
                        time: addMedicineController.timedata,
                      ).then((value) {
                        addmedicinceLoading = false;
                        medicineReminderController.medicineReminderListApi();
                        setState(() {});
                      });
                    }
                  }
                }
              },
              child: Container(
                height: Get.height / 16,
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: gradient.defoultColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Done".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      color: WhiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
            child: BackButton(
              color: BlackColor,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        title: Text(
          "${widget.reminderId == null ? "Add".tr : "Edit".tr} ${"Medicine".tr}",
          style: TextStyle(
            color: BlackColor,
            fontFamily: FontFamily.gilroyBold,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AddMedicineController>(
        builder: (addMedicineController) {
          return addMedicineController.isLoading
              ? Center(child: CircularProgressIndicator(color: gradient.defoultColor))
              : Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: addMedicineController.medicinceTextValue.text == ""  ? 10  : Get.height / 10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TypeAheadField<String>(
                                controller: addMedicineController.medicinceTextValue,
                                builder: (context, controller, focusNode) {
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    scrollPadding: EdgeInsets.zero,
                                    cursorColor: gradient.defoultColor,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        addMedicineController.searchMeditineListApi(text: "");
                                      });
                                      setState(() {});
                                    },
                                    onChanged: (value) {
                                      debugPrint("- - - - - - - - value - - - - - - - - $value");
                                      setState(() {
                                        addMedicineController.searchMeditineListApi(text: value);
                                      });
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                      hintText: "Enter Medicine Name",
                                      hintStyle: TextStyle(
                                        color: greyColor,
                                        fontFamily: FontFamily.gilroyMedium,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: greyColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: greyColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: gradient.defoultColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onSelected: (value) {
                                  setState(() {
                                    addMedicineController.medicinceTextValue.text = value;
                                  });
                                  debugPrint("Selected Medicine: $value");
                                  debugPrint("Selected Medicine text Editing Controller: ${addMedicineController.medicinceTextValue.text}");
                                },
                                suggestionsCallback: (pattern) async {
                                  return addMedicineController.searchMeditineListModel!.medicine!.where((medicine) => medicine.toLowerCase().contains(pattern.toLowerCase())).toList();
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: textcolor,
                                      ),
                                    ),
                                  );
                                },
                                emptyBuilder: (context) => Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: WhiteColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Category Not Found...!!!".tr,
                                    style: TextStyle(
                                      color: textcolor,
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reminders".tr,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 18,
                                  ),
                                ),
                                CupertinoSwitch(
                                  activeTrackColor: gradient.defoultColor,
                                  value: addMedicineController.reminder,
                                  onChanged: (value) {
                                    setState(() {
                                      addMedicineController.reminder = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Medicine Dose Schedule".tr,
                                      style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          addMedicineController.doseTimes.add(TimeOfDay.now());
                                          addMedicineController.doseNames.add("Dose ${addMedicineController.doseNames.length + 1}");
                                          debugPrint("----------- doseNames -------------- ${addMedicineController.doseNames}");
                                          debugPrint("----------- doseTimes -------------- ${addMedicineController.doseTimes}");
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: bgcolor,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: BlackColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if(addMedicineController.doseTimes.isNotEmpty)...[SizedBox(height: 15)],
                                ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: addMedicineController.doseTimes.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: greycolor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    TextEditingController doseController = TextEditingController(text: addMedicineController.doseNames[index]);
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          titlePadding: EdgeInsets.all(15),
                                                          contentPadding: EdgeInsets.only(bottom: 0, left: 15, right: 15),
                                                          actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                          title: Text(
                                                            "Edit Dose Name".tr,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.gilroyBold,
                                                              color: BlackColor,
                                                            ),
                                                          ),
                                                          content: TextField(
                                                            controller: doseController,
                                                            cursorColor: gradient.defoultColor,
                                                            decoration: InputDecoration(
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                              hintText: "Edit Dose Name".tr,
                                                              hintStyle: TextStyle(
                                                                color: greyColor,
                                                                fontFamily: FontFamily.gilroyMedium,
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                borderSide: BorderSide(color: greyColor),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                borderSide: BorderSide(color: greyColor),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                borderSide: BorderSide(color: gradient.defoultColor),
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            GestureDetector(
                                                              onTap: () => Get.back(),
                                                              child: Container(
                                                                width: Get.width / 5,
                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(color: gradient.defoultColor),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Cancel".tr,
                                                                    style: TextStyle(
                                                                      color: gradient.defoultColor,
                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  addMedicineController.doseNames[index] = doseController.text;
                                                                });
                                                                Get.back();
                                                              },
                                                              child: Container(
                                                                width: Get.width / 5,
                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: gradient.defoultColor,
                                                                  border: Border.all(color: gradient.defoultColor),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Save".tr,
                                                                    style: TextStyle(
                                                                      color: WhiteColor,
                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    addMedicineController.doseNames[index],
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily: FontFamily.gilroyMedium,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () async {
                                                    final TimeOfDay? pickedTime = await showTimePicker(
                                                      context: context,
                                                      initialTime: addMedicineController.doseTimes[index],
                                                    );
                                                    if (pickedTime != null) {
                                                      setState(() {
                                                        addMedicineController.doseTimes[index] = pickedTime;
                                                      });
                                                    }
                                                    String time = addMedicineController.doseTimes[index].format(context);
                                                    debugPrint( "--------- time --------- $time");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        addMedicineController.doseTimes[index].format(context),
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.gilroyMedium,
                                                          color: BlackColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Icon(Icons.keyboard_arrow_down,color: greyColor),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            if (index < addMedicineController.doseTimes.length) {
                                              setState(() {
                                                addMedicineController.doseTimes.removeAt(index);
                                                addMedicineController.doseNames.removeAt(index);
                                              });
                                            }
                                          },
                                          child: SvgPicture.asset(
                                            "assets/trash.svg",
                                            height: 15,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                ),
                              ],
                            ),
                          ),
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
