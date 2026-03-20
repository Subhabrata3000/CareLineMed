// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:laundry/screen/doctor_info_screen.dart';
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/map_sitter_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoading = true;

  final Set<Polygon> _polygon = HashSet<Polygon>();
  final List<Marker> _markers = [];
  bool isnotavalble = true;
  List<LatLng> points = [];

  double userLat = 0.0;
  double userLong = 0.0;

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();

    var savedLat = getData.read("lat");
    var savedLong = getData.read("long");

    userLat = (savedLat != null && savedLat.toString() != "0.0") ? double.parse(savedLat.toString()) : 22.5726;
    userLong = (savedLong != null && savedLong.toString() != "0.0") ? double.parse(savedLong.toString()) : 88.3639;

    // 2. Load API
    mapSitterController.mapDoctorApi(
        context: context,
        lat: userLat.toString(),
        long: userLong.toString(),
        radius: "5000" // increased radius to see global doctors
    ).then((value) {
      if (mapSitterController.mapDoctorModel!.doctorList.isNotEmpty) {
        //adding all doctor at once in map
        _loadAllDoctorMarkers();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Currently you don’t have any Doctor pin in you area!.".tr),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
        );
      }
      isLoading = false;
      setState(() {});
    });
  }

  Future<void> _loadAllDoctorMarkers() async {
    var doctors = mapSitterController.mapDoctorModel!.doctorList;
    List<Marker> tempMarkers = [];

    for (int i = 0; i < doctors.length; i++) {
      try {
        var doctor = doctors[i];

        final Uint8List markIcon = await createCustomMarker(
          profileUrl: "${Config.imageBaseurlDoctor}${doctor.logo}",
          rating: double.parse(doctor.avgStar.toString()),
        );

        tempMarkers.add(
          Marker(
            markerId: MarkerId(doctor.id.toString()),
            position: LatLng(double.parse(doctor.latitude), double.parse(doctor.longitude)),
            icon: BitmapDescriptor.fromBytes(markIcon),
            infoWindow: InfoWindow(
              title: doctor.title,
              snippet: doctor.subtitle,
            ),
            onTap: () {
              // When clicking a pin, scroll the bottom card to that doctor
              mapSitterController.pageController.animateToPage(
                  i,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut
              );
            },
          ),
        );
      } catch (e) {
        debugPrint("Error loading marker image: $e");
      }
    }

    if (mounted) {
      setState(() {
        _markers.addAll(tempMarkers);
      });
    }
  }

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  MapSitterController mapSitterController = Get.put(MapSitterController());

  int currentIndex = 0;

  Future<Uint8List> createCustomMarker({
    required String profileUrl,
    required double rating,
  }) async {
    final http.Response response = await http.get(Uri.parse(profileUrl));
    if (response.statusCode != 200) throw Exception("Failed to load profile image".tr);

    Uint8List profileData = response.bodyBytes;
    ui.Codec profileCodec = await ui.instantiateImageCodec(profileData);
    ui.FrameInfo profileFrameInfo = await profileCodec.getNextFrame();
    ui.Image profileImage = profileFrameInfo.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..isAntiAlias = true;

    double markerSize = 150;
    double profileSize = 120;
    double borderSize = 6;
    double badgeWidth = 90;
    double badgeHeight = 40;

    double centerX = markerSize / 2;
    double centerY = markerSize / 2;

    Paint borderPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY - 5), profileSize / 2 + borderSize, borderPaint);

    Path clipPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(centerX, centerY - 5), radius: profileSize / 2));

    canvas.save();
    canvas.clipPath(clipPath);

    double imgWidth = profileImage.width.toDouble();
    double imgHeight = profileImage.height.toDouble();
    Rect srcRect = Rect.fromLTWH(0, 0, imgWidth, imgHeight);
    Rect dstRect = Rect.fromCircle(center: Offset(centerX, centerY - 5), radius: profileSize / 2);

    canvas.drawImageRect(profileImage, srcRect, dstRect, paint);
    canvas.restore();

    double badgeX = centerX - badgeWidth / 2;
    double badgeY = centerY + profileSize / 2 - 35;

    Paint badgePaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(badgeX, badgeY, badgeWidth, badgeHeight),
        Radius.circular(15),
      ),
      badgePaint,
    );

    double starSize = 22;
    double ratingFontSize = 24;
    double spacing = 8;

    TextPainter starPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '⭐',
        style: TextStyle(fontSize: starSize, color: Colors.amber, fontWeight: FontWeight.bold),
      ),
    );

    starPainter.layout();

    TextPainter ratingPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: rating.toStringAsFixed(1),
        style: TextStyle(
          fontFamily: FontFamily.gilroyBold,
          color: BlackColor,
          fontSize: ratingFontSize,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    ratingPainter.layout();

    double totalWidth = starPainter.width + spacing + ratingPainter.width;
    double startX = badgeX + (badgeWidth - totalWidth) / 2;
    double startY = badgeY + (badgeHeight - starPainter.height) / 2;

    starPainter.paint(canvas, Offset(startX, startY));
    double ratingX = startX + starPainter.width + spacing;
    double ratingY = badgeY + (badgeHeight - ratingPainter.height) / 2;
    ratingPainter.paint(canvas, Offset(ratingX, ratingY));

    final ui.Picture picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(markerSize.toInt(), markerSize.toInt());
    ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<ui.Image> recolorImage(ui.Image image, Color newColor) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()
      ..colorFilter = ColorFilter.mode(newColor, BlendMode.srcATop);
    canvas.drawImage(image, Offset(0, 0), paint);

    final ui.Picture picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapSitterController>(builder: (mapSitterController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: SvgPicture.asset(
              "assets/bottomIcons/location.svg",
              color: textcolor,
            ),
          ),
          centerTitle: false,
          title: Text(
            "Near by doctor".tr,
            maxLines: 1,
            style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
              fontSize: 17,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        body: mapSitterController.isLoading
            ? isLoading
            ? Center(child: CircularProgressIndicator(color: primeryColor))
            : mapSitterController.mapDoctorModel!.doctorList.isNotEmpty
            ? Container(
          width: Get.size.width,
          decoration: BoxDecoration(
            color: WhiteColor,
          ),
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapSitterController.mapController = controller;
                  });
                },
                mapType: MapType.normal,
                polygons: _polygon,

                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    userLat != 0.0 ? userLat : double.parse(mapSitterController.mapDoctorModel!.doctorList[0].latitude),
                    userLong != 0.0 ? userLong : double.parse(mapSitterController.mapDoctorModel!.doctorList[0].longitude),
                  ),
                  zoom: 12,
                ),
                markers: _markers.toSet(),
              ),
              Positioned(
                bottom: Get.height / 8,
                child: SizedBox(
                  height: 185,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: mapSitterController.pageController,
                    itemCount: mapSitterController.mapDoctorModel!.doctorList.length,
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (index) async {
                      currentIndex = index;

                      // 🟢 OPTIMIZED: Just move camera, don't redraw markers
                      mapSitterController.updatePosition(
                          mapSitterController.mapDoctorModel!.doctorList[index].latitude,
                          mapSitterController.mapDoctorModel!.doctorList[index].longitude
                      );

                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Get.to(
                            DoctorInfoScreen(
                              doctorid: "${mapSitterController.mapDoctorModel!.doctorList[index].id}",
                              departmentId: mapSitterController.mapDoctorModel!.doctorList[index].departmentId,
                            ),
                          );
                        },
                        child: Container(
                          width: Get.size.width,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FadeInImage.assetNetwork(
                                          fadeInCurve: Curves.easeInCirc,
                                          placeholder: "assets/ezgif.com-crop.gif",
                                          placeholderCacheHeight: 70,
                                          placeholderCacheWidth: 70,
                                          placeholderFit: BoxFit.cover,
                                          image: "${Config.imageBaseurlDoctor}${mapSitterController.mapDoctorModel!.doctorList[index].logo}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mapSitterController.mapDoctorModel!.doctorList[index].title,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontFamily: FontFamily.gilroyBold,
                                              fontSize: 17,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            mapSitterController.mapDoctorModel!.doctorList[index].subtitle,
                                            style: TextStyle(
                                              color: BlackColor,
                                              fontFamily: FontFamily.gilroyMedium,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/location-pin.svg",
                                      height: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        mapSitterController.mapDoctorModel!.doctorList[index].address,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          color: BlackColor,
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/star_fiell.svg",
                                      height: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${double.parse(mapSitterController.mapDoctorModel!.doctorList[index].avgStar.toString()).toStringAsFixed(1)} (${mapSitterController.mapDoctorModel!.doctorList[index].totReview} reviews)",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyMedium,
                                        color: BlackColor,
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
            : GoogleMap(
          onMapCreated: (controller) {
            setState(() {
              mapSitterController.mapController = controller;
            });
          },
          mapType: MapType.normal,
          polygons: _polygon,

          // Added a Blue Dot for user location
          myLocationEnabled: true,
          myLocationButtonEnabled: true,

          zoomGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(userLat, userLong),
            zoom: 12,
          ),
        )
            : const Center(child: CircularProgressIndicator(color: gradient.defoultColor)),
      );
    },
    );
  }
}