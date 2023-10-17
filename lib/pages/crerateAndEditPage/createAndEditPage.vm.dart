import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:isar/isar.dart';
import 'package:notebook/repositories/noteRepo/noteRepoModel.dart';
import 'package:notebook/repositories/tagRepo/tagRepoModel.dart';

import '../../helpers/customLogger.dart';
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
      isLoading = false;
    } catch (e, s) {
      isLoading = false;
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<void> fetchEditNote() async {
    try {
      editNote = await dbRepo.isar.notes.get(editNoteId);
      selectedTag = editNote?.tag.value;
      selectedImagePath = editNote?.coverImagePath ?? "";
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

  Future<void> createTag(
    String tagName,
  ) async {
    try {} catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }

  Future<void> saveNote({
    required String title,
    required EditorState noteEditorState,
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
      note.coverImagePath = selectedImagePath;
      note.tag.value = selectedTag;
      selectedTag != null ? await note.tag.save() : null;
      selectedTag != null ? await note.tag.load() : null;
      await dbRepo.isar.writeTxn(() async {
        await dbRepo.isar.notes.put(note);
      });
    } catch (e, s) {
      CustomLogger().logFatelException(error: e, stack: s);
    }
  }
}
