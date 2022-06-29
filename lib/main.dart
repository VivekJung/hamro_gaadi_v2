import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/app_routes.dart';
import 'package:hamro_gaadi/firebase_options.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/screens/home_screen.dart';

void main() {
  Future<FirebaseApp> intialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(
    initialization: intialization,
  ));
}

class MyApp extends StatelessWidget {
  final dynamic initialization;
  const MyApp({Key? key, this.initialization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'हाम्रो गाडी',
              theme: ThemeData(
                primarySwatch: ColorTheme().primaryColor,
              ),
              routes: appRoutes,
            );
          }
          return const Center(
              child: CircularProgressIndicator(strokeWidth: 20));
        });
  }
}
