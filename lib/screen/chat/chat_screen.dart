// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, library_prefixes

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/config.dart';
import '../../Api/data_store.dart';
import '../../controller_doctor/chat_controller.dart';
import '../../model/font_family_model.dart';
import '../../utils/custom_colors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatDetailController chatDetailController = Get.put(ChatDetailController());

  late IO.Socket socket;

  socketConnect() async {
    socket = IO.io(Config.socketUrlDoctor, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    _connectSocket();
    chatDetailController.chatApi();
    socket.on('New_Chat_Reaload${getData.read("UserLogin")["id"].toString()}',
        (message) {
      chatDetailController.chatApi();
      setState(() {});
    });
  }

  _connectSocket() {
    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  @override
  void initState() {
    socketConnect();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    chatDetailController.isLoading = false;
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: WhiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          "Chats".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 20,
            letterSpacing: 0.3,
            color: textcolor,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primeryColor,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                socketConnect();
              });
            },
          );
        },
        child: GetBuilder<ChatDetailController>(
          builder: (chatDetailController) {
            return chatDetailController.isLoading
                ? chatDetailController.chatDetailModel!.chatList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: chatDetailController.chatDetailModel!.chatList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MessageScreen(
                                              username: chatDetailController.chatDetailModel!.chatList[index].name,
                                              userImage: chatDetailController.chatDetailModel!.chatList[index].logo,
                                              senderId: chatDetailController.chatDetailModel!.chatList[index].senderId.toString(),
                                              receiverId: chatDetailController.chatDetailModel!.chatList[index].receiverId.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: WhiteColor,
                                          border: Border.all(color: Colors.grey.shade300),
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(65),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/ezgif.com-crop.gif",
                                            placeholderCacheWidth: 50,
                                            placeholderCacheHeight: 50,
                                            image: "${Config.imageBaseurlDoctor}${chatDetailController.chatDetailModel!.chatList[index].logo}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              chatDetailController.chatDetailModel!.chatList[index].name,
                                              style: TextStyle(
                                                fontFamily: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                                    ? FontFamily.gilroyExtraBold
                                                    : FontFamily.gilroyMedium,
                                                fontSize: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                                    ? 16
                                                    : 15,
                                                letterSpacing: 0.3,
                                                color: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                                    ? textcolor
                                                    : textcolor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                              ? Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              chatDetailController.chatDetailModel!.chatList[index].message,
                                              style: TextStyle(
                                                fontFamily: FontFamily.gilroyMedium,
                                                fontSize: chatDetailController.chatDetailModel!.chatList[index].status == '1'
                                                    ? 16
                                                    : 15,
                                                letterSpacing: 0.3,
                                                color: chatDetailController.chatDetailModel!.chatList[index].status == '1'
                                                    ? textcolor
                                                    : greycolor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        chatDetailController.chatDetailModel!.chatList[index].date,
                                        style: TextStyle(
                                          fontFamily: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                              ? FontFamily.gilroyExtraBold
                                              : FontFamily.gilroyMedium,
                                          fontSize: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                              ? 16
                                              : 15,
                                          letterSpacing: 0.3,
                                          color: chatDetailController.chatDetailModel!.chatList[index].status == "1"
                                              ? textcolor
                                              : greycolor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 200,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/emptyOrder.png"),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No chat yet!".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                color: BlackColor,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Currently you don’t have any chat.".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      )
                : Center(child: CircularProgressIndicator(color: primeryColor));
          },
        ),
      ),
    );
  }
}
