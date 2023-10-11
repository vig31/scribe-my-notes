// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      // body: ,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: Icon(
          Icons.add_rounded,
          size: 24,
        ),
      ),
    );
  }
}
