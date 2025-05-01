import 'package:flutter/material.dart';
import 'package:login_app/screens/auth/join_screen.dart';
import 'package:login_app/screens/auth/login_screen.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/screens/mypage/profile_screen.dart';
import 'package:login_app/screens/user/cart_screen.dart';
import 'package:login_app/screens/user/product_screen.dart';
import 'package:login_app/screens/user/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
              pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/auth/join':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => JoinScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/auth/login':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/search':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/product':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ProductScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/user/cart':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
              transitionDuration: Duration(seconds: 0),
            );
          case '/mypage/profile':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(),
              transitionDuration: Duration(seconds: 0),
            );
        }
      },
    );
  }
}

