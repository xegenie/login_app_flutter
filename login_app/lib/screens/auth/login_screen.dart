import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:login_app/notifications/snackbar.dart';
import 'package:login_app/provider/user_provider.dart';
import 'package:login_app/widgets/custom_button.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
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
                        await GoogleSignIn().signOut(); // 항상 로그아웃 후 새 로그인
                        await userProvider.signInWithGoogle();
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
                      width: double.infinity,
                      height: 50,
                      child: Image.asset(
                        'assets/images/google_login.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      try {
                        const clientId = 'uR8aMYGT5QeEesKQ8Eoe';
                        const clientSecret = 'IBsH1sjga2';
                        const clientName = "login_app";

                        await NaverLoginSDK.initialize(
                          clientId: clientId,
                          clientSecret: clientSecret,
                          clientName: clientName,
                        );

                        await NaverLoginSDK.authenticate(
                          callback: OAuthLoginCallback(
                            onSuccess: () async {
                              await NaverLoginSDK.profile(
                                callback: ProfileCallback(
                                  onSuccess:
                                      (resultCode, message, response) async {
                                    final profile = NaverLoginProfile.fromJson(
                                        response: response);
                                    final id = profile.id;
                                    final email = profile.email;
                                    final name = profile.name;

                                    print("네이버 로그인 성공");

                                    await userProvider.signInWithNaver(
                                        id!, email!, name!);
                                    Snackbar(
                                      text: '네이버 로그인 성공',
                                      icon: Icons.check_circle,
                                      backgroundColor: Colors.green,
                                    ).showSnackbar(context);

                                    Navigator.pop(context);
                                  },
                                  onFailure: (httpStatus, message) {
                                    print("네이버 로그인 실패");
                                    Snackbar(
                                      text: '네이버 로그인 실패',
                                      icon: Icons.error,
                                      backgroundColor: Colors.red,
                                    ).showSnackbar(context);
                                  },
                                  onError: (errorCode, message) {
                                    print("네이버 로그인 에러");

                                    if (message == 'naverapp_not_installed') {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('알림'),
                                          content: Text('네이버 앱이 설치되어 있지 않습니다.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('확인',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Snackbar(
                                        text: '네이버 로그인 에러',
                                        icon: Icons.error,
                                        backgroundColor: Colors.red,
                                      ).showSnackbar(context);
                                    }
                                  },
                                ),
                              );
                            },
                            onFailure: (httpStatus, message) {
                              print("네이버 로그인 실패");
                              Snackbar(
                                text: '네이버 로그인 실패',
                                icon: Icons.error,
                                backgroundColor: Colors.red,
                              ).showSnackbar(context);
                            },
                            onError: (errorCode, message) {
                              print("네이버 로그인 에러");

                              if (message == 'naverapp_not_installed') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('알림'),
                                    content: Text('네이버 앱이 설치되어 있지 않습니다.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('확인',
                                            style: TextStyle(
                                                color: Colors.blueAccent)),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                Snackbar(
                                  text: '네이버 로그인 에러',
                                  icon: Icons.error,
                                  backgroundColor: Colors.red,
                                ).showSnackbar(context);
                              }
                            },
                          ),
                        );
                      } catch (e) {
                        print("네이버 로그인 예외 발생");
                        Snackbar(
                          text: '네이버 로그인 예외 발생',
                          icon: Icons.error,
                          backgroundColor: Colors.red,
                        ).showSnackbar(context);
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Image.asset(
                        'assets/images/naver_login.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 카카오 로그인 버튼
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      print('키 해시 : ' + await KakaoSdk.origin);

                      try {
                        bool isInstalled = await isKakaoTalkInstalled();
                        OAuthToken token;

                        if (isInstalled) {
                          token = await UserApi.instance.loginWithKakaoTalk();
                        } else {
                          token =
                              await UserApi.instance.loginWithKakaoAccount();
                        }

                        final user = await UserApi.instance.me();
                        final id = user.id.toString();
                        final email = user.kakaoAccount?.email ?? 'no-email';
                        final name =
                            user.kakaoAccount?.profile?.nickname ?? 'no-name';

                        print("카카오 로그인 성공: $id / $email / $name");

                        // 카카오 로그인 후 Firebase 로그인과 서버 통합 처리
                        await userProvider.signInWithKakao(id, name,
                            token.idToken ?? '', token.accessToken ?? '');

                        Snackbar(
                          text: '카카오 로그인 성공',
                          icon: Icons.check_circle,
                          backgroundColor: Colors.green,
                        ).showSnackbar(context);

                        Navigator.pop(context);
                      } catch (e) {
                        print("카카오 로그인 실패: $e");
                        Snackbar(
                          text: '카카오 로그인 실패',
                          icon: Icons.error,
                          backgroundColor: Colors.red,
                        ).showSnackbar(context);
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Image.asset(
                        'assets/images/kakao_login.png',
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
}
