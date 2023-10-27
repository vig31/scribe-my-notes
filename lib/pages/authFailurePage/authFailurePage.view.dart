// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthFailurePage extends StatefulWidget {
  const AuthFailurePage({Key? key}) : super(key: key);

  @override
  State<AuthFailurePage> createState() => _AuthFailurePageState();
}

class _AuthFailurePageState extends State<AuthFailurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "lib/resources/images/auth_failed.svg",
                fit: BoxFit.cover,
                width: 240,
                height: 240,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Authentication failed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "The provided credentials do not match.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
