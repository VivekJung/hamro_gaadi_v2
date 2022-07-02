import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/custom_loading_indicator.dart';
import 'package:hamro_gaadi/resources/error_notifier.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatefulWidget {
  final bool loadStatus;
  const LoginScreen({Key? key, this.loadStatus = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                CircleAvatar(
                    radius: 104,
                    backgroundColor: ColorTheme().primaryColor,
                    child: CircleAvatar(
                        radius: 100,
                        backgroundColor: ColorTheme().whiteColor,
                        child: Icon(
                          Ionicons.car,
                          size: 180,
                          color: ColorTheme().primaryColor,
                        ))),
                const SizedBox(height: 20),
                Text('हाम्रो गाडी',
                    style: TextStyle(
                      fontSize: 42,
                      color: ColorTheme().primaryColor,
                    )),
                const SizedBox(height: 20),
                loginDesign(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginDesign() {
    return Card(
      elevation: 5.0,
      child: Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.alternate_email,
                        color: ColorTheme().primaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No username/email provided';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.lock,
                      color: ColorTheme().primaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: passwordController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Lock-code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'No lock-code provided';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 50,
                      child: emailLoginButton(formKey),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width - 60,
                      child: emailSignupButton(formKey),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text('<-- Swipe -->'),
              )
            ],
          ),
        ),
      ),
    );
  }

  emailLoginButton(formKey) {
    return loginButton(
      "Sign-in with हाम्रो गाडी account",
      Ionicons.car,
      ColorTheme().primaryColor,
      formKey,
    );
  }

  loginButton(String label, IconData icon, Color color, dynamic formkey) {
    bool isLoading = false;
    bool loadingStatus() {
      setState(() {
        isLoading = !isLoading;
        stat(isLoading);
      });
      return isLoading;
    }

    return !isLoading
        ? Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  loadingStatus();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Sending request to cloud')),
                  );

                  await AuthService().emailPasswordLogin(
                      emailController.text, passwordController.text);
                }
              },
              icon: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(18),
                backgroundColor: color,
              ),
              label: Text(
                label,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        : circularLoading(80);
  }

  emailSignupButton(formKey) {
    return signupButton(
      "Register new हाम्रो गाडी account",
      Ionicons.trail_sign,
      ColorTheme().greenColor,
      formKey,
    );
  }

  signupButton(String label, IconData icon, Color color, dynamic formkey) {
    bool isLoading = false;
    bool loadingStatus() {
      setState(() {
        isLoading = !isLoading;
        stat(isLoading);
      });
      return isLoading;
    }

    return !isLoading
        ? Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  loadingStatus();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Sending request to cloud')),
                  );

                  await AuthService().emailPasswordRegister(
                      emailController.text,
                      passwordController.text,
                      null,
                      "user");
                }
              },
              icon: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(18),
                backgroundColor: color,
              ),
              label: Text(
                label,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        : circularLoading(80);
  }
}
