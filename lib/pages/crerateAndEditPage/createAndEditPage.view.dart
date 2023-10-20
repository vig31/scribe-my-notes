// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook/helpers/utility.dart';
import 'package:notebook/pages/crerateAndEditPage/createAndEditPage.vm.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../repositories/imagePickerRepo/imagePickerRepo.dart';
import '../../reuseables/widgets/customAppflowyHeadingToolBarItem.dart';
import '../../reuseables/widgets/customAppflowyLinkToolBarItem.dart';
import '../../reuseables/widgets/customAppflowyListToolBarItem.dart';
import '../../reuseables/widgets/customAppflowyMobileToolBarItem.dart';
import '../../reuseables/widgets/customAppflowyTodoToolBarItem.dart';
import '../../reuseables/widgets/customAppflowyToolBarItems.dart';
import 'package:path_provider/path_provider.dart';
import '../../reuseables/widgets/customBuildTextAndBackgroundColorMobileToolbarItem.dart';

class CreateAndEditPageView extends StatefulWidget {
  final bool isEdit;
  final int editNoteId;

  const CreateAndEditPageView({Key? key, required this.isEdit, required this.editNoteId}) : super(key: key);

  @override
  State<CreateAndEditPageView> createState() => _CreateAndEditPageViewState();
}

class _CreateAndEditPageViewState extends State<CreateAndEditPageView> {
  late final editorState = EditorState.blank(); // with an empty paragraph
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
  // String imagePath = "";
  final _createAndEditPageVM = CreateAndEditPageVM();

  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _createAndEditPageVM.saveNote(
            title: titleController.text,
            noteEditorState: editorState,
            whenNotificationScheduled: null);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              enableFeedback: true,
              iconSize: 21,
              onPressed: () async {
                await _createAndEditPageVM.saveNote(
                  title: titleController.text,
                  noteEditorState: editorState,
                  whenNotificationScheduled: null,
                );
                // Navigator.pop(context);
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
            actions: [
              SizedBox(
                width: 40,
                height: 40,
                child: Observer(builder: (_) {
                  return IconButton(
                    enableFeedback: true,
                    iconSize: 18,
                    onPressed: () async {
                      _createAndEditPageVM.changePinedStatus();
                      // await convertMarkdownToPdfAndSave(
                      //   documentToMarkdown(editorState.document),
                      // );
                    },
                    icon: ImageIcon(
                      AssetImage(
                        _createAndEditPageVM.isPinned
                            ? "lib/resources/icons/pin_filled.png"
                            : "lib/resources/icons/pin.png",
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    tooltip: "Pin it",
                  );
                }),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  enableFeedback: true,
                  iconSize: 18,
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));

                    final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dialOnly);

                    var finalDateTime = DateTime(
                        pickedDate!.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime!.hour,
                        pickedTime.minute);

                    var permissionStatus =
                        await Permission.notification.request();
                    if (permissionStatus.isGranted) {
                      await AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          title: titleController.text,
                          body: (((editorState.document.toJson()
                                          as Map<String, dynamic>)["document"]
                                      ["children"])
                                  .map(
                                    (e) {
                                      return e["data"]["delta"]
                                          .map(
                                            (f) {
                                              return " ${f["insert"].toString().trim()}";
                                            },
                                          )
                                          .join("")
                                          .toString()
                                          .trim();
                                    },
                                  )
                                  .toList()
                                  .join(" ")
                                  .toString()
                                  .trim())
                              .replaceAll(RegExp(r' +'), ' '),
                          notificationLayout: NotificationLayout.Default,
                          wakeUpScreen: true,
                          category: NotificationCategory.Reminder,
                          criticalAlert: true,
                        ),
                        schedule: NotificationCalendar(
                          hour: finalDateTime.hour,
                          minute: finalDateTime.minute,
                          allowWhileIdle: true,
                        ),
                      );
                    }
                    _createAndEditPageVM.saveNote(
                      title: titleController.text,
                      noteEditorState: editorState,
                      whenNotificationScheduled: finalDateTime,
                    );
                  },
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
              //! Planned for Next release
              // SizedBox(
              //   width: 40,
              //   height: 40,
              //   child: IconButton(
              //     enableFeedback: true,
              //     iconSize: 18,
              //     onPressed: () {
              //       // _createAndEditPageVM.saveTag("wer", "wer");
              //     },
              //     icon: const ImageIcon(
              //       AssetImage(
              //         "lib/resources/icons/bookmark.png",
              //       ),
              //     ),
              //     padding: EdgeInsets.zero,
              //     alignment: Alignment.center,
              //     tooltip: "Tag",
              //   ),
              // ),
              // const SizedBox(
              //   width: 12,
              // ),
              SizedBox(
                width: 40,
                height: 40,
                child: Observer(builder: (_) {
                  return IconButton(
                    enableFeedback: true,
                    iconSize: 18,
                    onPressed: () async {
                      await _createAndEditPageVM.pickCoverImageFromGall();
                    },
                    icon: ImageIcon(
                      AssetImage(
                        _createAndEditPageVM.selectedImagePath.isEmpty
                            ? "lib/resources/icons/image_add.png"
                            : "lib/resources/icons/image_edit.png",
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    tooltip: "Add Image",
                  );
                }),
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
          body: EditorView(
              editorState: editorState,
              createAndEditPageVM: _createAndEditPageVM,
              titleController: titleController),
        ),
      ),
    );
  }
}

