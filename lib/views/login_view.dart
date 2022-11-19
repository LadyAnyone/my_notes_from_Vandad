import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn_project/main.dart';

import '../firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false, //otomatik düzeltme
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email here'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false, //öneriler
                    autocorrect: false, //otomatik düzeltme
                    decoration: const InputDecoration(
                        hintText: 'Enter yours password here'),
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
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('user not found');
                        }
                        // print('something bad happened ');
                        // print(e.runtimeType);
                        // print(e);
                        else if (e.code == 'wrong-password') {
                          print('Wrong Password');
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              );
              break;
            default:
              return const Text('Loading..');
          }
        },
      ),
    );
  }
}
