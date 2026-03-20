// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:laundry/screen/home_screen.dart';
import 'package:laundry/screen/lab/lab_category_screen.dart';
import 'package:laundry/screen/profile_screen.dart';
import 'package:laundry/screen/shop/shops.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:provider/provider.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';

import 'video_call/pickup_callpage.dart';
import 'video_call/vc_provider.dart';

import 'map_pages/map_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

int currentIndexBottom = 0;
bool isOnline = false;

class _BottomBarScreenState extends State<BottomBarScreen> {

  List<Widget> pages = [
    HomeScreen(),
    MapScreen(),
    ShopsScreen(),
    LabCategoryScreen(),
    ProfileScreen(),
  ];

  List tabIcons = [
    'assets/bottomIcons/Home.svg',
    'assets/bottomIcons/location.svg',
    'assets/bottomIcons/medicine.svg',
    'assets/bottomIcons/test_tube.svg',
    'assets/bottomIcons/User.svg',
  ];

  List tabIconsFill = [
    'assets/bottomIcons/Homefill.svg',
    'assets/bottomIcons/loaction_fill.svg',
    'assets/bottomIcons/medicine_fill.svg',
    'assets/bottomIcons/test_tube_file.svg',
    'assets/bottomIcons/Userfill.svg',
  ];

  void _onTabTapped(int index) {
    setState(() {
      currentIndexBottom = index;
    });
  }

  late io.Socket socket;

  socketConnect() async {

    socket = io.io(Config.socketUrlDoctor,<String,dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();

    socket.on('Other_Audio_Video_Call${getData.read("UserLogin")["id"].toString()}',(videoCall) {
      debugPrint("<><><><><><>< video Call ><><><><><><> $videoCall");
      Get.to(PickUpCall(videoCallId: "${getData.read("UserLogin")["id"].toString()}_${videoCall["doctor_id"].toString()}", name: videoCall["name"].toString(), proPic:videoCall["logo"].toString(), userData: {}, isAudio: false),);
    });

  }

  @override
  void initState() {
    vcProvider = Provider.of<VcProvider>(context,listen: false);
    if (getData.read("UserLogin") != null) {
      socketConnect();
    }
    super.initState();
  }
  late VcProvider vcProvider;


  _connectSocket() {
    socket.onConnect((data) => debugPrint('Connection established'));
    socket.onConnectError((data) => debugPrint('Connect Error: $data'));
    socket.onDisconnect((data) => debugPrint('Socket.IO server disconnected'));
  }


  @override
  void dispose() {
    vcProvider.disposee();
    vcProvider.localUserJoined = false;
    vcProvider.muteUnmute = false;
    super.dispose();
  }

  DateTime? lastBackPressed;

  Future popScopeBack() async{
    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
      now.difference(lastBackPressed!) > Duration(seconds: 2)) {
      lastBackPressed = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    vcProvider = Provider.of<VcProvider>(context);
    return WillPopScope(
      onWillPop: () async{
        return await popScopeBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: pages[currentIndexBottom],
        ),
        bottomNavigationBar: Container(
          width: Get.width,
          height: MediaQuery.of(context).size.height * 0.08 + 2,
          decoration: BoxDecoration(
            color: bgcolor,
            boxShadow: [
              BoxShadow(
                color: primeryColor.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              for (int i = 0; i < tabIconsFill.length; i++) ...[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      debugPrint("hshgdhjsbc index----------- $i");
                      if (getData.read("UserLogin") == null) {
                        if (i == 4) {
                          Get.offAll(BoardingPage());
                        } else {
                          _onTabTapped(i);
                        }
                      } else {
                        _onTabTapped(i);
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeOutExpo,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                        color: currentIndexBottom == i
                            ? primeryColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        currentIndexBottom == i ? tabIconsFill[i] : tabIcons[i],
                        colorFilter: ColorFilter.mode(
                          currentIndexBottom == i ? WhiteColor : primeryColor.withOpacity(0.5),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  }
}

