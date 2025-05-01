import 'package:flutter/material.dart';
import 'package:login_app/widgets/custom_button.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;
  String? _confirmPassword;
  String? _name;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
                // 아이디
                TextFormField(
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
                const SizedBox(height: 16),
                // 비밀번호
                TextFormField(
                  validator: (value) {},
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력해 주세요.',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 비밀번호 확인
                TextFormField(
                  validator: (value) {},
                  decoration: const InputDecoration(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 입력해 주세요.',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _confirmPassword = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 이름
                TextFormField(
                  validator: (value) {},
                  decoration: const InputDecoration(
                    labelText: '이름',
                    hintText: '이름을 입력해 주세요.',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 이메일
                TextFormField(
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
                const SizedBox(height: 100), // bottomSheet 공간 확보
              ],
            ),
          ),
        ),
      ),
      bottomSheet: CustomButton(
          text: '회원가입',
          isFullWidth: true,
          onPressed: () {},
        ),
    );
  }
}
