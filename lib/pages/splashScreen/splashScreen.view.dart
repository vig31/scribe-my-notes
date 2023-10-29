// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/customLogger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 550), () async {
      await SharedPreferences.getInstance().then((value) async {
        var res = value.getBool("isFirstLaunch");
        if (res == null || res == true) {
          Navigator.pushReplacementNamed(context, "/onBoarding");
        } else {
          await authTheUser();
        }
      });
    });
  }

  Future<void> authTheUser() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show your notes',
          options: const AuthenticationOptions(
            biometricOnly: false,
            sensitiveTransaction: true,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );
        if (didAuthenticate) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          // User isn't allowed
          Navigator.pushReplacementNamed(context, "/authFail");
        }
      } else {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Image.asset(
            "lib/resources/icons/logo.png",
            width: 112,
            height: 112,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Chck is first launched
  // nav to onboarding
  // nav to home page
}
