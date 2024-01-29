import 'package:flutter/material.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        body: Container(
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
                child: const Text('Login'),
                onPressed: _validateUserInfo,
              )
            ],
          ),
        ));
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
    });
  }

  @override
  void dispose() {
    _controllerUser.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
