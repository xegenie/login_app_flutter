import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:login_app/models/user.dart' as app_user;
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> login(String username, String password,
      {bool rememberId = false, bool rememberMe = false}) async {
    // 초기화
    _loginStat = false;

    const url = 'http://54.180.59.31/login';
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

        // 아이디 저장
        if (rememberId) {
          print('아이디 저장');
          await storage.write(key: 'username', value: username);
        } else {
          print('아이디 저장 해제');
          await storage.delete(key: 'username');
        }
        // 자동 로그인
        if (rememberMe) {
          print('자동 로그인');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('auto_login', true);
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('auto_login', false);
        }
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

      const url = 'http://54.180.59.31/google-login';
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

        // SharedPreferences에 JWT 저장
        print('자동 로그인');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auto_login', true);

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

    const url = 'http://54.180.59.31/naver-login';
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

         // SharedPreferences에 JWT 저장
        print('자동 로그인');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auto_login', true);

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

  // 카카오 로그인 및 Firebase 로그인
  Future<void> signInWithFirebase(String idToken, String accessToken) async {
    try {
      var provider = OAuthProvider("oidc.login_app");
      var credential =
          provider.credential(idToken: idToken, accessToken: accessToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      print("Firebase 로그인 성공!");
    } catch (e) {
      print("Firebase 로그인 실패: $e");
    }
  }

// 카카오 로그인 후 서버에 사용자 정보 전송
  Future<void> signInWithKakao(
      String id, String name, String idToken, String accessToken) async {
    // 초기화
    _loginStat = false;

    // Firebase 로그인
    await signInWithFirebase(idToken, accessToken); // Firebase 로그인만 처리

    const url = 'http://54.180.59.31/kakao-login';
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

         // SharedPreferences에 JWT 저장
        print('자동 로그인');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auto_login', true);
        
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

  // 사용자 정보 요청
  Future<bool> getUserInfo() async {
    final url = 'http://54.180.59.31/users/info';
    try {
      String? jwt = await storage.read(key: 'jwt');
      print('jwt : $jwt');

      final response = await _dio.get(url,
          options: Options(headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          }));
      if (response.statusCode == 200) {
        final userInfo = response.data;
        print('userInfo : $userInfo');
        if (userInfo == null) {
          return false;
        }
        // provider에 사용자 정보 저장
        _userInfo = app_user.User.fromMap(userInfo);
        notifyListeners();
        return true;
      } else {
        print('사용자 정보 조회 실패');
        return false;
      }
    } catch (e) {
      print('사용자 정보 요청 실패 : $e');
      return false;
    }
  }

  // 자동 로그인
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('auto_login') ?? false;

    if (rememberMe) {
      final jwt = await storage.read(key: 'jwt');
      if (jwt != null) {
        // 사용자 정보 요청
        bool result = await getUserInfo();
        // 응답 성공 시, 로그인 여부 true
        if (result) {
          _loginStat = true;
          notifyListeners();
        }
      }
    }
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
      }
      // 카카오 로그인 상태 확인 후 로그아웃
      final tokenManager = TokenManagerProvider.instance.manager;

      if (tokenManager.getToken() != null) {
        try {
          await UserApi.instance.accessTokenInfo();
          await UserApi.instance.logout();
          print('카카오 로그아웃 성공');
        } catch (e) {}
      }
      // Firebase 로그인 상태 확인 후 로그아웃 (구글 포함)
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
        print('Firebase 로그아웃 성공');
      }

      print('모든 로그인 서비스 로그아웃 완료 🎉');
    } catch (e) {
      print('로그아웃 실패: $e');
    }

    notifyListeners();
  }
}
