import 'dart:async';

import 'package:isar/isar.dart';
import 'package:notebook/pages/searchPage/searchPage.model.dart';
import 'package:notebook/repositories/noteRepo/noteRepoModel.dart';

import '../../helpers/customLogger.dart';

class SearchPageVM extends SearchPageModel {
  void debounceQuery(String text) {
    try {
      if (debounce != null) {
        debounce?.cancel();
        debounce = null;
      }
      debounce = Timer(const Duration(milliseconds: 250),
          () async => await getAllQueriedNote(text.trim()));
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  Future<void> getAllQueriedNote(String text) async {
    try {
      isLoading = true;
      await dbRepo.isar.txn(() async {
        quiredNotes = await dbRepo.isar.notes
            .filter()
            .titleContains(text, caseSensitive: false)
            .or()
            .noteContains(text, caseSensitive: false)
            .sortByCreatedAtDesc()
            .build()
            .findAll();
      });
      isLoading = false;
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }
}
