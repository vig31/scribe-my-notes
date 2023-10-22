// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'homePage.vm.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageVM _instanceOfVM = HomePageVM();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarColor:
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.light
                ? Colors.white
                : Theme.of(context).colorScheme.secondaryContainer,
        statusBarBrightness:
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.light
                ? Brightness.light
                : Brightness.dark,
        statusBarIconBrightness:
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarIconBrightness:
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 21),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Today's Reminders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        width: 160,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text("data")],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Pinned Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 10,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      height: 160,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("data")],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 21,
          shadowColor: Theme.of(context).colorScheme.tertiaryContainer,
          surfaceTintColor: Colors.transparent,
          color:
              SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                      Brightness.light
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondaryContainer,
          height: 80,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: ImageIcon(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                  const AssetImage(
                    "lib/resources/icons/menu.png",
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/search');
                },
                icon: ImageIcon(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                  const AssetImage(
                    "lib/resources/icons/search.png",
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          elevation: 4,
          enableFeedback: true,
          tooltip: "Create new note",
          onPressed: () async {
            await Navigator.pushNamed(context, '/create');
          },
          child: const Icon(
            Icons.add_rounded,
            size: 24,
          ),
        ),
      ),
    );
  }
}
