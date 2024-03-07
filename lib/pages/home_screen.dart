import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/shared/widgets/c_progress_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isShowProgressBar = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.loginSuccessed),
              ElevatedButton(onPressed: _logout, child: const Text('Logout')),
            ],
          ),
        ),
        CustomProgressBar(isShow: _isShowProgressBar),
      ],
    );
  }

  void _logout() {
    setState(() {
      _isShowProgressBar = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      FirebaseAuth.instance.signOut();

      setState(() {
        _isShowProgressBar = false;
      });
    });
  }
}
