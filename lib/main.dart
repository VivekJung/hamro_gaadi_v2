import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/app_routes.dart';
import 'package:hamro_gaadi/firebase_options.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> intialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: intialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(snapshot.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(const Duration(seconds: 2));
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
