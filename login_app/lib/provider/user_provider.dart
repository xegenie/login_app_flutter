import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:login_app/models/user.dart' as app_user;
import 'package:naver_login_sdk/naver_login_sdk.dart';

class UserProvider extends ChangeNotifier {
  // 상태관리 정보
  // 사용자 정보
  late app_user.User _userInfo;
  // 로그인 상태
  bool _loginStat = false;
  // getter
  app_user.User get userInfo => _userInfo;
  bool get isLogin => _loginStat;
  // setter
  set userInfo(app_user.User userInfo) {
    _userInfo = userInfo;
  }

  set loginStat(bool loginStat) {
    _loginStat = loginStat;
  }

  // HTTP 요청 객체
  final Dio _dio = Dio();
  // 안전한 저장소
  final storage = const FlutterSecureStorage();

  // 로그인 요청
  Future<void> login(String username, String password) async {
    // 초기화
    _loginStat = false;

    const url = 'http://10.0.2.2:8080/login';
    final data = {
      'username': username,
      'password': password,
    };
    try {
      final response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        print("로그인 성공");

        // JWT ➡️ SecureStorage 에 저장
        final authorization = response.headers['authorization']?.first;

        if (authorization == null) {
          print("아이디 또는 비밀번호가 일치하지 않습니다.");
          return;
        }

        final jwt = authorization.replaceFirst('Bearer ', '');
        print("JWT : $jwt");
        await storage.write(key: 'jwt', value: jwt);

        // 사용자 정보, 로그인 상태 ➡️ Provider 에 갱신
        _userInfo = app_user.User.fromMap(response.data);
        _loginStat = true;
      } else if (response.statusCode == 403) {
        print("아이디 또는 비밀번호가 일치하지 않습니다.");
      } else {
        print("네트워크 오류 또는 알 수 없는 오류로 로그인에 실패하였습니다.");
      }
    } catch (e) {
      print("로그인 처리 중 에러 발생 : $e");
      return;
    }
    // 업데이트 된 상태를 구독하고 있는 위젯에 다시 빌드
    notifyListeners();
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    // 초기화
    _loginStat = false;

    try {
      // 1. 구글 로그인
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // 2. Firebase에 구글 인증 정보로 로그인
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final email = userCredential.user?.email;
      final name = userCredential.user?.displayName;

      const url = 'http://10.0.2.2:8080/google-login';
      final data = {
        'email': email,
        'name': name,
      };

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        print("로그인 성공");

        // 'Authorization' 헤더에서 JWT 추출
        final authorization = response.headers['authorization']?.first;

        if (authorization == null) {
          print("로그인 정보가 일치하지 않습니다.");
          return;
        }

        final jwt = authorization.replaceFirst('Bearer ', '');
        print("JWT : $jwt");
        await storage.write(key: 'jwt', value: jwt);

        if (response.data == null) {
          print("응답 데이터가 비어 있습니다.");
          return;
        }

        // 서버 응답에서 사용자 정보 처리
        final Map<String, dynamic> userMap = jsonDecode(response.data['user']);
        _userInfo = app_user.User.fromMap(userMap); // 사용자 정보 갱신
        _loginStat = true;
      } else if (response.statusCode == 403) {
        print("아이디 또는 비밀번호가 일치하지 않습니다.");
      } else {
        print("네트워크 오류 또는 알 수 없는 오류로 로그인에 실패하였습니다.");
      }
    } catch (e) {
      print("로그인 처리 중 에러 발생 : $e");
      return;
    }
    // 업데이트 된 상태를 구독하고 있는 위젯에 다시 빌드
    notifyListeners();
  }

  // 네이버 로그인
  Future<void> signInWithNaver(String id, String email, String name) async {
    // 초기화
    _loginStat = false;

    const url = 'http://10.0.2.2:8080/naver-login';
    final data = {
      'id': id,
      'email': email,
      'name': name,
    };

    try {
      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        print("네이버 로그인 성공");

        final authorization = response.headers['authorization']?.first;

        if (authorization == null) {
          print("로그인 정보가 일치하지 않습니다.");
          return;
        }

        final jwt = authorization.replaceFirst('Bearer ', '');
        print("JWT : $jwt");
        await storage.write(key: 'jwt', value: jwt);

        if (response.data == null) {
          print("응답 데이터가 비어 있습니다.");
          return;
        }

        final Map<String, dynamic> userMap = jsonDecode(response.data['user']);
        _userInfo = app_user.User.fromMap(userMap);
        _loginStat = true;
      } else if (response.statusCode == 403) {
        print("네이버 로그인 인증 실패");
      } else {
        print("네트워크 오류 또는 기타 오류");
      }
    } catch (e) {
      print("네이버 로그인 처리 중 예외 발생: $e");
      return;
    }

    notifyListeners();
  }

  Future<void> signInWithKakao(String id, String name) async {
    // 초기화
    _loginStat = false;

    const url = 'http://10.0.2.2:8080/kakao-login';
    final data = {
      'id': id,
      'name': name,
    };

    try {
      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        print("카카오 로그인 성공");

        final authorization = response.headers['authorization']?.first;

        if (authorization == null) {
          print("로그인 정보가 일치하지 않습니다.");
          return;
        }

        final jwt = authorization.replaceFirst('Bearer ', '');
        print("JWT : $jwt");
        await storage.write(key: 'jwt', value: jwt);

        if (response.data == null) {
          print("응답 데이터가 비어 있습니다.");
          return;
        }

        final Map<String, dynamic> userMap = jsonDecode(response.data['user']);
        _userInfo = app_user.User.fromMap(userMap);
        _loginStat = true;
      } else if (response.statusCode == 403) {
        print("카카오 로그인 인증 실패");
      } else {
        print("네트워크 오류 또는 기타 오류");
      }
    } catch (e) {
      print("카카오 로그인 처리 중 예외 발생: $e");
      return;
    }

    notifyListeners();
  }

  // 로그아웃
  Future<void> logout() async {
    try {
      // JWT 토큰 삭제
      await storage.delete(key: 'jwt');

      // 사용자 정보 초기화
      _userInfo = app_user.User();
      _loginStat = false;

      // 네이버 로그아웃 처리
      final accessTokenNaver = await NaverLoginSDK.getAccessToken();
      if (accessTokenNaver != null && accessTokenNaver.isNotEmpty) {
        await NaverLoginSDK.logout();
        print('네이버 로그아웃 성공');
      } else {
        print('네이버 로그인을 하지 않았습니다.');
      }

      // 카카오 로그아웃 처리
      try {
        await UserApi.instance.logout();
        print('카카오 로그아웃 성공');
      } catch (e) {
        print('카카오 로그아웃 실패: $e');
      }

      // 구글 로그아웃 처리
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      print('구글 로그아웃 성공');

      print('전체 로그아웃 성공');
    } catch (e) {
      print('로그아웃 실패: $e');
    }

    notifyListeners();
  }
}
