import 'dart:convert';
import 'package:famlynk_version1/mvc/model/login_model/loginModel.dart';
import 'package:http/http.dart' as http;

class LoginServices {
  Future<dynamic> UuidPostMethod(LoginModel Uuiddata) async {
    Map<String, dynamic> uuiObj = {
      "phoneNumber": Uuiddata.phoneNumber,
      "uuid": Uuiddata.uuid
    };
    try {
      var response1 = await http.post(
        Uri.parse(''),
        body: jsonEncode(uuiObj),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );

      return response1.body;
    } catch (e) {
      print(e);
      throw Exception('Failed to load API Data');
    }
  }
}
