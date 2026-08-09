import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/screens/welcome/welcome_screen.dart';
import 'package:consome_plus/screens/home/home_screen.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.userName.isEmpty) {
          return const WelcomeScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
