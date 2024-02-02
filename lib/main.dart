import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
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
                      errorText:
                          _isValidatedPassword ? null : 'Invalid Password',
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
        },
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Login successed'),
          ElevatedButton(onPressed: _logout, child: const Text('Logout')),
        ],
      ),
    );
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }
}
