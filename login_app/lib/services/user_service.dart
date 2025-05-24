import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final Dio _dio = Dio();
  final String host = 'http://54.180.59.31';

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

  // 회원정보 조회
  Future<Map<String, dynamic>> getUser(String? username) async {
    if (username == null) {
      return {};
    }

    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.get('$host/users/info',
          options: Options(headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        print('회원정보 조회');
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      print('회원정보 조회 요청 시, 에러 발생 : $e');
    }
    return {};
  }

  Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.put('$host/users',
          data: userData,
          options: Options(headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        print('회원정보 수정 성공');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('회원정보 수정 실패 : $e');
    }
    return false;
  }

  // 회원 탈퇴
  Future<bool> deleteUser(String? username) async {
    if (username == null) {
      return false;
    }
    try {
      final storage = const FlutterSecureStorage();
      String? jwt = await storage.read(key: 'jwt');
      final response = await _dio.delete('$host/users/$username',
          options: Options(headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        print('회원 탈퇴 성공');
        return true;
      }
    } catch (e) {
      print('회원 탈퇴 실패 : $e');
    }
    return false;
  }

  Future<void> deleteNaverAccessToken(String accessToken) async {
    const clientId = 'uR8aMYGT5QeEesKQ8Eoe'; // 네이버 앱 등록 시 받은 것
    const clientSecret = 'IBsH1sjga2'; // 네이버 앱 등록 시 받은 것

    final uri =
        Uri.parse('https://nid.naver.com/oauth2.0/token?grant_type=delete&'
            'client_id=$clientId&client_secret=$clientSecret&'
            'access_token=$accessToken&service_provider=NAVER');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('✅ 네이버 access token 삭제 성공');
    } else {
      print('❌ 삭제 실패: ${response.statusCode} / ${response.body}');
    }
  }
}
