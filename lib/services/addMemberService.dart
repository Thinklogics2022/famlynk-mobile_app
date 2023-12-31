import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:famlynk_version1/mvc/model/addmember_model/addMemberModel.dart';
import 'package:famlynk_version1/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemberService {
  String email = '';

  Future<dynamic> addMemberPost(AddMemberModel addMemberModel) async {
    var urls = FamlynkServiceUrl.addMember;
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    final url = Uri.parse(urls + email);

    Map<String, dynamic> requestBody = {
      "name": addMemberModel.name,
      "gender": addMemberModel.gender,
      "mobileNo": addMemberModel.mobileNo,
      "email": addMemberModel.email,
      "relation": addMemberModel.relation,
      "dob": addMemberModel.dob,
      "image": addMemberModel.image,
      "userId": addMemberModel.userId
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode==201) {
        print('POST request successful');
        print(response.body);
        return response.body;
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}