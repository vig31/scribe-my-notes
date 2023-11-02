// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'dart:io';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notebook/helpers/utility.dart';
import 'package:notebook/pages/crerateAndEditPage/createAndEditPage.vm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
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

  const CreateAndEditPageView(
      {Key? key, required this.isEdit, required this.editNoteId})
      : super(key: key);

  @override
  State<CreateAndEditPageView> createState() => _CreateAndEditPageViewState();
}

class _CreateAndEditPageViewState extends State<CreateAndEditPageView> {
  late final CreateAndEditPageVM _createAndEditPageVM;

  late final EditorState editorState;

  late final TextEditingController titleController;
  DateTime? finalSelectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createAndEditPageVM = CreateAndEditPageVM(
        editNoteId: widget.editNoteId, isEdit: widget.isEdit);
    _createAndEditPageVM.init();
    _createAndEditPageVM.currentNoteController.stream.listen((event) {
      if (widget.isEdit && _createAndEditPageVM.editNote != null) {
        editorState = EditorState(
          document: Document.fromJson(
            jsonDecode(event.note),
          ),
        );
        titleController = TextEditingController(text: event.title);
      } else {
        editorState = EditorState.blank(withInitialText: true);
        titleController = TextEditingController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _createAndEditPageVM.saveNote(
          title: titleController.text,
          noteEditorState: editorState,
        );
        var re = _createAndEditPageVM.isLoading ? false : true;
        return re;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              enableFeedback: true,
              iconSize: 21,
              onPressed: () async {
                if (!_createAndEditPageVM.isLoading) {
                  await _createAndEditPageVM.saveNote(
                    title: titleController.text,
                    noteEditorState: editorState,
                  );
                  Navigator.pop(context);
                }
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
              Observer(builder: (context) {
                return Visibility(
                  visible: !_createAndEditPageVM.isLoading,
                  child: SizedBox(
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
                );
              }),
              Observer(builder: (_) {
                return Visibility(
                  visible: !_createAndEditPageVM.isLoading,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      enableFeedback: true,
                      iconSize: 18,
                      onPressed: () async {
                        if (await Permission.notification.isDenied) {
                          bool confirm = false;
                          await showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'To display notifications, you must grant permission to enable notification to display.'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      confirm = true;
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                    ),
                                    child: const Text("Grant"),
                                  ),
                                ],
                              );
                            },
                          );
                          if (!confirm) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Permission denied, so we can't continue the operation."),
                              ),
                            );
                            return;
                          }
                        }
                        var permissionStatus =
                            await Permission.notification.request();
                        final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.day,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dialOnly);

                          var finalDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime!.hour,
                              pickedTime.minute);

                          if (permissionStatus.isGranted) {
                            List<String> finalText = [];
                            editorState.document.root.children.map((e) {
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
                                .replaceAll(RegExp(r' +'), ' ');
                            if (titleController.text.trim().isEmpty &&
                                noteContent.trim().isEmpty) {
                              return;
                            }
                            await AwesomeNotifications().createNotification(
                              content: NotificationContent(
                                id: 10,
                                channelKey: 'basic_channel',
                                title: titleController.text,
                                body: noteContent,
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
                          finalSelectedDate = finalDateTime;
                          _createAndEditPageVM.whenScheduled = finalDateTime;
                          _createAndEditPageVM.saveNote(
                            title: titleController.text,
                            noteEditorState: editorState,
                          );
                        }
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
                );
              }),
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
              Observer(builder: (_) {
                return Visibility(
                  visible: !_createAndEditPageVM.isLoading,
                  child: SizedBox(
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
                );
              }),
              // const SizedBox(
              //   width: 12,
              // ),
              Observer(builder: (_) {
                return Visibility(
                  visible: !_createAndEditPageVM.isLoading,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: PopupMenuButton(
                      clipBehavior: Clip.antiAlias,
                      enableFeedback: true,
                      tooltip: "More options",
                      padding: EdgeInsets.zero,
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          onTap: () {
                            _showSavePopupMenu();
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                const AssetImage(
                                  "lib/resources/icons/download.png",
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                "Save",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // PopupMenuItem 2
                        PopupMenuItem(
                          onTap: () {
                            _showSharePopupMenu();
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                const AssetImage(
                                  "lib/resources/icons/share.png",
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                "Share",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (_createAndEditPageVM.isEdit)
                          PopupMenuItem(
                            onTap: () {
                              _createAndEditPageVM.deleteNote();
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  size: 18,
                                  color: Theme.of(context).colorScheme.error,
                                  const AssetImage(
                                    "lib/resources/icons/delete.png",
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Delete",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      offset: const Offset(-16, 45),
                      elevation: 10,
                      icon: const ImageIcon(
                        AssetImage(
                          "lib/resources/icons/more_menu_vertical.png",
                        ),
                      ),
                      iconSize: 18,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          body: Observer(
            builder: (_) {
              if (_createAndEditPageVM.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return EditorView(
                  editorState: editorState,
                  createAndEditPageVM: _createAndEditPageVM,
                  titleController: titleController,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _accessPermissionToShowFolder() async {
    bool confirm = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'We require authorization to access the location of your media in order to present you with choices for saving the file.'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              child: const Text("Grant"),
            ),
          ],
        );
      },
    );

    return confirm;
  }

  void _showSavePopupMenu() async {
    await showMenu(
      context: context,
      clipBehavior: Clip.antiAlias,
      position: const RelativeRect.fromLTRB(100, 80, 16, 100),
      items: [
        PopupMenuItem(
          onTap: () async {
            await saveAsPdf();
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
                const AssetImage(
                  "lib/resources/icons/filetype_pdf.png",
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Save as PDF",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            await saveAsMd();
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
                const AssetImage(
                  "lib/resources/icons/filetype_md.png",
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Save as md",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ],
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _showSharePopupMenu() async {
    await showMenu(
      context: context,
      clipBehavior: Clip.antiAlias,
      position: const RelativeRect.fromLTRB(100, 80, 16, 100),
      items: [
        PopupMenuItem(
          onTap: () async {
            var file = await saveDocumentToPdf(
                appFlowyDocumentToParse: editorState.document,
                outputFilepath:
                    "${(await getApplicationCacheDirectory()).path}/output-temp.pdf",
                title: titleController.text);
            if (file != null) {
              await Share.shareXFiles(
                [XFile(file.path)],
                text: titleController.text,
              );
            }
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
                const AssetImage(
                  "lib/resources/icons/filetype_pdf.png",
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Share as PDF",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            final contentToShare = StringBuffer();
            contentToShare.writeln("# ${titleController.text}");
            contentToShare.writeln("");
            contentToShare.writeln("");
            var mdStr = documentToMarkdown(editorState.document);
            contentToShare.writeln(mdStr);

            var temp = await getTemporaryDirectory().then((value) {
              return "${value.path}/temp.md";
            });

            var res = await File(temp).create(recursive: true);
            final restFile =
                await File(res.path).writeAsString(contentToShare.toString());

            await Share.shareXFiles(
              [XFile(restFile.path)],
              text: titleController.text,
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
                const AssetImage(
                  "lib/resources/icons/filetype_md.png",
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Share as md",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            final contentToShare = StringBuffer();
            contentToShare.writeln(titleController.text);
            contentToShare.writeln("");
            contentToShare.writeln("");
            List<String> finalText = [];
            editorState.document.root.children.map((e) {
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

            contentToShare.writeln(noteContent);

            await Share.shareWithResult(
              contentToShare.toString(),
              subject: titleController.text,
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.abc_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Share as Text",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ],
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Future<void> saveAsPdf() async {
    var isGranted = await Permission.accessMediaLocation.isDenied
        ? await _accessPermissionToShowFolder()
        : true;
    if (isGranted) {
      var result = await Permission.accessMediaLocation.request();
      if (result.isGranted) {
        var pathtosave = await chooseTheFolder();
        if (pathtosave.isNotEmpty) {
          var save =
              "$pathtosave/note-${DateTime.now().year}-${DateTime.now().year}-${DateTime.now().day}-${DateTime.now().second}.pdf";
          await saveDocumentToPdf(
              appFlowyDocumentToParse: editorState.document,
              outputFilepath: save,
              title: titleController.text);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("File has been saved, successfully.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Permission denied, so we can't continue.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Permission denied, so we can't continue.")));
    }
  }

  Future<void> saveAsMd() async {
    var isGranted = await Permission.accessMediaLocation.isDenied
        ? await _accessPermissionToShowFolder()
        : true;
    if (isGranted) {
      var result = await Permission.accessMediaLocation.request();
      if (result.isGranted) {
        var pathtosave = await chooseTheFolder();
        if (pathtosave.isNotEmpty) {
          var outputSavedFile = File(
              "$pathtosave/output-${DateTime.now().year}-${DateTime.now().year}-${DateTime.now().day}-${DateTime.now().second}.md");
          await outputSavedFile.create(recursive: true);
          var mdfileBuffer = StringBuffer();
          mdfileBuffer.writeln("# ${titleController.text}");
          mdfileBuffer.writeln("");
          mdfileBuffer.writeln(documentToMarkdown(editorState.document));
          await outputSavedFile.writeAsString(mdfileBuffer.toString());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("File has been saved, successfully.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Permission denied, so we can't continue.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Permission denied, so we can't continue.")));
    }
  }

  Future<String> chooseTheFolder() async {
    return await FilesystemPicker.open(
          title: 'Pick a folder',
          context: context,
          rootDirectory: Directory("/storage/emulated/0"),
          fsType: FilesystemType.folder,
          requestPermission: () async =>
              await Permission.accessMediaLocation.request().isGranted,
          pickText: 'Save file here',
          showGoUp: false,
          theme: FilesystemPickerAutoSystemTheme(
            darkTheme: FilesystemPickerTheme(
              topBar: FilesystemPickerTopBarThemeData(
                  backgroundColor: const Color.fromARGB(255, 55, 103, 185)),
              fileList: FilesystemPickerFileListThemeData(
                iconSize: 24,
                folderIconColor: Colors.blueAccent,
                folderTextStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            lightTheme: FilesystemPickerTheme(
              backgroundColor: Colors.grey.shade200,
              topBar: FilesystemPickerTopBarThemeData(
                foregroundColor: Colors.blueGrey.shade800,
                backgroundColor: Colors.grey.shade200,
                elevation: 0,
                shape: const ContinuousRectangleBorder(
                  side: BorderSide(
                    color: Color(0xFFDDDDDD),
                    width: 1.0,
                  ),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black,
                  size: 24,
                ),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                breadcrumbsTheme: BreadcrumbsThemeData(
                  itemColor: Colors.blue.shade800,
                  inactiveItemColor: Colors.blue.shade800.withOpacity(0.6),
                  separatorColor: Colors.blue.shade800.withOpacity(0.3),
                ),
              ),
              fileList: FilesystemPickerFileListThemeData(
                iconSize: 24,
                folderIconColor: Colors.blue,
                folderTextStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              pickerAction: FilesystemPickerActionThemeData(
                foregroundColor: Colors.blueGrey.shade800,
                disabledForegroundColor: Colors.blueGrey.shade500,
                backgroundColor: Colors.grey.shade200,
                shape: const ContinuousRectangleBorder(
                  side: BorderSide(
                    color: Color(0xFFDDDDDD),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ) ??
        "";
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
  late final createAndEditPageVM = widget.createAndEditPageVM;
  late final editorState = widget.editorState;

  late Map<String, BlockComponentBuilder> _blockComponentBuilder;

  final noteFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _blockComponentBuilder = _buildBlockComponentBuilders();
  }

  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };

    final levelToFontSize = [
      24.0,
      22.0,
      20.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(
              fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0),
    );

    map[ParagraphBlockKeys.type] = TextBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
        placeholderTextStyle: (node) {
          return Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey);
        },
      ),
    );
    return map;
  }

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
                    Observer(builder: (ctx) {
                      return (widget.createAndEditPageVM.isAssestImage)
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onLongPress: () async {
                                bool confirm = false;
                                await showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: const Text('Confirm'),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Are you sure you want to remove this image?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            confirm = true;
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm) {
                                  // remove the selected image path
                                  createAndEditPageVM.isAssestImage = true;
                                  createAndEditPageVM.selectedImagePath = "";
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsetsDirectional.only(top: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: InteractiveViewer(
                                    constrained: true,
                                    child: Image.file(
                                      File(widget.createAndEditPageVM
                                          .selectedImagePath),
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
                                  ),
                                ),
                              ),
                            );
                    }),
                    TextFormField(
                      controller: widget.titleController,
                      maxLines: 5,
                      minLines: 1,
                      autofocus: !widget.createAndEditPageVM.isEdit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      smartDashesType: SmartDashesType.enabled,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
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
              focusNode: noteFieldFocusNode,
              editable: true,
              editorStyle: EditorStyle(
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
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                ),
                textSpanDecorator: defaultTextSpanDecoratorForAttribute,
              ),
              blockComponentBuilders: _blockComponentBuilder,
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
            // customLinkMobileToolbarItem,
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
