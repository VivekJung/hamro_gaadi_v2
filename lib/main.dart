import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/app_routes.dart';
import 'package:hamro_gaadi/firebase_options.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:provider/provider.dart';

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
            return MultiProvider(
              providers: [
                StreamProvider(
                  create: (BuildContext context) => AuthService().userStream,
                  initialData: const [],
                ),
                StreamProvider<List<Entries>>(
                  create: (BuildContext context) =>
                      FirestoreService().streamAllEntries(),
                  initialData: const [],
                ),
              ],
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'हाम्रो गाडी',
                  theme: ThemeData(
                    primarySwatch: ColorTheme().primaryColor,
                  ),
                  initialRoute: '/',
                  routes: appRoutes(),
                );
              },
            );
          }
          return const Center(
              child: CircularProgressIndicator(strokeWidth: 20));
        });
  }
}
