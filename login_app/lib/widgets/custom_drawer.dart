import 'package:flutter/material.dart';
import 'package:login_app/notifications/snackbar.dart';
import 'package:login_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    return Drawer(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 66, 94, 117)),
                child: userProvider.isLogin
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person),
                          const SizedBox(width: 8),
                          Text(
                            userProvider.userInfo.name.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu),
                          const SizedBox(width: 8,),
                        Text(
                          '메뉴',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),)
                        ]
                      )),
            _DrawerItem(
              icon: Icons.home,
              text: "홈",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            _DrawerItem(
                icon: Icons.person,
                text: "마이",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/mypage/profile');
                }),
            _DrawerItem(
                icon: Icons.search,
                text: "검색",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/search');
                }),
            _DrawerItem(
                icon: Icons.category,
                text: "상품",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/product');
                }),
            _DrawerItem(
                icon: Icons.shopping_bag,
                text: "장바구니",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/cart');
                }),
          ],
        ),
        bottomSheet: Container(
            color: const Color.fromARGB(255, 66, 94, 117),
            child: userProvider.isLogin
                ?
                // 로그아웃
                _DrawerItem(
                    icon: Icons.logout,
                    text: "로그아웃",
                    onTap: () async {
                      await userProvider.logout();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/');

                      if (!userProvider.isLogin) {
                        Snackbar(
                          text: '로그아웃 되었습니다.',
                          icon: Icons.check_circle_outline,
                          backgroundColor: Colors.red
                        ).showSnackbar(context);
                      }
                    },
                    color: Colors.white)
                :
                // 로그인, 회원가입
                Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/auth/login');
                              },
                              child: Text(
                                "로그인",
                                style: TextStyle(color: Colors.white),
                              ))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/auth/join');
                              },
                              child: Text("회원가입",
                                  style: TextStyle(color: Colors.white)))),
                    ],
                  )),
      ),
    );
  }

  // DrawerItem
  Widget _DrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? color,
      MaterialColor? backgroundColor}) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text),
      tileColor: backgroundColor,
      textColor: color,
      onTap: onTap,
    );
  }
}
