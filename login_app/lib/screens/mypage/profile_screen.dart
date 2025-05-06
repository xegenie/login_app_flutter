import 'package:flutter/material.dart';
import 'package:login_app/notifications/snackbar.dart';
import 'package:login_app/provider/user_provider.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/widgets/common_bottom_navigation_bar.dart';
import 'package:login_app/widgets/custom_button.dart';
import 'package:login_app/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _name;
  String? _email;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    // 로그인 상태 확인
    if (!userProvider.isLogin) {
      // 리다이렉트
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 남아있는 스택이 있는지 확인
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, "/auth/login");
        Snackbar(
                text: '로그인이 필요합니다.',
                backgroundColor: Colors.red,
                icon: Icons.error)
            .showSnackbar(context);
      });

      return const HomeScreen();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("마이"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                      child: Text(
                    '프로필 정보',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  // 아이디
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {},
                    decoration: InputDecoration(
                      labelText: userProvider.userInfo.username,
                      hintText: '아이디를 입력해 주세요.',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // 이름
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {},
                    decoration: InputDecoration(
                      labelText: userProvider.userInfo.name,
                      hintText: '이름을을 입력해 주세요.',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // 이메일
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {},
                    decoration: InputDecoration(
                      labelText: userProvider.userInfo.email,
                      hintText: '이메일을 입력해 주세요.',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      text: '회원 탈퇴',
                      backgroundColor: Colors.redAccent,
                      isFullWidth: true,
                      onPressed: () {})
                ],
              )),
        ),
        bottomSheet:
            CustomButton(text: '회원정보 수정', isFullWidth: true, onPressed: () {}),
        endDrawer: CustomDrawer(),
        bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 4));
  }
}
