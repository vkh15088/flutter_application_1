import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_application_1/core/shared/themes/app_dimension.dart';
import 'package:flutter_application_1/core/shared/widgets/c_progress_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isValidatedUser = true;
  bool _isValidatedPassword = true;

  bool _isShowProgressBar = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.register),
        ),
        body: Container(
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
                  child: Text(AppLocalizations.of(context)!.register),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      CustomProgressBar(isShow: _isShowProgressBar)
    ]);
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
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

      _registerUser();
    });
  }

  void _registerUser() async {
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.emailExisted)));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.wrongEmailFormat)));
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.weakPassword)));
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.code)));
      }
    }

    _isShowProgressBar = false;

    if (userCredential != null) {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
