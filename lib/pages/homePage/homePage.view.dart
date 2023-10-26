// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homePage.vm.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageVM _instanceOfVM = HomePageVM();
  String appVersion = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppVersion();
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                          context, '/edit',
                                          arguments: {
                                            "editNoteId": _instanceOfVM
                                                .todaysRemainder[index].id,
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
                                            cacheHeight: 450,
                                            cacheWidth: 450,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                            },
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
                                                    .todaysRemainder[index]
                                                    .title,
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
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.pinnedNotes.length != 0,
                      child: const SizedBox(
                        height: 16,
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.pinnedNotes.length != 0,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Pinned Notes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.pinnedNotes.length != 0,
                      child: const SizedBox(
                        height: 16,
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return LayoutBuilder(builder: (context, constrain) {
                      var crossAxisCount = 2; // default mobile view

                      if (constrain.maxWidth > 480 &&
                          constrain.maxWidth < 932) {
                        crossAxisCount = 3; // mobile in landscape
                      } else if (constrain.maxWidth > 932) {
                        crossAxisCount = 5; // tablet
                      }
                      return MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          itemCount: _instanceOfVM.pinnedNotes.length,
                          itemBuilder: (context, index) {
                            var ft = Future(() => EditorState(
                                    document: Document.fromJson(
                                  jsonDecode(
                                    _instanceOfVM.pinnedNotes[index].note,
                                  ),
                                )));

                            List<String> finalText = [];

                            EditorState(
                                document: Document.fromJson(
                              jsonDecode(
                                _instanceOfVM.pinnedNotes[index].note,
                              ),
                            )).document.root.children.map((e) {
                              return e.attributes;
                            }).map((element) {
                              if ((element['delta'] != null)) {
                                return (element['delta']);
                              }
                            }).forEach((element) {
                              if (element != null && element.length > 0) {
                                for (var element in (element as List)) {
                                  finalText.add((element['insert']));
                                }
                              }
                            });

                            var noteContent = finalText
                                .join(" ")
                                .trim()
                                .replaceAll(RegExp(r' +'), ' ')
                                .trim();

                            bool isShowEditor = noteContent.isNotEmpty;
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(context, '/edit',
                                    arguments: {
                                      "editNoteId":
                                          _instanceOfVM.pinnedNotes[index].id,
                                      "isEdit": true,
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withOpacity(0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: _instanceOfVM
                                          .pinnedNotes[index].title.isNotEmpty,
                                      child: Text(
                                        _instanceOfVM.pinnedNotes[index].title,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_instanceOfVM.pinnedNotes[index]
                                          .isAssetAsCoverImage,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(_instanceOfVM
                                                .pinnedNotes[index]
                                                .coverImagePath),
                                            height: 88,
                                            width: double.maxFinite,
                                            filterQuality: FilterQuality.low,
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
                                                    height: 88,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    isShowEditor == true
                                        ? ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 150.0,
                                            ),
                                            child: FutureBuilder(
                                                future: ft,
                                                builder: (context, snapshot) {
                                                  return !snapshot.hasData
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator
                                                                  .adaptive())
                                                      : AppFlowyEditor(
                                                          editorStyle:
                                                              EditorStyle
                                                                  .mobile(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            cursorColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                            selectionColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                            textStyleConfiguration:
                                                                TextStyleConfiguration(
                                                              text: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!,
                                                              code: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontFamily:
                                                                        'SourceCodePro',
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimaryContainer,
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primaryContainer,
                                                                  ),
                                                            ),
                                                            textSpanDecorator:
                                                                defaultTextSpanDecoratorForAttribute,
                                                          ),
                                                          editable: false,
                                                          editorState:
                                                              snapshot.data!,
                                                        );
                                                }),
                                          )
                                        : const SizedBox.shrink(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          DateFormat('E, d MMM yy').format(
                                              _instanceOfVM.pinnedNotes[index]
                                                  .createdAt),
                                          maxLines: 3,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
                  }),
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.allNotes.length != 0,
                      child: const SizedBox(
                        height: 16,
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.allNotes.length != 0,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "All Notes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return Visibility(
                      visible: _instanceOfVM.allNotes.length != 0,
                      child: const SizedBox(
                        height: 16,
                      ),
                    );
                  }),
                  Observer(builder: (context) {
                    return LayoutBuilder(builder: (context, constrain) {
                      var crossAxisCount = 2; // default mobile view

                      if (constrain.maxWidth > 480 &&
                          constrain.maxWidth < 932) {
                        crossAxisCount = 3; // mobile in landscape
                      } else if (constrain.maxWidth > 932) {
                        crossAxisCount = 5; // tablet
                      }
                      return MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          itemCount: _instanceOfVM.allNotes.length,
                          itemBuilder: (context, index) {
                            var ft = Future(() => EditorState(
                                    document: Document.fromJson(
                                  jsonDecode(
                                    _instanceOfVM.allNotes[index].note,
                                  ),
                                )));

                            List<String> finalText = [];

                            EditorState(
                                document: Document.fromJson(
                              jsonDecode(
                                _instanceOfVM.allNotes[index].note,
                              ),
                            )).document.root.children.map((e) {
                              return e.attributes;
                            }).map((element) {
                              if ((element['delta'] != null)) {
                                return (element['delta']);
                              }
                            }).forEach((element) {
                              if (element != null && element.length > 0) {
                                for (var element in (element as List)) {
                                  finalText.add((element['insert']));
                                }
                              }
                            });

                            var noteContent = finalText
                                .join(" ")
                                .trim()
                                .replaceAll(RegExp(r' +'), ' ')
                                .trim();

                            bool isShowEditor = noteContent.isNotEmpty;
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(context, '/edit',
                                    arguments: {
                                      "editNoteId":
                                          _instanceOfVM.allNotes[index].id,
                                      "isEdit": true,
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withOpacity(0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: _instanceOfVM
                                          .allNotes[index].title.isNotEmpty,
                                      child: Text(
                                        _instanceOfVM.allNotes[index].title,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_instanceOfVM
                                          .allNotes[index].isAssetAsCoverImage,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(
                                              _instanceOfVM.allNotes[index]
                                                  .coverImagePath,
                                            ),
                                            height: 88,
                                            width: double.maxFinite,
                                            filterQuality: FilterQuality.low,
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
                                                    height: 88,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    isShowEditor == true
                                        ? ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 150.0,
                                            ),
                                            child: FutureBuilder(
                                                future: ft,
                                                builder: (context, snapshot) {
                                                  return !snapshot.hasData
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator
                                                                  .adaptive())
                                                      : AppFlowyEditor(
                                                          editorStyle:
                                                              EditorStyle
                                                                  .mobile(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            cursorColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                            selectionColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                            textStyleConfiguration:
                                                                TextStyleConfiguration(
                                                              text: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!,
                                                              code: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontFamily:
                                                                        'SourceCodePro',
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimaryContainer,
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primaryContainer,
                                                                  ),
                                                            ),
                                                            textSpanDecorator:
                                                                defaultTextSpanDecoratorForAttribute,
                                                          ),
                                                          editable: false,
                                                          editorState:
                                                              snapshot.data!,
                                                        );
                                                }),
                                          )
                                        : const SizedBox.shrink(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          DateFormat('E, d MMM yy').format(
                                              _instanceOfVM
                                                  .allNotes[index].createdAt),
                                          maxLines: 3,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
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
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    enableDrag: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    isDismissible: false,
                    elevation: 10,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: MediaQuery.of(context).size.width,
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const CircleAvatar(
                                radius: 48,
                                backgroundImage: AssetImage(
                                    "lib/resources/images/ic_profile.png"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await launchUrl(Uri.parse(
                                      "https://www.linkedin.com/in/vig31?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"));

                                  Navigator.pop(context);
                                },
                                child: const Text("Vignesh Veeraswamy",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                'Scribe My Notes',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Text(
                                'Made with ❤️ in flutter',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 1.8,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text("V $appVersion",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Theme.of(context).disabledColor)),
                              const SizedBox(
                                height: 4.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: ImageIcon(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                  const AssetImage(
                    "lib/resources/icons/info.png",
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

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }
}
