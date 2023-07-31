import 'dart:convert';
import 'package:famlynk_version1/mvc/model/newsfeed_model/publicNewsFeed_model.dart';
import 'package:famlynk_version1/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PublicNewsFeedService {
  String userId = '';
  String token = '';

  Future<List<PublicNewsFeedModel>> getPublicNewsFeed(int pageNumber, int pageSize) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
     userId = prefs.getString('userId') ?? '';

    var url = FamlynkServiceUrl.getPublicNewsFeed;
    try {
      final response = await http.get(
        Uri.parse('$url$pageNumber/$pageSize/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['content'] != null) {
          List<PublicNewsFeedModel> newsFeedList = (jsonData['content'] as List)
              .map((data) => PublicNewsFeedModel.fromJson(data))
              .toList();
          return newsFeedList;
        } else {
          throw Exception('Invalid response format: content not found');
        }
      } else {
        throw Exception('Failed to fetch data from the backend');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}