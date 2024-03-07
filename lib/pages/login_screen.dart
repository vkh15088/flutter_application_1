import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/core/shared/themes/app_color_light.dart';

import 'package:flutter_application_1/core/shared/themes/app_dimension.dart';
import 'package:flutter_application_1/core/shared/widgets/c_progress_bar.dart';
import 'package:flutter_application_1/pages/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isValidatedUser = true;
  bool _isValidatedPassword = true;

  bool _isShowProgressBar = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(AppSpacing.extraSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  errorText: _isValidatedUser
                      ? null
                      : AppLocalizations.of(context)!.invalidEmail),
              controller: _controllerEmail,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                errorText: _isValidatedPassword
                    ? null
                    : AppLocalizations.of(context)!.invalidPassword,
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
            Center(
              child: ElevatedButton(
                onPressed: _validateUserInfo,
                child: Text(AppLocalizations.of(context)!.logIn),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              child: Text(AppLocalizations.of(context)!.notHaveAccount,
                  style: const TextStyle(
                    color: AppColorLight.textUnderlineColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColorLight.textUnderlineColor,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const RegisterPage(),
                ));
              },
            )
          ],
        ),
      ),
      CustomProgressBar(isShow: _isShowProgressBar),
    ]);
  }

  void _validateUserInfo() {
    String user = _controllerEmail.text;
    String password = _controllerPassword.text;
    setState(() {
      _isShowProgressBar = true;

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
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.wrongEmailFormat)));
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.wrongEmailOrPassword)));
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.wrongEmail)));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.wrongPassword)));
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.code)));
      }
    }

    setState(() {
      _isShowProgressBar = false;
    });
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
