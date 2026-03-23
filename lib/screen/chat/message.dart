// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, library_prefixes

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/chat_controller.dart';
import '../../controller_doctor/message_controller.dart';
import '../../model/font_family_model.dart';
import '../video_call/pickup_callpage.dart';
import '../../utils/custom_colors.dart';

class MessageScreen extends StatefulWidget {
  final String username;
  final String userImage;
  final String senderId;
  final String receiverId;
  const MessageScreen({
    super.key,
    required this.username,
    required this.senderId,
    required this.receiverId,
    required this.userImage,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();

  _sendMessage() {
    socket.emit('Add_new_chat', {
      'id': getData.read("UserLogin")["id"].toString(),
      'sender_id': getData.read("UserLogin")["id"].toString(),
      'recevier_id': getData.read("UserLogin")["id"].toString() == widget.senderId.toString()
          ? widget.receiverId.toString()
          : widget.senderId.toString(),
      'message': messageController.text.trim(),
      'status': "customer",
    });
    messageControllerApi.messageApi(
        receiverID: widget.receiverId, senderID: widget.senderId.toString());
    messageController.clear();
  }

  MessageController messageControllerApi = Get.put(MessageController());
  ChatDetailController chatDetailController = Get.put(ChatDetailController());
  late ScrollController _controller;

  socketConnect() async {
    socket = IO.io(Config.socketUrlDoctor, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();
    messageControllerApi.messageApi(
        receiverID: widget.receiverId, senderID: widget.senderId.toString());
    socket.on('New_Chat_Reaload${getData.read("UserLogin")["id"].toString()}',
        (message) {
      messageControllerApi.messageApi(
          receiverID: widget.receiverId, senderID: widget.senderId.toString());
      setState(() {});
    });

    socket.on(
        'Other_Audio_Video_Call${getData.read("UserLogin")["id"].toString()}',
        (videoCall) {
      debugPrint("><><<<<<<><<<><><><><><><><><><><<> $videoCall");
      Navigator.push(
          context,
          (MaterialPageRoute(
            builder: (context) => PickUpCall(
                videoCallId:
                    "${getData.read("UserLogin")["id"].toString()}_${videoCall["doctor_id"].toString()}",
                name: widget.username,
                proPic: widget.userImage,
                userData: {},
                isAudio: false),
          )));
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    messageControllerApi.isLoading = false;
    socketConnect();

    debugPrint("****************************** ${widget.receiverId}");
    debugPrint("============================== ${widget.senderId}");
    super.initState();
  }

  _connectSocket() {
    socket.onConnect((data) => debugPrint('Connection established'));
    socket.onConnectError((data) => debugPrint('Connect Error: $data'));
    socket.onDisconnect((data) => debugPrint('Socket.IO server disconnected'));
  }

  @override
  void dispose() {
    messageController.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                chatDetailController.chatApi();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: WhiteColor,
              ),
            ),
            SizedBox(width: 13),
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: primeryColor,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  height: 40,
                  width: 40,
                  placeholder: "assets/ezgif.com-crop.gif",
                  image: "${Config.imageBaseurlDoctor}${widget.userImage}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.username,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 20,
                  letterSpacing: 0.3,
                  color: WhiteColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<MessageController>(
        builder: (messageControllerApi) {
          return messageControllerApi.isLoading
              ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/chatbg.png"),
                    fit: BoxFit.cover,
                  )
                ),
                child: Scrollbar(
                    controller: _controller,
                    thickness: 0,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      reverse: true,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                cacheExtent: 99999999,
                                itemCount: messageControllerApi.messageModel!.allChat.length,
                                itemBuilder: (context, index1) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        messageControllerApi.messageModel!.allChat[index1].date,
                                        style: TextStyle(
                                          color: textcolor,
                                          fontSize: 14,
                                          fontFamily: FontFamily.gilroyBold,
                                        ),
                                      ),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        cacheExtent: 99999999,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        separatorBuilder: (_, index) =>SizedBox(height: 5),
                                        itemCount: messageControllerApi.messageModel!.allChat[index1].chat.length,
                                        itemBuilder: (context, index) {
                                          return Wrap(
                                            alignment: messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                ? WrapAlignment.end
                                                : WrapAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: Get.width / 1.4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                      ? primeryColor
                                                      : Colors.grey.shade300,
                                                  borderRadius:
                                                      messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                          ? BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                            )
                                                          : BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                            ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                            ? CrossAxisAlignment.end
                                                            : CrossAxisAlignment.start,
                                                    children: [
                                                      messageController.text != null
                                                          ? Text(
                                                              messageControllerApi.messageModel!.allChat[index1].chat[index].message,
                                                              style: TextStyle(
                                                                color: messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                                    ? Colors.white
                                                                    : textcolor,
                                                                fontSize: 16,
                                                                fontFamily: FontFamily.gilroyBold,
                                                              ),
                                                            )
                                                          : Text(
                                                              messageControllerApi.messageModel!.allChat[index1].chat[index].message,
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontFamily: FontFamily.gilroyBold,
                                                              ),
                                                            ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        messageControllerApi.messageModel!.allChat[index1].chat[index].date,
                                                        style: TextStyle(
                                                          color: messageControllerApi.messageModel!.allChat[index1].chat[index].status == 1
                                                              ? Colors.white
                                                              : textcolor,
                                                          fontSize: 12,
                                                          fontFamily: FontFamily.gilroyMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              )
              : Center(child: CircularProgressIndicator(color: primeryColor));
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: FontFamily.gilroyBold,
                    color: textcolor,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          debugPrint("++++++++++ ${messageController.text.trim()}");
                          _sendMessage();
                          setState(() {});
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: textcolor,
                        size: 22,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyBold,
                      color: textcolor,
                    ),
                    hintText: "Say Something...".tr,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(65),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(65),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primeryColor, width: 1.8),
                      borderRadius: BorderRadius.circular(65),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(65),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
