import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color.fromARGB(255, 66, 94, 117)),
                child: Text("메뉴", style: TextStyle(color: Colors.white),),
              ),
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
                }
              ),
              _DrawerItem(
                icon: Icons.search,
                text: "검색",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/search');
                }
              ),
              _DrawerItem(
                icon: Icons.category,
                text: "상품",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/product');
                }
              ),
              _DrawerItem(
                icon: Icons.shopping_bag,
                text: "장바구니",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/user/cart');
                }
              ),
            ],
          ),
          bottomSheet: Container(
            color: const Color.fromARGB(255, 66, 94, 117),
            child: 
            // 로그아웃
            // _DrawerItem(
            //   icon: Icons.logout,
            //   text: "로그아웃",
            //   onTap: () {},
            //   color: Colors.white
            //   ),
            // 로그인, 회원가입
            Row(
              children: [
                Expanded(child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/auth/login');
                  },
                  child: Text("로그인", style: TextStyle(color: Colors.white),)
                  )
                ),
                Expanded(child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/auth/join');
                  },
                  child: Text("회원가입", style: TextStyle(color: Colors.white))
                  )
                ),
              ],
            )
          ),
        ),
      );
  }

   // DrawerItem
  Widget _DrawerItem(
    { 
      required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? color,
      MaterialColor? backgroundColor
    }
  ) {
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text),
      tileColor: backgroundColor,
      textColor: color,
      onTap: onTap,
    );
  }
}