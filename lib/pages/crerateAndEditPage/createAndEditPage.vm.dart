import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:isar/isar.dart';
import 'package:notebook/helpers/extension/extension.dart';
import 'package:notebook/repositories/noteRepo/noteRepoModel.dart';
import 'package:notebook/repositories/tagRepo/tagRepoModel.dart';
import 'package:flutter/material.dart';
import '../../helpers/customLogger.dart';
import '../../helpers/utility.dart';
import 'createAndEditPage.model.dart';

class CreateAndEditPageVM extends CreateAndEditPageModel {
  CreateAndEditPageVM({
    bool isEdit = false,
    int editNoteId = -1,
  }) {
    this.isEdit = isEdit;
    this.editNoteId = editNoteId;
  }

  Future<void> init() async {
    try {
      isLoading = true;
      await fetchAllTags();
      if (isEdit) {
        await fetchEditNote();
      }
      var note = Note()
        ..title = ""
        ..note = "";
      currentNoteController.add(editNote ?? note);
      isLoading = false;
    } catch (e, s) {
      currentNoteController.add(
        Note()
          ..title = ""
          ..note = "",
      );
      isLoading = false;
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<void> fetchEditNote() async {
    try {
      await dbRepo.isar.writeTxn(() async {
        editNote = await dbRepo.isar.notes.get(editNoteId);
      });
      selectedTag = editNote?.tag.value;
      selectedImagePath =
          editNote!.isAssetAsCoverImage ? "" : editNote?.coverImagePath ?? "";
      isPinned = editNote?.isPinned ?? false;
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  Future<void> fetchAllTags() async {
    try {
      tags = await dbRepo.isar.tags.where(distinct: true).findAll();
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  Future<void> saveTag({
    required String tagName,
    required Color tagColor,
  }) async {
    try {
      Tag newTag = Tag();
      newTag.tagName = tagName.capitalize();
      newTag.colorCode = tagColor.value;
      await dbRepo.isar.writeTxn(() async {
        await dbRepo.isar.tags.put(newTag);
      });
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<void> saveNote({
    required final String title,
    required final EditorState noteEditorState,
    required final DateTime? whenNotificationScheduled,
  }) async {
    var note = Note();
    try {
      if (isEdit) {
        note = editNote!;
      } else {
        note.createdAt = DateTime.now();
      }
      note.editedAt = DateTime.now();
      note.title = title;
      note.note = jsonEncode(noteEditorState.document.toJson());
      note.isPinned = isPinned;
      selectedImagePath.isNotEmpty
          ? note.coverImagePath = selectedImagePath
          : note.coverImagePath =
              "lib/resources/images/ic_default_${randomPositiveNumberWithThreshold(10)}.jpg";
      selectedImagePath.isNotEmpty
          ? note.isAssetAsCoverImage = false
          : note.isAssetAsCoverImage = true;

      note.whenToAlert = whenNotificationScheduled;

      note.tag.value = selectedTag;
      selectedTag != null ? await note.tag.save() : null;
      selectedTag != null ? await note.tag.load() : null;

      await dbRepo.isar.writeTxn(() async {
        var noteId = await dbRepo.isar.notes.put(note);
        note.id = noteId;
        editNoteId = noteId;
        editNote = note;
        isEdit = true;
      });
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<void> pickCoverImageFromGall() async {
    try {
      selectedImagePath = await imagePickerRepo.getImage();
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  void changePinedStatus() {
    try {
      isPinned = !isPinned;
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<bool> deleteNote() async {
    try {
      if (isEdit) {
        return await dbRepo.isar.writeTxn<bool>(() async {
          return await dbRepo.isar.notes
              .delete(editNote!.id)
              .then((value) => isEdit = !value);
        });
      } else {
        return true;
      }
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
      return false;
    }
  }
}
