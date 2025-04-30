import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
      ),
      body: Center(
        child: const Text("홈 화면"),
      ),
      endDrawer: Drawer(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("메뉴"),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.black,),
                title: Text("홈"),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.black,),
                title: Text("마이"),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.black,),
                title: Text("상품"),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.black,),
                title: Text("장바구니"),
              ),
            ],
          ),
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