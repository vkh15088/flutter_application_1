import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isValidatedUser = true;
  bool _isValidatedPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                labelText: 'User',
                errorText: _isValidatedUser ? null : 'Invalid User'),
            controller: _controllerUser,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _isValidatedPassword ? null : 'Invalid Password',
              suffixIcon: GestureDetector(
                child: isPasswordVisible
                    ? const Icon(
                        Icons.visibility,
                      )
                    : const Icon(
                        Icons.visibility_off,
                      ),
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: isPasswordVisible ? false : true,
            controller: _controllerPassword,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _validateUserInfo,
            child: const Text('Login'),
          )
        ],
      ),
    );
  }

  void _validateUserInfo() {
    String user = _controllerUser.text;
    String password = _controllerPassword.text;
    setState(() {
      if (user.isEmpty || !user.contains("@")) {
        _isValidatedUser = false;
      } else {
        _isValidatedUser = true;
      }

      if (password.isEmpty || password.length < 8) {
        _isValidatedPassword = false;
      } else {
        _isValidatedPassword = true;
      }

      _signIn();
    });
  }

  Future _signIn() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerUser.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Wrong email format')));
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong user or password')));
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Wrong user')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Wrong password')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code)));
      }
    }
  }

  @override
  void dispose() {
    _controllerUser.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
