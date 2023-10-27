import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'searchPage.vm.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchFieldController = TextEditingController();
  final _instanceOfSearchPageVM = SearchPageVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          enableFeedback: true,
          iconSize: 21,
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: const ImageIcon(
            AssetImage(
              "lib/resources/icons/backarrow.png",
            ),
          ),
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          tooltip: "Go Back",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const SizedBox(height: 16,),
          SizedBox(
            height: 56,
            child: TextFormField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    gapPadding: 0,
                    borderSide: BorderSide.none),
                hintText: "Enter title or note to find",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
              ),
              onChanged: _instanceOfSearchPageVM.debounceQuery,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Observer(builder: (ctx) {
            return Visibility(
              visible: _instanceOfSearchPageVM.isLoading,
              replacement: Visibility(
                visible: _instanceOfSearchPageVM.quiredNotes.isNotEmpty,
                replacement: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      SvgPicture.asset(
                        "lib/resources/images/search_notes.svg",
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    ]),
                child: LayoutBuilder(builder: (context, constrain) {
                  var crossAxisCount = 2; // default mobile view

                  if (constrain.maxWidth > 480 && constrain.maxWidth < 932) {
                    crossAxisCount = 3; // mobile in landscape
                  } else if (constrain.maxWidth > 932) {
                    crossAxisCount = 5; // tablet
                  }
                  return MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      itemCount: _instanceOfSearchPageVM.quiredNotes.length,
                      itemBuilder: (context, index) {
                        var ft = Future(() => EditorState(
                                document: Document.fromJson(
                              jsonDecode(
                                _instanceOfSearchPageVM.quiredNotes[index].note,
                              ),
                            )));

                        List<String> finalText = [];

                        EditorState(
                            document: Document.fromJson(
                          jsonDecode(
                            _instanceOfSearchPageVM.quiredNotes[index].note,
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
                                  "editNoteId": _instanceOfSearchPageVM
                                      .quiredNotes[index].id,
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
                                  visible: _instanceOfSearchPageVM
                                      .quiredNotes[index].title.isNotEmpty,
                                  child: Text(
                                    _instanceOfSearchPageVM
                                        .quiredNotes[index].title,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !_instanceOfSearchPageVM
                                      .quiredNotes[index].isAssetAsCoverImage,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_instanceOfSearchPageVM
                                            .quiredNotes[index].coverImagePath),
                                        height: 88,
                                        width: double.maxFinite,
                                        filterQuality: FilterQuality.low,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          if (frame != null) {
                                            return child;
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              highlightColor: Theme.of(context)
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
                                                          EditorStyle.mobile(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        selectionColor: Theme
                                                                .of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                        textStyleConfiguration:
                                                            TextStyleConfiguration(
                                                          text:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!,
                                                          code:
                                                              Theme.of(context)
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
                                          _instanceOfSearchPageVM
                                              .quiredNotes[index].createdAt),
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Theme.of(context).disabledColor,
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
                }),
              ),
              child: const LinearProgressIndicator(),
            );
          })
        ],
      ),
    );
  }
}