class EditorView extends StatefulWidget {
  final EditorState editorState;
  final CreateAndEditPageVM createAndEditPageVM;
  final TextEditingController titleController;
  const EditorView({
    Key? key,
    required this.editorState,
    required this.createAndEditPageVM,
    required this.titleController,
  }) : super(key: key);

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late final editorState = widget.editorState;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FloatingToolbar(
            editorState: editorState,
            textDirection: null,
            editorScrollController:
                EditorScrollController(editorState: editorState),
            items: [
              paragraphItem,
              ...alignmentItems,
              ToolbarItem(
                id: 'cut',
                group: 7,
                isActive: onlyShowInTextType,
                builder: (context, editorState, highlightColor, _) {
                  return SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      onPressed: () => cutCommand.execute(editorState),
                      icon: const Icon(Icons.cut_rounded, size: 16),
                    ),
                  );
                },
              ),
              ToolbarItem(
                id: 'copy',
                group: 7,
                isActive: onlyShowInTextType,
                builder: (context, editorState, highlightColor, _) {
                  return SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      onPressed: () => copyCommand.execute(editorState),
                      icon: const Icon(Icons.content_copy_rounded, size: 16),
                    ),
                  );
                },
              ),
              ToolbarItem(
                id: 'paste',
                group: 7,
                isActive: onlyShowInTextType,
                builder: (context, editorState, highlightColor, _) {
                  return SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      onPressed: () => pasteCommand.execute(editorState),
                      icon: const Icon(Icons.paste_rounded, size: 16),
                    ),
                  );
                },
              ),
              ToolbarItem(
                id: 'selectall',
                group: 7,
                isActive: onlyShowInTextType,
                builder: (context, editorState, highlightColor, _) {
                  return SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      onPressed: () => selectAllCommand.execute(editorState),
                      icon: const Icon(Icons.select_all_rounded, size: 16),
                    ),
                  );
                },
              ),
            ],
            style: FloatingToolbarStyle(
              backgroundColor: const Color(0xFF001D31),
              toolbarActiveColor: Colors.amber[900]!,
            ),
            child: AppFlowyEditor(
              header: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  children: [
                    Observer(builder: (context) {
                      return widget
                              .createAndEditPageVM.selectedImagePath.isEmpty
                          ? const SizedBox.shrink()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(widget
                                    .createAndEditPageVM.selectedImagePath),
                                height: 208,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  if (frame == null) {
                                    return const LinearProgressIndicator();
                                  }
                                  return child;
                                },
                              ),
                            );
                    }),
                    TextFormField(
                      controller: widget.titleController,
                      maxLines: 2,
                      minLines: 1,
                      autofocus: false,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      smartDashesType: SmartDashesType.enabled,
                      decoration: const InputDecoration(
                          hintText: 'Title', border: InputBorder.none),
                      contextMenuBuilder: (context, editableTextState) {
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          anchors: editableTextState.contextMenuAnchors,
                          buttonItems: <ContextMenuButtonItem>[
                            ContextMenuButtonItem(
                              onPressed: () {
                                editableTextState.cutSelection(
                                    SelectionChangedCause.toolbar);
                              },
                              type: ContextMenuButtonType.cut,
                            ),
                            ContextMenuButtonItem(
                              onPressed: () {
                                editableTextState.copySelection(
                                    SelectionChangedCause.toolbar);
                              },
                              type: ContextMenuButtonType.copy,
                            ),
                            ContextMenuButtonItem(
                              onPressed: () {
                                editableTextState
                                    .pasteText(SelectionChangedCause.toolbar);
                              },
                              type: ContextMenuButtonType.paste,
                            ),
                          ],
                        );
                      },
                    ),
                    const Divider(
                      thickness: 1.0,
                      color: Color(0xffF1F3F3),
                    ),
                  ],
                ),
              ),
              editorState: editorState,
              editable: true,
              editorStyle: EditorStyle.desktop(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                cursorColor: Theme.of(context).colorScheme.primary,
                selectionColor: Theme.of(context).colorScheme.primaryContainer,
                textStyleConfiguration: TextStyleConfiguration(
                  text: Theme.of(context).textTheme.bodyMedium!,
                  code: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontFamily: 'SourceCodePro',
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                ),
              ),
            ),
          ),
        ),
        CustomMobileToolbar(
          editorState: editorState,
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.40),
          borderRadius: 8,
          buttonBorderWidth: 1,
          buttonHeight: 40,
          buttonSpacing: 8,
          buttonSelectedBorderWidth: 2.0,
          clearDiagonalLineColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          itemHighlightColor:
              Theme.of(context).colorScheme.onSecondaryContainer,
          itemOutlineColor:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
          onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
          outlineColor: Theme.of(context).colorScheme.onPrimaryContainer,
          primaryColor: Theme.of(context).colorScheme.primary,
          tabbarSelectedBackgroundColor:
              Theme.of(context).colorScheme.secondary,
          tabbarSelectedForegroundColor:
              Theme.of(context).colorScheme.onSecondary,
          toolbarHeight: 48,
          toolbarItems: [
            customTodoListMobileToolbarItem,
            customTextDecorationMobileToolbarItem,
            customBuildTextAndBackgroundColorMobileToolbarItem(),
            customHeadingMobileToolbarItem,
            customListMobileToolbarItem,
            customLinkMobileToolbarItem,
            MobileToolbarItem.action(
              itemIcon: const ImageIcon(
                AssetImage(
                  "lib/resources/icons/quote.png",
                ),
                size: 16,
              ),
              actionHandler: ((editorState, selection) {
                final node = editorState.getNodeAtPath(selection.start.path)!;
                final isQuote = node.type == QuoteBlockKeys.type;
                editorState.formatNode(
                  selection,
                  (node) => node.copyWith(
                    type:
                        isQuote ? ParagraphBlockKeys.type : QuoteBlockKeys.type,
                    attributes: {
                      ParagraphBlockKeys.delta:
                          (node.delta ?? Delta()).toJson(),
                    },
                  ),
                );
              }),
            ),
            MobileToolbarItem.action(
              itemIcon: const Icon(
                Icons.horizontal_rule_rounded,
                size: 16,
              ),
              actionHandler: ((editorState, selection) {
                // same as the [handler] of [dividerMenuItem] in Desktop
                final selection = editorState.selection;
                if (selection == null || !selection.isCollapsed) {
                  return;
                }
                final path = selection.end.path;
                final node = editorState.getNodeAtPath(path);
                final delta = node?.delta;
                if (node == null || delta == null) {
                  return;
                }
                final insertedPath = delta.isEmpty ? path : path.next;
                final transaction = editorState.transaction
                  ..insertNode(insertedPath, dividerNode())
                  ..insertNode(insertedPath, paragraphNode())
                  ..afterSelection =
                      Selection.collapsed(Position(path: insertedPath.next));
                editorState.apply(transaction);
              }),
            ),
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
    );
  }
}
