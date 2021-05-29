import 'package:http/http.dart' as http;
import 'dart:convert';

class VkApiHelper {
  static Future<Map<String, dynamic>> invokeApi(String method) async{
    var url = "https://api.vk.com/method/$method";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw new Exception("Non-success response: ${response.statusCode}");
    }

    var jsonBody = json.decode(response.body) as Map<String, dynamic>;
    if (jsonBody.containsKey('error')) {
      throw new Exception("Error: ${jsonBody['error']['error_msg']}");
    }

    return jsonBody;
  }
}