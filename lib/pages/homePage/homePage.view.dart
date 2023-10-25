// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shimmer/shimmer.dart';

import 'homePage.vm.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageVM _instanceOfVM = HomePageVM();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _instanceOfVM.initHomePage();
  }

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
          child: Observer(builder: (context) {
            return Visibility(
              visible: !_instanceOfVM.isLoading,
              replacement: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 21),
                children: [
                  Observer(builder: (context) {
                    return Visibility(
                      // ignore: prefer_is_empty
                      visible: _instanceOfVM.todaysRemainder.length != 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _instanceOfVM.todaysRemainder.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16, ),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: GestureDetector(
                                    onTap: ()async {
                                      await Navigator.pushNamed(context, '/edit',
                                arguments: {
                                  "editNoteId":
                                      _instanceOfVM.todaysRemainder[index].id,
                                  "isEdit": true,
                                });
                                    },
                                    child: Stack(
                                      children: [
                                        Visibility(
                                          visible: !_instanceOfVM
                                              .todaysRemainder[index]
                                              .isAssetAsCoverImage,
                                          replacement: Image.asset(
                                            width: 160,
                                            height: 160,
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (frame != null) {
                                                return child;
                                              } else {
                                                return Shimmer.fromColors(
                                                  baseColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onInverseSurface,
                                                  child: Container(
                                                    width: 160,
                                                    height: 160,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                );
                                              }
                                            },
                                            _instanceOfVM.todaysRemainder[index]
                                                .coverImagePath,
                                          ),
                                          child: Image.file(
                                            fit: BoxFit.cover,
                                            width: 160,
                                            height: 160,
                                            filterQuality: FilterQuality.medium,
                                            File(
                                              _instanceOfVM
                                                  .todaysRemainder[index]
                                                  .coverImagePath,
                                            ),
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (frame != null) {
                                                return child;
                                              } else {
                                                return Shimmer.fromColors(
                                                  baseColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onInverseSurface,
                                                  child: Container(
                                                    width: 160,
                                                    height: 160,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 160,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.05),
                                                Colors.black.withOpacity(0.1),
                                                Colors.black.withOpacity(0.9)
                                              ],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 0, 12, 8),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                _instanceOfVM
                                                    .todaysRemainder[index].title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 16,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
                  Observer(builder: (context) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _instanceOfVM.allNotes.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/edit',
                                arguments: {
                                  "editNoteId":
                                      _instanceOfVM.allNotes[index].id,
                                  "isEdit": true,
                                });
                          },
                          title: Text(_instanceOfVM.allNotes[index].title),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          }),
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
