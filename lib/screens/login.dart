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
                  height: MediaQuery.of(context).size.height * 0.1,
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

  emailLoginButton(formKey) {
    return LoginButton(
      label: "Sign-in with हाम्रो गाडी account",
      icon: Ionicons.car,
      color: ColorTheme().primaryColor,
      formkey: formKey,
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    );
  }

  loginDesign() {
    return Padding(
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
            emailLoginButton(formKey),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final dynamic formkey;
  final String email, password;

  const LoginButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.formkey,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool isLoading = false;
  bool loadingStatus() {
    setState(() {
      isLoading = !isLoading;
      stat(isLoading);
    });
    return isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (widget.formkey.currentState!.validate()) {
                  loadingStatus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Sending request to cloud')),
                  );
                  await AuthService().emailPasswordLogin(
                      widget.email, widget.password, context);
                }
              },
              icon: Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(18),
                backgroundColor: widget.color,
              ),
              label: Text(
                widget.label,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        : circularLoading(80);
  }
}
