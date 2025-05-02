import 'package:dio/dio.dart';

class UserService {
  
final Dio _dio = Dio();
final String host = 'http://10.0.2.2:8080';

// 회원가입
Future<bool> registerUser(Map<String, dynamic> userData) async {
  try {
    final response = await _dio.post('$host/users', data: userData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    rethrow;
  }
}

}