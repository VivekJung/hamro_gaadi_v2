import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hamro_gaadi/resources/custom_loading_indicator.dart';
import 'package:hamro_gaadi/resources/error_notifier.dart';
import 'package:hamro_gaadi/screens/home_screen.dart';
import 'package:hamro_gaadi/screens/login.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:provider/provider.dart';

class RouteCheckScreen extends StatelessWidget {
  const RouteCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (conext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularLoading(60);
        } else if (snapshot.hasError) {
          return errorMessage("");
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
