import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false, //otomatik düzeltme
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false, //öneriler
            autocorrect: false, //otomatik düzeltme
            decoration:
                const InputDecoration(hintText: 'Enter yours password here'),
          ),
          TextButton(
            onPressed: () async {
              await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform);

              final email = _email.text;
              final password = _password.text;

              try {
                //await unutma
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log('user not found');
                }
                // print('something bad happened ');
                // print(e.runtimeType);
                // print(e);
                else if (e.code == 'wrong-password') {
                  devtools.log('Wrong Password');
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
                (route) => false,
              );
            },
            child: const Text(
              'Not register yet?Register here!',
            ),
          )
        ],
      ),
    );
  }
}
