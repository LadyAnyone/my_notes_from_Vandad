import 'package:flutter/material.dart';
import 'package:flutter_learn_project/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../enums/menu_actions.dart'; //ihtiyacın olan pakete isim ver, ihtiyacın olan kısmına 'show' ile eriş.

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);

                  if (shouldLogout) {
                    AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (_) => false);
                  }
              }
              //devtools.log(value.toString
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log Out'))
              ];
            },
          ),
        ],
      ),
      body: Column(),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign  out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
