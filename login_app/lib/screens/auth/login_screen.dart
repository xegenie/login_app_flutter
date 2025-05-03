import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                CustomButton(
                  text: "구글 로그인",
                  onPressed: () { },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "네이버 로그인",
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: "카카오톡 로그인",
                  onPressed: () {},
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
}