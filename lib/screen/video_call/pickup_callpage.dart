import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/screen/video_call/vc_provider.dart';
import 'package:laundry/screen/video_call/videocall_screen.dart';
import 'package:provider/provider.dart';
import '../../Api/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:get/get.dart';
import '../../Api/data_store.dart';

class PickUpCall extends StatefulWidget {
  final Map userData;
  final String proPic;
  final String name;
  final bool isAudio;
  final String videoCallId;
  const PickUpCall(
      {super.key,
      required this.userData,
      required this.isAudio,
      required this.proPic,
      required this.name,
      required this.videoCallId});

  @override
  State<PickUpCall> createState() => _PickUpCallState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _PickUpCallState extends State<PickUpCall> {
  String ids = "";
  String dataids = "";
  late VcProvider vcProvider;

  @override
  void initState() {
    socketConnect();
    super.initState();
    vcProvider = Provider.of<VcProvider>(context, listen: false);

    debugPrint("===========..........>>>>>>>>>>>>>>> ${widget.videoCallId}");
    ids = "vcId";
    dataids = "isVc";
    isvc(widget.userData[ids], true);
    debugPrint(
        "===================${"JOINT DONE CUStOMER"}======================== ");
  }

  late io.Socket socket;

  @override
  void dispose() {
    super.dispose();
    vcProvider.ischatPage = false;
  }

  socketConnect() async {
    socket = io.io(Config.socketUrlDoctor, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();

    socket
        .on('Other_user_Call_Cut${getData.read("UserLogin")["id"].toString()}',
            (videoCall) {
      debugPrint("><><<<<<<><<<><><><><><><><><><><<> $videoCall");
      vcProvider.disposee();
      vcProvider.localUserJoined = false;
      vcProvider.muteUnmute = false;
      Get.offAll(BottomBarScreen());
    });
  }

  _connectSocket() {
    socket.onConnect((data) => debugPrint('Connection established'));
    socket.onConnectError((data) => debugPrint('Connect Error: $data'));
    socket.onDisconnect((data) => debugPrint('Socket.IO server disconnected'));
  }

  String doctorId = "";

  @override
  Widget build(BuildContext context) {
    vcProvider = Provider.of<VcProvider>(context);
    String str = widget.videoCallId.toString();
    List<String> parts = str.split('_');

    String id2 = parts[0];
    doctorId = parts[1];

    debugPrint('ID 1: $doctorId');
    debugPrint('ID 2: $id2');
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0.1,
            0.2,
            0.4,
            0.6,
            0.7,
          ],
          colors: [
            Color(0xff62e2f4),
            Color(0xff8290f4),
            Color(0xfff269cf),
            Color(0xffef5b5e),
            Color(0xfff07f51),
          ],
        )),
        child: Column(
          children: [
            const Spacer(flex: 2),
            widget.proPic != "null"
                ? Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              "${Config.imageBaseurlDoctor}${widget.proPic}"),
                          fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/Image/05.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "In Coming Video Call From ${widget.name}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    vcProvider.updateIschatPage(false);
                    isvc(widget.userData[ids], false);
                    vcProvider.disposee();
                    vcProvider.localUserJoined = false;
                    vcProvider.muteUnmute = false;
                    socket.emit('Audio_video_call_Cut', {
                      'id': getData.read("UserLogin")["id"].toString(),
                      'uid': doctorId.toString(),
                    });
                    Get.offAll(BottomBarScreen());
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                        child: SvgPicture.asset(
                      "assets/Call Missed.svg",
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    vcProvider.updateIschatPage(false);

                    Navigator.pop(context);
                    debugPrint("========================== DONEEEEEEEEEEEEEEEE 0 ========================== ");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCall(
                          channel: widget.videoCallId.toString(),
                        ),
                      ),
                    );

                    debugPrint("========================== DONEEEEEEEEEEEEEEEE 1 ========================== ");
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/Call.svg",
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

Future isvc(channel, bool isvc) async {
  return isvc;
}
