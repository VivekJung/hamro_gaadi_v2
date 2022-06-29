import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    var user = AuthService().user;
    log('${user?.photoURL} photo');
    log('${user?.displayName} name');

    if (user != null) {
      return profileContents(user, context, navigator);
    } else {
      return noUserDisplay(navigator);
    }

    // return circularLoading(200);
  }

  profileContents(User user, BuildContext context, NavigatorState navigator) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            //profile picture
            Container(
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.photoURL ?? ""),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.displayName ?? 'Handler',
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
            Text(user.email ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white)),
            const SizedBox(height: 20),
            // quiz count

            const SizedBox(height: 20),
            const Spacer(),

            const SizedBox(height: 20),
            //signOut button
            ProfileButtons(
              btnFunction: () async {
                var logOutStatus = await AuthService().signOut();

                if (logOutStatus == null) {
                  navigator.pushNamedAndRemoveUntil('/', (route) => false);
                } else {
                  log('Error while loging out - UI, $logOutStatus');
                }
                //
              },
              btnColor: Colors.redAccent,
              btnIcon: Icons.logout_sharp,
              label: 'Sign Out',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  noUserDisplay(NavigatorState navigator) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No user DATA found'),
            ProfileButtons(
              btnFunction: () async {
                var logOutStatus = await AuthService().signOut();

                if (logOutStatus == null) {
                  navigator.pushNamedAndRemoveUntil('/', (route) => false);
                } else {
                  log('Error while logging out - UI, $logOutStatus');
                }
                //
              },
              btnColor: Colors.red.shade700,
              btnIcon: Icons.logout_sharp,
              label: 'Try logging in again',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    Key? key,
    required this.btnFunction,
    required this.btnColor,
    required this.btnIcon,
    required this.label,
  }) : super(key: key);

  final Function()? btnFunction;
  final Color? btnColor;
  final IconData btnIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: ElevatedButton.icon(
        onPressed: btnFunction ?? () {},
        //

        icon: Icon(
          btnIcon,
          color: Colors.white,
          size: 24,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: btnColor ?? ColorTheme().bgColor1,
        ),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
