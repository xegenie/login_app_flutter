import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:login_app/provider/user_provider.dart';
import 'package:login_app/screens/auth/join_screen.dart';
import 'package:login_app/screens/auth/login_screen.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/screens/mypage/profile_screen.dart';
import 'package:login_app/screens/user/cart_screen.dart';
import 'package:login_app/screens/user/product_screen.dart';
import 'package:login_app/screens/user/search_screen.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔹 로그인 SDK 초기화
  NaverLoginSDK.initialize(
    clientId: "uR8aMYGT5QeEesKQ8Eoe",
    clientSecret: "IBsH1sjga2",
  );
  KakaoSdk.init(
    nativeAppKey: '44d474a9e84f539aa2e9025bc229c663',
    javaScriptAppKey: 'a20dbb2c90354d0aa902f5e7370ce7cf',
  );



  runApp(
      // Provider
      // - ChagneNotifierProvider 를 사용하여 전역으로 사용할 수 있도록 지정
      ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));

  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // 앱 실행 시, 자동로그인
    Provider.of<UserProvider>(context, listen: false).autoLogin();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomeScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/auth/join':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  JoinScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/auth/login':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoginScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/search':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SearchScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/product':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProductScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/cart':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CartScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/mypage/profile':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProfileScreen(),
              transitionDuration: Duration(seconds: 0),
            );
        }
      },
    );
  }
}
