import 'package:flutter/material.dart';
import 'package:login_app/notifications/snackbar.dart';
import 'package:login_app/services/user_service.dart';
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
  String? _phone;
  String? _email;

  final userService = UserService();

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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력해 주세요.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해 주세요.';
                    }
                    if (value.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해 주세요.';
                    }
                    if (value != _password) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해 주세요.';
                    }
                    return null;
                  },
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
                // 휴대폰 번호
                TextFormField(
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '휴대폰 번호를 입력해 주세요.';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return '숫자만 입력 가능합니다.';
                  }
                  return null;
                  },
                  decoration: const InputDecoration(
                  labelText: '휴대폰 번호',
                  hintText: '휴대폰 번호를 입력해 주세요.',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                  },
                ),
                const SizedBox(height: 16),
                // 이메일
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해 주세요.';
                    }
                    bool emailValid =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value);
                    if (!emailValid) {
                      return '올바른 이메일 형식을 입력해 주세요.';
                    }
                    return null;
                  },
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
        onPressed: () async {
          // 유효성 검사
          if (!_formKey.currentState!.validate()) {
            return;
          }
          // 회원가입 요청
          bool result = await userService.registerUser({
            'username': _username!,
            'password': _password!,
            'name': _name!,
            'phone': _phone!,
            'email': _email!,
          });

          if (result) {
            print('회원가입 성공');
            Snackbar(
              text: '회원가입에 성공하였습니다.',
              icon: Icons.check_circle,
              backgroundColor: Colors.green
            ).showSnackbar(context);
            Navigator.pop(context);
          } else {
            print('회원가입 실패');
            Snackbar(
              text: '회원가입에 성공하였습니다.',
              icon: Icons.error,
              backgroundColor: Colors.red
            ).showSnackbar(context);
          }
        },
      ),
    );
  }
}
