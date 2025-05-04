import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login_app/notifications/snackbar.dart';
import 'package:login_app/provider/user_provider.dart';
import 'package:login_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _rememberId = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Provider 선언
    // listen
    // - true : 변경사항을 수신 대기⭕ (구독)
    // - false : 변경사항을 수신 대기❌ (구독 안함)
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
                // 아이디 입력
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력해 주세요.',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // 비밀번호 입력
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해 주세요.',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: const Text("자동 로그인"),
                    ),
                    Checkbox(
                      value: _rememberId,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberId = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberId = !_rememberId;
                        });
                      },
                      child: const Text("아이디 저장"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "로그인",
                  onPressed: () async {
                    // 유효성 검사
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    // 로그인 요청
                    await userProvider.login(username, password);

                    if (userProvider.isLogin) {
                      print('로그인 성공');

                      Snackbar(
                              text: '로그인에 성공하였습니다.',
                              icon: Icons.check_circle,
                              backgroundColor: Colors.green)
                          .showSnackbar(context);

                      Navigator.pop(context);
                    } else {
                      print('로그인 실패');

                      Snackbar(
                              text: '로그인에 실패하였습니다.',
                              icon: Icons.check_circle,
                              backgroundColor: Colors.red)
                          .showSnackbar(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      try {
                        await signInWithGoogle();
                        Snackbar(
                          text: '구글 로그인 성공',
                          icon: Icons.check_circle,
                          backgroundColor: Colors.green,
                        ).showSnackbar(context);
                        Navigator.pop(context);
                      } catch (e) {
                        Snackbar(
                          text: '구글 로그인 실패',
                          icon: Icons.error,
                          backgroundColor: Colors.red,
                        ).showSnackbar(context);
                      }
                    },
                    child: SizedBox(
                      width: double.infinity, // 또는 원하는 너비
                      height: 50,
                      child: Image.asset(
                        'assets/images/google_login.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('아이디 찾기')),
                    TextButton(onPressed: () {}, child: const Text('비밀번호 찾기')),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "회원가입",
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    Navigator.pushNamed(context, "/auth/join");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
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
      final name = userCredential.user?.displayName ?? 'Unknown';

      // 3. 서버에 로그인 요청 (JWT 토큰 받기)
      final jwtToken = await _loginWithGoogle(email, name);

      // 4. JWT 토큰 저장 (SharedPreferences 등 사용 가능)
      print('JWT Token: $jwtToken');
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  // 서버에 구글 로그인 정보를 전달하여 JWT 토큰 받기
  Future<String?> _loginWithGoogle(String? email, String? name) async {
    if (email == null || name == null) return null;

    try {
      Dio dio = Dio();

      final response = await dio.post(
        'http://10.0.2.2:8080/google-login',
        data: jsonEncode({
          'email': email,
          'name': name,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception('구글 로그인 서버 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during Google login request: $e');
      return null;
    }
  }
}
