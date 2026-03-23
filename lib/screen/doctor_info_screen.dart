// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/controller/favorite_add_controller.dart';
import 'package:carelinemed/controller/send_notification_controller.dart';
import 'package:carelinemed/controller_doctor/doctor_detail_controller.dart';
import 'package:carelinemed/controller_doctor/home_controller.dart';
import 'package:carelinemed/controller_doctor/time_slot_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/authentication/onbording_screen.dart';
import 'package:carelinemed/screen/yourcart_screen.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DoctorInfoScreen extends StatefulWidget {
  final String doctorid;
  final String departmentId;
  const DoctorInfoScreen({super.key, required this.doctorid, required this.departmentId});

  @override
  DoctorInfoScreenState createState() => DoctorInfoScreenState();
}

class DoctorInfoScreenState extends State<DoctorInfoScreen> with SingleTickerProviderStateMixin {
  FavoriteAddController favoriteAddController = Get.put(FavoriteAddController());
  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());
  HomeController homeController = Get.put(HomeController());
  TimeSlotController timeSlotController = Get.put(TimeSlotController());
  SendNotificationController sendNotificationController = Get.put(SendNotificationController());

  late ScrollController _scrollController;
  static const kExpandedHeight = 360.0;

  ScrollController scrollController = ScrollController();
  TabController? _tabController;
  late DateRangePickerController dateRangePickerController;

  int currentIndex = 0;
  bool bottomShow = false;
  int selectIndex = 0;
  int timeIndex = 0;
  int daysIndex = 0;
  bool serviceisLoading = true;

  String? selectedSession;
  String? selectedTime;
  String? selectedHid;
  String serviceType = "";

  @override
  void initState() {
    super.initState();
    doctorDetailController.isLoading = true;
    setState(() {});
    _tabController = TabController(length: 2, vsync: this);
    dateRangePickerController = DateRangePickerController();
    doctorDetailController.doctorDetailApi(
      doctorId: widget.doctorid,
      departmentId: widget.departmentId,
    ).then((value) async {
      if (value['Result'] == true) {
        await timeSlotController.timeSlotApi(
          doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
          date: "${doctorDetailController.doctorDetailModel!.alldate!.first.date}",
          departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList!.first.departmentId}",
          hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList!.first.hospitalId}",
        );
      } else {
        Fluttertoast.showToast(msg: "${value["message"]}");
      }
    });
    serviceisLoading = false;
    setState(() {});
    _scrollController = ScrollController()..addListener(() { setState(() {}); });
    _tabController?.index == 0;
    if (_tabController?.index == 0) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    doctorDetailController.isLoading = true;
    timeSlotController.isLoading = true;
    _tabController?.dispose();
    super.dispose();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      bottomNavigationBar: _buildBottomBar(),
      body: GetBuilder<DoctorDetailController>(
        builder: (doctorDetailController) {
          return RefreshIndicator(
            color: gradient.defoultColor,
            onRefresh: () {
              return Future.delayed(Duration(seconds: 2), () {
                if (doctorDetailController.isLoading == false) {
                  doctorDetailController.doctorDetailApi(
                    doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                    departmentId: widget.departmentId.toString(),
                  );
                }
              });
            },
            child: GetBuilder<FavoriteAddController>(
              builder: (favoriteAddController) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomScrollView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      slivers: <Widget>[
                        _buildSliverAppBar(favoriteAddController),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSpecialtiesSection(),
                                  SizedBox(height: 24),
                                  _buildAvailabilitySection(),
                                  SizedBox(height: 12),
                                  GetBuilder<TimeSlotController>(
                                    builder: (timeSlotController) {
                                      return timeSlotController.isLoading
                                          ? _buildTimeSlotsShimmer()
                                          : inPerson();
                                    },
                                  ),
                                  selectedTime == null ? SizedBox(height: 0) : SizedBox(height: 90),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    doctorDetailController.isLoading ? SizedBox() : hospitalDetail(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: selectedTime == null
            ? SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: "Select time for your appointment!".tr);
                  },
                  child: Text(
                    "Book Appointment".tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.gilroyBold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              )
            : Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: gradient.btnGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () {
                      if (getData.read("UserLogin") == null) {
                        Get.offAll(BoardingPage());
                      } else {
                        Get.to(YourCartScreen(
                          day: "$selectedSession",
                          doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
                          departmentId: widget.departmentId,
                          subDepartmentId: doctorDetailController.subDepartmentId.toString(),
                          hospitalId: hospitalID.toString(),
                          serviceType: (doctorDetailController.priceChange == "1" && doctorDetailController.selectTab == 0)
                              ? "1"
                              : (doctorDetailController.priceChange == "2" && doctorDetailController.selectTab == 1)
                              ? "2"
                              : (doctorDetailController.priceChange == "3" && doctorDetailController.selectTab == 0)
                              ? "1"
                              : "2",
                          date: doctorDetailController.timeSelected,
                          time: "$selectedTime",
                          price: (doctorDetailController.priceChange == "1" || doctorDetailController.priceChange == "3")
                              ? doctorDetailController.inPersonPrice
                              : (doctorDetailController.priceChange == "2" || doctorDetailController.priceChange == "3")
                              ? doctorDetailController.videoPrice
                              : 0,
                        ));
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Book Appointment".tr,
                            style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyBold, color: WhiteColor),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${getData.read("currency")}${(doctorDetailController.priceChange == "1" || doctorDetailController.priceChange == "3") ? doctorDetailController.inPersonPrice : (doctorDetailController.priceChange == "2" || doctorDetailController.priceChange == "3") ? doctorDetailController.videoPrice : ""}",
                            style: TextStyle(fontSize: 16, fontFamily: FontFamily.gilroyBold, color: WhiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSliverAppBar(FavoriteAddController favoriteAddController) {
    return SliverAppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      elevation: 0,
      leading: _buildAppBarBackBtn(),
      backgroundColor: Colors.transparent,
      title: _isSliverAppBarExpanded
          ? Text(
              doctorDetailController.isLoading ? "" : "${doctorDetailController.doctorDetailModel!.doctor!.title}",
              style: TextStyle(color: WhiteColor, fontFamily: FontFamily.gilroyBold, fontSize: 17),
            )
          : null,
      centerTitle: true,
      actions: [_buildFavoriteBtn(favoriteAddController)],
      pinned: true,
      expandedHeight: kExpandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderContent(),
      ),
    );
  }

  Widget _buildAppBarBackBtn() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
        child: Icon(Icons.arrow_back, color: WhiteColor, size: 20),
      ),
    );
  }

  Widget _buildFavoriteBtn(FavoriteAddController favoriteAddController) {
    return GestureDetector(
      onTap: () {
        if (!favoriteAddController.isLoading && !doctorDetailController.isLoading) {
          favoriteAddController.favoriteAddApi(
            doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
            departmentId: widget.departmentId,
          ).then((value) {
            if (value['Result'] == true) {
              doctorDetailController.doctorDetailApi(
                departmentId: widget.departmentId,
                doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
              ).then((value1) {
                if (value1['Result'] == true) {
                  favoriteAddController.isLoading = false;
                  setState(() {});
                }
              });
            }
            homeController.homeApiDoctor(lat: lat.toString(), lon: long.toString());
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: WhiteColor, shape: BoxShape.circle),
        child: favoriteAddController.isLoading
            ? Center(child: LoadingAnimationWidget.fourRotatingDots(color: gradient.defoultColor, size: 20))
            : doctorDetailController.isLoading
            ? SizedBox()
            : Icon(
                doctorDetailController.doctorDetailModel!.doctor!.totFavorite == 0
                    ? Icons.favorite_border_rounded
                    : Icons.favorite_rounded,
                size: 20,
                color: doctorDetailController.doctorDetailModel!.doctor!.totFavorite == 0
                    ? Colors.black54
                    : Colors.redAccent,
              ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          child: doctorDetailController.isLoading
              ? Image.asset("assets/ezgif.com-crop.gif", fit: BoxFit.cover)
              : FadeInImage.assetNetwork(
                  placeholder: "assets/ezgif.com-crop.gif",
                  image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.doctor!.coverLogo}",
                  fit: BoxFit.cover,
                ),
        ),
        if (!doctorDetailController.isLoading)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.8)],
              ),
            ),
          ),
        if (!doctorDetailController.isLoading)
          Positioned(
            left: 20,
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(color: WhiteColor, shape: BoxShape.circle),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.doctor!.logo}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (doctorDetailController.doctorDetailModel!.doctor!.verificationStatus != "0")
                      Positioned(
                        bottom: 4, right: 4,
                        child: Container(
                          height: 24, width: 24,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: WhiteColor),
                          child: SvgPicture.asset("assets/check_seal_verified.svg", fit: BoxFit.cover),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "${doctorDetailController.doctorDetailModel!.doctor!.name}",
                  style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 24, color: WhiteColor, height: 1.1),
                ),
                Text(
                  "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                  style: TextStyle(fontFamily: FontFamily.gilroyMedium, fontSize: 16, color: WhiteColor.withOpacity(0.9), height: 1.2),
                ),
                Text(
                  "${doctorDetailController.doctorDetailModel!.doctor!.description}",
                  maxLines: 1,
                  style: TextStyle(overflow: TextOverflow.ellipsis, fontFamily: FontFamily.gilroyLight, fontSize: 14, color: WhiteColor.withOpacity(0.7), height: 1.2),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.medical_information_outlined, color: primeryColor, size: 22),
            ),
            SizedBox(width: 4),
            Text(
              "Browse by Specialties".tr,
              style: TextStyle(fontSize: 18, fontFamily: FontFamily.gilroyBold, color: BlackColor),
            ),
          ],
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int i = 0; i < (doctorDetailController.isLoading ? 3 : doctorDetailController.doctorDetailModel!.depSubSerList!.length); i++) ...[
                _buildSpecialtyChip(i),
                if (i != (doctorDetailController.isLoading ? 3 : doctorDetailController.doctorDetailModel!.depSubSerList!.length) - 1) SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyChip(int i) {
    bool isSelected = currentIndex == i;
    return GestureDetector(
      onTap: () {
        if (!doctorDetailController.isLoading) {
          setState(() {
            currentIndex = i;
            serviceisLoading = true;
            daysIndex = 0;
            selectedTime = null;
            selectedSession = null;
            selectedHid = null;
            timeSlotController.timeSlotApi(
              doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
              date: "${doctorDetailController.doctorDetailModel!.alldate![currentIndex].date}",
              departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].departmentId}",
              hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].hospitalId}",
            ).then((value) {
              setState(() { serviceisLoading = false; });
            });
            doctorDetailController.showType = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].showType}";
            doctorDetailController.priceChange = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].showType}";
            doctorDetailController.inPersonPrice = int.parse("${doctorDetailController.doctorDetailModel!.depSubSerList![i].clientVisitPrice}");
            doctorDetailController.videoPrice = int.parse("${doctorDetailController.doctorDetailModel!.depSubSerList![i].videoConsultPrice}");
            doctorDetailController.subDepartmentId = "${doctorDetailController.doctorDetailModel!.depSubSerList![i].id}";
            doctorDetailController.selectTab = doctorDetailController.showType == "1" ? 0 : doctorDetailController.showType == "2" ? 1 : 0;
          });
        }
      },
      child: Container(
        height: doctorDetailController.isLoading ? 50 : null,
        width: doctorDetailController.isLoading ? Get.width / 2.5 : null,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected && !doctorDetailController.isLoading ? primeryColor.withOpacity(0.12) : WhiteColor,
          border: Border.all(
            color: doctorDetailController.isLoading ? Colors.transparent : (isSelected ? primeryColor : Colors.grey.shade300),
            width: isSelected ? 1.5 : 1,
          ),
          image: doctorDetailController.isLoading ? DecorationImage(image: AssetImage("assets/ezgif.com-crop.gif"), fit: BoxFit.cover) : null,
        ),
        child: doctorDetailController.isLoading
            ? SizedBox()
            : Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: WhiteColor,
                      border: Border.all(color: isSelected ? primeryColor.withOpacity(0.3) : greycolor.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/ezgif.com-crop.gif",
                        image: "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.depSubSerList![i].image}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${doctorDetailController.doctorDetailModel!.depSubSerList![i].subTitle}",
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 14,
                      color: isSelected ? primeryColor : BlackColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.event_available_outlined, color: primeryColor, size: 22),
            ),
            SizedBox(width: 4),
            Text("Availability".tr, style: TextStyle(color: BlackColor, fontFamily: FontFamily.gilroyBold, fontSize: 18)),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: doctorDetailController.isLoading || serviceisLoading ? WhiteColor : bgcolor,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: doctorDetailController.isLoading || serviceisLoading
                    ? Row(
                        children: [
                          for (int i = 0; i < 2; i++) ...[
                            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(35), child: Image.asset("assets/ezgif.com-crop.gif", height: 48, fit: BoxFit.cover))),
                            if (i == 0) SizedBox(width: 10),
                          ],
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (doctorDetailController.showType == "1" || doctorDetailController.showType == "3")
                            _buildToggleTab(label: "In Person".tr, icon: Icons.person_pin_outlined, isActive: doctorDetailController.selectTab == 0, onTap: () {
                              setState(() { doctorDetailController.selectTab = 0; doctorDetailController.priceChange = "1"; serviceType = "1"; });
                            }),
                          if (doctorDetailController.showType == "2" || doctorDetailController.showType == "3")
                            _buildToggleTab(label: "Video Visit".tr, icon: Icons.videocam_outlined, isActive: doctorDetailController.selectTab == 1, onTap: () {
                              setState(() { doctorDetailController.selectTab = 1; doctorDetailController.priceChange = "2"; serviceType = "2"; });
                            }),
                        ],
                      ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      for (int i = 0; i < (doctorDetailController.isLoading || serviceisLoading ? 4 : doctorDetailController.doctorDetailModel!.alldate!.length); i++) ...[
                        _buildDateChip(i),
                        if (i != (doctorDetailController.isLoading ? 4 : doctorDetailController.doctorDetailModel!.alldate!.length) - 1) SizedBox(width: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTab({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? WhiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(35),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: Offset(0, 2))] : [],
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? primeryColor : greycolor.withOpacity(0.6), size: 20),
              SizedBox(width: 6),
              Text(label, style: TextStyle(color: isActive ? primeryColor : greycolor.withOpacity(0.6), fontFamily: FontFamily.gilroyBold, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(int i) {
    bool isSelected = daysIndex == i;
    bool isShimmer = doctorDetailController.isLoading || serviceisLoading;
    return GestureDetector(
      onTap: () async {
        if (!isShimmer) {
          setState(() {
            daysIndex = i;
            doctorDetailController.timeSelected = "${doctorDetailController.doctorDetailModel!.alldate![i].date}";
          });
          await timeSlotController.timeSlotApi(
            doctorId: "${doctorDetailController.doctorDetailModel!.doctor!.id}",
            date: "${doctorDetailController.doctorDetailModel!.alldate![i].date}",
            departmentId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].departmentId}",
            hospitalId: "${doctorDetailController.doctorDetailModel!.depSubSerList![currentIndex].hospitalId}",
          );
          setState(() {});
        }
      },
      child: Container(
        height: isShimmer ? 60 : null,
        width: isShimmer ? 100 : null,
        decoration: BoxDecoration(
          border: Border.all(color: isShimmer ? transparent : (isSelected ? primeryColor : Colors.grey.shade300)),
          borderRadius: BorderRadius.circular(16),
          color: isShimmer ? transparent : (isSelected ? primeryColor : WhiteColor),
          image: isShimmer ? DecorationImage(image: AssetImage("assets/ezgif.com-crop.gif"), fit: BoxFit.cover) : null,
        ),
        child: isShimmer
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${doctorDetailController.doctorDetailModel!.alldate![i].date}".tr,
                      style: TextStyle(color: isSelected ? WhiteColor : BlackColor, fontFamily: FontFamily.gilroyBold, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${doctorDetailController.doctorDetailModel!.alldate![i].weekDay}".tr,
                      style: TextStyle(color: isSelected ? WhiteColor : Colors.grey.shade600, fontFamily: FontFamily.gilroyMedium, fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTimeSlotsShimmer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: WhiteColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 12,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 54),
          itemBuilder: (context, index) {
            return ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset("assets/ezgif.com-crop.gif", fit: BoxFit.cover));
          },
        ),
      ),
    );
  }

  Widget inPerson() {
    return Column(
      children: [
        timeSlot(day: "Morning".tr, image: "assets/cloud-sun.svg", color: Color(0xFFFFB800), list: timeSlotController.timeSlotModel!.ndatelist.morning, session: "Morning", selectedSession: selectedSession, selectedTime: selectedTime, onItemTap: toggleSelection),
        timeSlot(day: "Afternoon".tr, image: "assets/sun.svg", color: Color(0xFFFF8C42), list: timeSlotController.timeSlotModel!.ndatelist.afternoon, session: "Afternoon", selectedSession: selectedSession, selectedTime: selectedTime, onItemTap: toggleSelection),
        timeSlot(day: "Evening".tr, image: "assets/half_moon.svg", color: Color(0xFF6C63FF), list: timeSlotController.timeSlotModel!.ndatelist.evening, session: "Evening", selectedSession: selectedSession, selectedTime: selectedTime, onItemTap: toggleSelection),
      ],
    );
  }

  void toggleSelection(String session, String time, String hid) {
    setState(() {
      if (selectedSession == session && selectedTime == time) {
        selectedSession = null;
        selectedTime = null;
        selectedHid = null;
      } else {
        selectedSession = session;
        selectedTime = time;
        selectedHid = hid;
      }
    });
  }

  Widget timeSlot({
    required String day, required String image, required Color color, required List list,
    required String session, final String? selectedSession, final String? selectedTime,
    required Function(String, String, String) onItemTap,
  }) {
    if (doctorDetailController.isLoading || list.isEmpty) return SizedBox();
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    SvgPicture.asset(image, color: color, height: 22, width: 22),
                    SizedBox(width: 8),
                    Text(day.tr, style: TextStyle(color: BlackColor, fontFamily: FontFamily.gilroyBold, fontSize: 16)),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
                      child: Text("${list.length} ${"slots".tr}", style: TextStyle(color: color, fontFamily: FontFamily.gilroyBold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 54),
                  itemBuilder: (context, index) {
                    String time = list[index].t;
                    String hid = list[index].hid;
                    String bookStatus = list[index].o.toString();
                    
                    try {
                      String selectedDateStr = doctorDetailController.timeSelected;
                      if (selectedDateStr.isNotEmpty) {
                        DateTime now = DateTime.now();
                        DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");
                        DateTime slotDateTime = format.parse("$selectedDateStr $time");
                        
                        if (slotDateTime.isBefore(now)) {
                           bookStatus = "0"; 
                        }
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }

                    bool isSelected = selectedSession == session && selectedTime == time;
                    List<String> timeParts = list[index].t.split(" ");
                    String timeValue = timeParts[0];
                    String timePeriod = timeParts.length > 1 ? timeParts[1] : "";

                    Color bgColor;
                    Color borderClr;
                    Color textClr;

                    if (bookStatus == "0") {
                      bgColor = Colors.red.withOpacity(0.08);
                      borderClr = Colors.red.withOpacity(0.4);
                      textClr = Colors.red;
                    } else if (bookStatus == "1") {
                      bgColor = isSelected ? primeryColor : WhiteColor;
                      borderClr = isSelected ? primeryColor : Colors.grey.shade300;
                      textClr = isSelected ? WhiteColor : BlackColor;
                    } else if (bookStatus == "2") {
                      bgColor = Colors.grey.shade100;
                      borderClr = Colors.grey.shade300;
                      textClr = Colors.grey.shade400;
                    } else {
                      bgColor = WhiteColor;
                      borderClr = Colors.grey.shade300;
                      textClr = BlackColor;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (bookStatus == "0") {
                          Fluttertoast.showToast(msg: "You cannot book past or unavailable time".tr);
                        } else if (bookStatus == "1") {
                          onItemTap(session, time, hid);
                        } else if (bookStatus == "2") {
                          Fluttertoast.showToast(msg: "This time is already book".tr);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderClr, width: 1),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(timeValue.tr, style: TextStyle(color: textClr, fontFamily: FontFamily.gilroyBold, fontSize: 14)),
                            Text(timePeriod, style: TextStyle(color: textClr, fontFamily: FontFamily.gilroyMedium, fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? hospitalID = "";
  var selectedHospital;

  Widget hospitalDetail() {
    selectedHospital = doctorDetailController.doctorDetailModel!.hospitalList!.firstWhereOrNull((hospital) => hospital.id.toString() == selectedHid);
    hospitalID = doctorDetailController.doctorDetailModel!.hospitalList!.firstWhereOrNull((hospital) => hospital.id.toString() == selectedHid)?.id.toString();

    if (selectedHospital == null) return SizedBox();
    return Positioned(
      bottom: -10,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.fromLTRB(16, 14, 16, 30),
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: Offset(0, -4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital_rounded, color: primeryColor, size: 20),
                SizedBox(width: 8),
                Text("Clinic Details".tr, style: TextStyle(color: BlackColor, fontFamily: FontFamily.gilroyBold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            Text("${selectedHospital.name}".tr, style: TextStyle(color: BlackColor, fontFamily: FontFamily.gilroyBold, fontSize: 16)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.grey.shade600, size: 16),
                SizedBox(width: 4),
                Expanded(
                  child: Text("${selectedHospital.address}".tr, style: TextStyle(color: Colors.grey.shade700, fontFamily: FontFamily.gilroyMedium, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
