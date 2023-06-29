import 'package:famlynk_version1/mvc/model/login_model/verifyOtp_model.dart';
import 'package:famlynk_version1/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OTPService {
  String userId = '';
  String token = '';

  Future<bool> verifyOTP(OTP otp) async {
    var url = FamlynkServiceUrl.verifyOtp;
    bool result = false;
    try {
      var response = await http.get(
        Uri.parse(url + otp.otp),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.body == 'OTP is correct') {
        result = true;
      }
    } catch (error) {
      print('Error verifying OTP: $error');
    }
    return result;
  }

  Future<bool> resendOTP(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    var url = FamlynkServiceUrl.resendOtp;
    try {
      final response = await http.get(Uri.parse(url + userId));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error resending OTP: $error');
      return false;
    }
  }
}
