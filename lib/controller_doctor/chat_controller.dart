import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/chat_detail_model.dart';


class ChatDetailController extends GetxController implements GetxService {

  ChatDetailModel? chatDetailModel;
  bool isLoading = false;

  chatApi() async{
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "status": "customer"
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.chatUrlDoctor + Config.allChat),body: jsonEncode(body),headers: userHeader);

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        chatDetailModel = chatDetailModelFromJson(response.body);
        update();
        if(chatDetailModel!.result == true){
          isLoading = true;
          update();
        }
        else{
          Fluttertoast.showToast(msg: chatDetailModel!.message.toString());

        }
      }else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}
