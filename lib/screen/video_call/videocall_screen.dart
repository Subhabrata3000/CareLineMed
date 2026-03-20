import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:laundry/screen/bottombarpro_screen.dart';
import 'package:laundry/utils/custom_colors.dart';
import 'package:laundry/screen/video_call/vc_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;



class VideoCall extends StatefulWidget {
  final String channel;
  const VideoCall({super.key, required this.channel});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {

  late VcProvider vcProvider;

  @override
  void initState() {
    socketConnect();
    super.initState();
    vcProvider = Provider.of<VcProvider>(context,listen: false);
    vcProvider.initAgora(agoraVcKey, agoraVcKey, widget.channel,context);
    debugPrint("========================== DONEEEEEEEEEEEEEEEE ${widget.channel} ==========================");
  }

  @override
  void dispose() {
    super.dispose();
    isvc(widget.channel,false);
    vcProvider.disposee();
    vcProvider.localUserJoined = false;
    vcProvider.muteUnmute = false;
  }

  String doctorId = "";
  late io.Socket socket;


  socketConnect() async {

    socket = io.io(Config.socketUrlDoctor,<String,dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],

    });
    socket.connect();
    _connectSocket();


    socket.on('Other_user_Call_Cut${getData.read("UserLogin")["id"].toString()}',(videoCall) {
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

  @override
  Widget build(BuildContext context) {
    vcProvider = Provider.of<VcProvider>(context);
    String str = widget.channel.toString();
    List<String> parts = str.split('_');

    String id2 = parts[0];
    doctorId = parts[1];

    debugPrint('ID 1: $doctorId');
    debugPrint('ID 2: $id2');
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: vcProvider.remoteVideo(widget.channel,context),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: vcProvider.localUserJoined ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: vcProvider.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ) : CircularProgressIndicator(color: primeryColor),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      vcProvider.muteUnmute =! vcProvider.muteUnmute;
                      await vcProvider.engine?.muteAllRemoteAudioStreams(vcProvider.muteUnmute);
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: Icon(
                        vcProvider.muteUnmute ? Icons.media_bluetooth_off : Icons.media_bluetooth_on_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),
                  InkWell(
                    onTap: () {
                      vcProvider.updateIschatPage(false);
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
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: const Icon(Icons.call_end),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      await vcProvider.engine?.switchCamera();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: const Icon(
                        Icons.cameraswitch_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}

Future isvc(channel, bool isvc) async {
  return isvc;
}
