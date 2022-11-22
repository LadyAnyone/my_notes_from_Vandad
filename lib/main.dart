import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_learn_project/views/login_view.dart';
import 'package:flutter_learn_project/views/register_view.dart';
import 'package:flutter_learn_project/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/verify/': (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            //final user = FirebaseAuth.instance.currentUser;
            return const LoginView();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
