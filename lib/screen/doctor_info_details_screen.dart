// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller_doctor/doctor_detail_controller.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/screen/full_screen_image.dart';
import 'package:carelinemed/utils/custom_colors.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DoctorInfoDetailsScreen extends StatefulWidget {
  const DoctorInfoDetailsScreen({super.key});

  @override
  State<DoctorInfoDetailsScreen> createState() => _DoctorInfoDetailsScreenState();
}

class _DoctorInfoDetailsScreenState extends State<DoctorInfoDetailsScreen> with TickerProviderStateMixin {
  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());

  late TabController tabController;

  int data = 0;
  int selectIndex = 0;

  List bottom = [
    "About".tr,
    "Review".tr,
    "Awards".tr,
    "Photos".tr,
    "FAQ's".tr,
    "Cancel Policy".tr,
  ];

  List<IconData> tabIcons = [
    Icons.info_outline_rounded,
    Icons.star_border_rounded,
    Icons.emoji_events_outlined,
    Icons.photo_library_outlined,
    Icons.help_outline_rounded,
    Icons.policy_outlined,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: bottom.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = doctorDetailController.doctorDetailModel!.doctor!;
    return Scaffold(
      backgroundColor: bgcolor,
      body: CustomScrollView(
        slivers: [
          // ─── Premium SliverAppBar with doctor info ───
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            leading: _buildBackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildDoctorHeader(doctor),
            ),
            title: Text(
              "${doctor.title}",
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 18,
                color: WhiteColor,
              ),
            ),
          ),

          // ─── Stat Chips Row ───
          SliverToBoxAdapter(
            child: _buildStatChips(doctor),
          ),

          // ─── Tab Bar ───
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: _buildTabBar(),
            ),
          ),

          // ─── Tab Content ───
          SliverFillRemaining(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   DOCTOR HEADER
  // ════════════════════════════════════════════════════════════

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: BackButton(
        color: WhiteColor,
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildDoctorHeader(dynamic doctor) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient.btnGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Doctor Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: WhiteColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: WhiteColor,
                      backgroundImage: doctor.logo != null && doctor.logo!.isNotEmpty
                          ? NetworkImage("${Config.imageBaseurlDoctor}${doctor.logo}")
                          : null,
                      child: doctor.logo == null || doctor.logo!.isEmpty
                          ? Icon(Icons.person, size: 40, color: primeryColor)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${doctor.title}",
                          style: TextStyle(
                            color: WhiteColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (doctor.subtitle != null && doctor.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            "${doctor.subtitle}",
                            style: TextStyle(
                              color: WhiteColor.withOpacity(0.85),
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (doctor.address != null && doctor.address!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: WhiteColor.withOpacity(0.8), size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${doctor.address}",
                                  style: TextStyle(
                                    color: WhiteColor.withOpacity(0.8),
                                    fontFamily: FontFamily.gilroyMedium,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   STAT CHIPS
  // ════════════════════════════════════════════════════════════

  Widget _buildStatChips(dynamic doctor) {
    return Container(
      color: WhiteColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statChip(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFB800),
            label: "Rating",
            value: "${doctor.avgStar ?? '0'}",
          ),
          _verticalDivider(),
          _statChip(
            icon: Icons.work_history_outlined,
            iconColor: primeryColor,
            label: "Experience",
            value: "${doctor.yearOfExperience ?? '0'} yr",
          ),
          _verticalDivider(),
          _statChip(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: const Color(0xFF6C63FF),
            label: "Reviews",
            value: "${doctor.totReview ?? '0'}",
          ),
          _verticalDivider(),
          _statChip(
            icon: Icons.favorite_border_rounded,
            iconColor: RedColor,
            label: "Liked",
            value: "${doctor.totFavorite ?? '0'}",
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 15,
            color: BlackColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.gilroyMedium,
            fontSize: 11,
            color: greycolor,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  // ════════════════════════════════════════════════════════════
  //   TAB BAR
  // ════════════════════════════════════════════════════════════

  Widget _buildTabBar() {
    return Container(
      color: WhiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          unselectedLabelColor: greycolor,
          labelStyle: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
          ),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: WhiteColor,
            boxShadow: [
              BoxShadow(
                color: primeryColor.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          labelColor: primeryColor,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          tabAlignment: TabAlignment.start,
          onTap: (value) {
            setState(() {
              selectIndex = value;
              data = value;
            });
          },
          tabs: [
            for (int i = 0; i < bottom.length; i++) ...[
              Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tabIcons[i],
                        size: 16,
                        color: data == i ? primeryColor : greycolor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        bottom[i],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   TAB CONTENT
  // ════════════════════════════════════════════════════════════

  Widget _buildTabContent() {
    switch (selectIndex) {
      case 0:
        return overViewWidget();
      case 1:
        return reviewWidget();
      case 2:
        return petsWidget();
      case 3:
        return photoWidget();
      case 4:
        return faqWidget();
      case 5:
        return cancelPolicyWidget();
      default:
        return overViewWidget();
    }
  }

  // ════════════════════════════════════════════════════════════
  //   EMPTY STATE WIDGET
  // ════════════════════════════════════════════════════════════

  Widget _emptyState({required String message, required IconData icon}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primeryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: primeryColor.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: Get.width / 1.5,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 15,
                color: greycolor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   ABOUT TAB
  // ════════════════════════════════════════════════════════════

  Widget overViewWidget() {
    return GetBuilder<DoctorDetailController>(
      builder: (doctorDetailController) {
        if (doctorDetailController.doctorDetailModel!.aboutData!.isEmpty) {
          return _emptyState(
            message: "Sorry, there are no about details to display at this time".tr,
            icon: Icons.info_outline_rounded,
          );
        }
        return Container(
          color: bgcolor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor name + address mini-card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primeryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${doctorDetailController.doctorDetailModel!.doctor!.title}",
                              style: TextStyle(
                                color: BlackColor,
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${doctorDetailController.doctorDetailModel!.doctor!.address}",
                              maxLines: 2,
                              style: TextStyle(
                                color: greycolor,
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // About sections as cards
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctorDetailController.doctorDetailModel!.aboutData!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index1) {
                    final aboutItem = doctorDetailController.doctorDetailModel!.aboutData![index1];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primeryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.medical_information_outlined,
                                  color: primeryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${aboutItem.head}",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 16,
                                    color: BlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (aboutItem.description != null && aboutItem.description!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              "${aboutItem.description}",
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 14,
                                color: greycolor,
                                height: 1.5,
                              ),
                            ),
                          ],
                          if (aboutItem.title != null && aboutItem.title!.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: primeryColor.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${aboutItem.title}",
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 14,
                                  color: primeryColor,
                                ),
                              ),
                            ),
                          ],
                          if (aboutItem.about != null && aboutItem.about!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            ...aboutItem.about!.map((item) {
                              if (item.subtitle == null || item.subtitle!.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primeryColor.withOpacity(0.1),
                                        image: item.icon != null && item.icon!.isNotEmpty
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  "${Config.imageBaseurlDoctor}${item.icon}",
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: item.icon == null || item.icon!.isEmpty
                                          ? Icon(Icons.check_circle_outline,
                                              size: 14, color: primeryColor)
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        "${item.subtitle}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 14,
                                          color: BlackColor.withOpacity(0.75),
                                          height: 1.4,
                                        ),
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════
  //   REVIEW TAB
  // ════════════════════════════════════════════════════════════

  Widget reviewWidget() {
    if (doctorDetailController.doctorDetailModel!.reviewData!.isEmpty) {
      return _emptyState(
        message: "Sorry, there are no reviews to display at this time".tr,
        icon: Icons.rate_review_outlined,
      );
    }
    return Container(
      color: bgcolor,
      child: ListView.separated(
        itemCount: doctorDetailController.doctorDetailModel!.reviewData!.length,
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final review = doctorDetailController.doctorDetailModel!.reviewData![index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar with gradient
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: gradient.btnGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        review.cusName != null && review.cusName!.isNotEmpty
                            ? review.cusName![0].toUpperCase()
                            : "?",
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 20,
                          color: WhiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name + Hospital
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${review.cusName}",
                            style: TextStyle(
                              color: BlackColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${review.hospitalName}",
                            style: TextStyle(
                              color: greycolor,
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Star badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primeryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 16),
                          const SizedBox(width: 3),
                          Text(
                            "${review.starNo}",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: FontFamily.gilroyBold,
                              color: primeryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Review text
                Text(
                  "${review.review}",
                  style: TextStyle(
                    color: BlackColor.withOpacity(0.7),
                    fontFamily: FontFamily.gilroyMedium,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Date
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: greycolor),
                    const SizedBox(width: 5),
                    Text(
                      review.date.toString().split(" ").first,
                      style: TextStyle(
                        color: greycolor,
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   AWARDS TAB
  // ════════════════════════════════════════════════════════════

  Widget petsWidget() {
    if (doctorDetailController.doctorDetailModel!.awardData!.isEmpty) {
      return _emptyState(
        message: "Sorry, there are no awards available to display at this time".tr,
        icon: Icons.emoji_events_outlined,
      );
    }
    return Container(
      color: bgcolor,
      child: GridView.builder(
        itemCount: doctorDetailController.doctorDetailModel!.awardData!.length,
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 200,
        ),
        itemBuilder: (context, index) {
          final award = doctorDetailController.doctorDetailModel!.awardData![index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primeryColor.withOpacity(0.2), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: primeryColor.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/ezgif.com-crop.gif",
                      placeholderCacheWidth: 100,
                      placeholderCacheHeight: 100,
                      image: "${Config.imageBaseurlDoctor}${award.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${award.title}",
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 14,
                    color: BlackColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   PHOTOS TAB
  // ════════════════════════════════════════════════════════════

  Widget photoWidget() {
    if (doctorDetailController.doctorDetailModel!.galleryList!.isEmpty) {
      return _emptyState(
        message: "Sorry, there are no photos available to display at this time".tr,
        icon: Icons.photo_library_outlined,
      );
    }
    return Container(
      color: bgcolor,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: doctorDetailController.doctorDetailModel!.galleryList!.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 120,
        ),
        itemBuilder: (context, index) {
          final imageUrl = "${Config.imageBaseurlDoctor}${doctorDetailController.doctorDetailModel!.galleryList![index].image}";
          return GestureDetector(
            onTap: () {
              debugPrint("--------------- image url -------------- ${Config.imageBaseurlDoctor}${doctorDetailController.imagePaths}");
              Get.to(
                FullScreenImage(
                  imageUrl: "${Config.imageBaseurlDoctor}${doctorDetailController.imagePaths[index]}",
                  tag: "generate_a_unique_tag",
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/ezgif.com-crop.gif",
                  placeholderCacheWidth: 110,
                  placeholderCacheHeight: 110,
                  image: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   FAQ TAB
  // ════════════════════════════════════════════════════════════

  Widget faqWidget() {
    if (doctorDetailController.doctorDetailModel!.faqData!.isEmpty) {
      return _emptyState(
        message: "Sorry, there are no FAQs available to display at this time".tr,
        icon: Icons.help_outline_rounded,
      );
    }
    return Container(
      color: bgcolor,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: doctorDetailController.doctorDetailModel!.faqData!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final faq = doctorDetailController.doctorDetailModel!.faqData![index];
          return Container(
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                iconColor: primeryColor,
                collapsedIconColor: greycolor,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primeryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.quiz_outlined, color: primeryColor, size: 18),
                ),
                title: Text(
                  "${faq.title}",
                  style: TextStyle(
                    color: BlackColor,
                    fontSize: 14,
                    fontFamily: FontFamily.gilroyBold,
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgcolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${faq.description}",
                      style: TextStyle(
                        color: greycolor,
                        fontSize: 14,
                        fontFamily: FontFamily.gilroyMedium,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //   CANCEL POLICY TAB
  // ════════════════════════════════════════════════════════════

  Widget cancelPolicyWidget() {
    if (doctorDetailController.doctorDetailModel!.doctor!.cancelPolicy == null ||
        doctorDetailController.doctorDetailModel!.doctor!.cancelPolicy == "") {
      return _emptyState(
        message: "Sorry, there are no Cancel Policy available to display at this time".tr,
        icon: Icons.policy_outlined,
      );
    }
    return Container(
      color: bgcolor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: RedColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.policy_outlined, color: RedColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Cancellation Policy".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 17,
                      color: BlackColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 16),
              // Policy HTML content
              HtmlWidget(
                "${doctorDetailController.doctorDetailModel!.doctor!.cancelPolicy}",
                textStyle: TextStyle(
                  color: BlackColor.withOpacity(0.75),
                  fontSize: 14,
                  fontFamily: FontFamily.gilroyMedium,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//   STICKY TAB BAR DELEGATE
// ════════════════════════════════════════════════════════════

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

// ════════════════════════════════════════════════════════════
//   PHOTO VIEW PAGE (preserved from original)
// ════════════════════════════════════════════════════════════

class PhotoViewPage extends StatefulWidget {
  final List<String> photos;
  final int index;

  const PhotoViewPage({
    super.key,
    required this.photos,
    required this.index,
  });

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  DoctorDetailController doctorDetailController = Get.put(DoctorDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: doctorDetailController.doctorDetailModel!.galleryList!.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: CachedNetworkImage(
            height: Get.height,
            width: Get.width,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            imageUrl: "${Config.imageBaseurlDoctor}${widget.photos[index]}",
            placeholder: (context, url) => Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: WhiteColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/ezgif.com-crop.gif",
                fit: BoxFit.cover,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.white,
              child: Center(child: Text(error.toString(), style: TextStyle(color: Colors.black))),
            ),
          ),
          minScale: PhotoViewComputedScale.covered,
          heroAttributes: PhotoViewHeroAttributes(tag: "${Config.imageBaseurlDoctor}${widget.photos[index]}"),
        ),
        pageController: PageController(initialPage: widget.index),
        enableRotation: false,
      ),
    );
  }
}
