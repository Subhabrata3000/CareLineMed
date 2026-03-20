import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/message_model.dart';

class MessageController extends GetxController implements GetxService {

  MessageModel? messageModel;
  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

    addNewMessage(MessageModel message) {
    _messages.add(message);
    update();
  }

  bool isLoading = false;
  messageApi({required String senderID, required String receiverID}) async{
  Map body = {
    "id": getData.read("UserLogin")["id"].toString(),
    "sender_id": senderID,
    "recevier_id": receiverID,
    "status": "customer"
  };

  Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
  var response = await http.post(Uri.parse(Config.chatUrlDoctor + Config.messageData),body: jsonEncode(body),headers: userHeader);

  var data = jsonDecode(response.body);
  if(response.statusCode == 200){
    if(data["Result"] == true){
      messageModel = messageModelFromJson(response.body);
      update();
      if(messageModel!.result == true){
        isLoading = true;
        update();
      }
      else{
        Fluttertoast.showToast(msg: messageModel!.message.toString());

      }
    }else{
      Fluttertoast.showToast(msg: "${data["message"]}");
    }
  }else{
    Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
  }
}
}

