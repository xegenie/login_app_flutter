import 'package:flutter/material.dart';
import 'package:login_app/widgets/common_bottom_navigation_bar.dart';
import 'package:login_app/widgets/custom_button.dart';
import 'package:login_app/widgets/custom_drawer.dart';

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
                    decoration: const InputDecoration(
                      labelText: '아이디',
                      hintText: '아이디를 입력해 주세요.',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: '이름',
                      hintText: '이름을을 입력해 주세요.',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: '이메일',
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
