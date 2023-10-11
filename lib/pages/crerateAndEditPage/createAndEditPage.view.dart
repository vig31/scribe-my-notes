// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:notebook/helpers/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../reuseables/widgets/customAppflowyMobileToolBar.dart';
import '../../reuseables/widgets/customAppflowyToolBarItems.dart';
import 'package:path_provider/path_provider.dart';

class CreateAndEditPageView extends StatefulWidget {
  const CreateAndEditPageView({Key? key}) : super(key: key);

  @override
  State<CreateAndEditPageView> createState() => _CreateAndEditPageViewState();
}

class _CreateAndEditPageViewState extends State<CreateAndEditPageView> {
  final json = {
    'document': {
      'type': 'page',
      'children': [
        {
          "type": "heading",
          "data": {
            "level": 1,
            "delta": [
              {"insert": "👋 "},
              {
                "insert": "Welcome to",
                "attributes": {"bold": true}
              },
              {"insert": " "},
              {
                "insert": "Note Book",
                "attributes": {"italic": true, "bold": false}
              }
            ],
          }
        },
      ]
    }
  };
  late final editorState = EditorState(
    document: Document.fromJson(json),
  ); // with an empty paragraph
  Future<void> convertMarkdownToPdfAndSave(String markdownContent) async {
    var result = await Permission.manageExternalStorage.request();

    final tempdirectory = await getTemporaryDirectory();

    // ignore: use_build_context_synchronously
    String pathtosave = await FilesystemPicker.open(
          title: 'Save to folder',
          context: context,
          rootDirectory: Directory("/storage/emulated/0"),
          fsType: FilesystemType.folder,
          requestPermission: () async =>
              await Permission.manageExternalStorage.request().isGranted,
          pickText: 'Save file to this folder',
        ) ??
        "";
    // // final directory = await getDownloadsDirectory();
    // final filePath = '${path}/output.md';

    // // Save the PDF to the downloads directory
    final file = File(tempdirectory.path + "/tempmdfile.md");
    await file.writeAsString(markdownContent);
    saveMdtopdf(
        mdfilepath: file.path,
        outputFilepath: "${pathtosave}/sampleoutput.pdf");
  }
  // /storage/emulated/0/Android/data/com.vigneshveeraswamy.notebook/files/downloads/output.pdf

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            enableFeedback: true,
            iconSize: 21,
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage(
                "lib/resources/icons/backarrow.png",
              ),
            ),
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            tooltip: "Go Back",
          ),
          actions: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                enableFeedback: true,
                iconSize: 18,
                onPressed: () async {
                  print(documentToMarkdown(editorState.document));

                  await convertMarkdownToPdfAndSave(
                      documentToMarkdown(editorState.document));
                },
                icon: const ImageIcon(
                  AssetImage(
                    "lib/resources/icons/pin.png",
                  ),
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tooltip: "Pin it",
              ),
            ),
            // const SizedBox(
            //   width: 12,
            // ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                enableFeedback: true,
                iconSize: 18,
                onPressed: () {},
                icon: const ImageIcon(
                  AssetImage(
                    "lib/resources/icons/bell.png",
                  ),
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tooltip: "Add remainder",
              ),
            ),
            // const SizedBox(
            //   width: 12,
            // ),
            SizedBox(
              // width: 24,
              // height: 24,
              child: IconButton(
                enableFeedback: true,
                iconSize: 18,
                onPressed: () {},
                icon: const ImageIcon(
                  AssetImage(
                    "lib/resources/icons/bookmark.png",
                  ),
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tooltip: "Tag",
              ),
            ),
            // const SizedBox(
            //   width: 12,
            // ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                enableFeedback: true,
                iconSize: 18,
                onPressed: () {},
                icon: const ImageIcon(
                  AssetImage(
                    "lib/resources/icons/image_add.png",
                  ),
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tooltip: "Add Image",
              ),
            ),
            // const SizedBox(
            //   width: 12,
            // ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                enableFeedback: true,
                iconSize: 18,
                onPressed: () {},
                icon: const ImageIcon(
                  AssetImage(
                    "lib/resources/icons/more_menu_vertical.png",
                  ),
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tooltip: "More Menu",
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: MobileFloatingToolbar(
                editorState: editorState,
                editorScrollController:
                    EditorScrollController(editorState: editorState),
                toolbarBuilder: (context, anchor) {
                  return AdaptiveTextSelectionToolbar.editable(
                    clipboardStatus: ClipboardStatus.pasteable,
                    onCopy: () => copyCommand.execute(editorState),
                    onCut: () => cutCommand.execute(editorState),
                    onPaste: () => pasteCommand.execute(editorState),
                    onSelectAll: () => selectAllCommand.execute(editorState),
                    anchors: TextSelectionToolbarAnchors(
                      primaryAnchor: anchor,
                    ),
                    onLiveTextInput: null,
                  );
                },
                child: AppFlowyEditor(
                  editorState: editorState,
                  editable: true,
                  editorStyle: EditorStyle.mobile(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    selectionColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    textStyleConfiguration: TextStyleConfiguration(
                      text: Theme.of(context).textTheme.bodyMedium!,
                      code: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontFamily: 'SourceCodePro',
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                    ),
                  ),
                ),
              ),
            ),
            CustomMobileToolbar(
              editorState: editorState,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.4),
              borderRadius: 4,
              buttonBorderWidth: 1,
              buttonHeight: 32,
              buttonSelectedBorderWidth: 1.8,
              buttonSpacing: 8,
              clearDiagonalLineColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              itemHighlightColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              itemOutlineColor: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(0.2),
              onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
              outlineColor: Theme.of(context).colorScheme.onPrimaryContainer,
              primaryColor: Theme.of(context).colorScheme.primary,
              tabbarSelectedBackgroundColor:
                  Theme.of(context).colorScheme.secondary,
              tabbarSelectedForegroundColor:
                  Theme.of(context).colorScheme.onSecondary,
              toolbarHeight: 48,
              toolbarItems: [
                customTextDecorationMobileToolbarItem,
                buildTextAndBackgroundColorMobileToolbarItem(),
                headingMobileToolbarItem,
                todoListMobileToolbarItem,
                listMobileToolbarItem,
                linkMobileToolbarItem,
                quoteMobileToolbarItem,
                dividerMobileToolbarItem,
                MobileToolbarItem.action(
                  itemIcon: ImageIcon(
                    const AssetImage(
                      "lib/resources/icons/codeblock.png",
                    ),
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  actionHandler: (editorState, selection) =>
                      editorState.toggleAttribute(AppFlowyRichTextKeys.code),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
