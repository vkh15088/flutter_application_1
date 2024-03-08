import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_application_1/core/shared/form/app_form_state.dart';
import 'package:flutter_application_1/core/shared/form/email.dart';
import 'package:flutter_application_1/core/shared/form/password.dart';
import 'package:flutter_application_1/core/shared/themes/app_color_light.dart';
import 'package:flutter_application_1/core/shared/themes/app_dimension.dart';
import 'package:flutter_application_1/core/shared/widgets/c_progress_bar.dart';
import 'package:flutter_application_1/pages/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  late final TextEditingController _emailcontroller;
  late final TextEditingController _passwordController;
  final bool _isValidatedUser = true;
  final bool _isValidatedPassword = true;

  bool _isShowProgressBar = false;

  final _key = GlobalKey<FormState>();
  late AppFormState _state;

  @override
  void initState() {
    super.initState();
    _state = AppFormState();
    _emailcontroller = TextEditingController(text: _state.email.value)
      ..addListener(_onEmailChanged);
    _passwordController = TextEditingController(text: _state.password.value)
      ..addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(email: Email.dirty(_emailcontroller.text));
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _state =
          _state.copyWith(password: Password.dirty(_passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(AppSpacing.extraSmall),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                key: const Key("login_emailInput"),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    errorText: _isValidatedUser
                        ? null
                        : AppLocalizations.of(context)!.invalidEmail),
                controller: _emailcontroller,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    _state.email.validator(value ?? '')?.text(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key("login_passwordInput"),
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
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    _state.password.validator(value ?? '')?.text(),
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
      ),
      CustomProgressBar(isShow: _isShowProgressBar),
    ]);
  }

  Future<void> _validateUserInfo() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _isShowProgressBar = true;
      _state = _state.copyWith(status: FormzSubmissionStatus.inProgress);
    });

    try {
      await _signIn();
      _state = _state.copyWith(status: FormzSubmissionStatus.success);
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
      _state = _state.copyWith(status: FormzSubmissionStatus.failure);
    }

    _isShowProgressBar = false;

    setState(() {});
  }

  // void resetForm() {
  //   _key.currentState!.reset();
  //   _emailcontroller.clear();
  //   _passwordController.clear();
  //   setState(() => _state = AppFormState());
  // }

  Future<void> _signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
