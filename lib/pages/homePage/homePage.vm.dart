import 'package:isar/isar.dart';
import 'package:notebook/pages/homePage/homePage.model.dart';
import 'package:notebook/repositories/noteRepo/noteRepoModel.dart';

import '../../helpers/customLogger.dart';

class HomePageVM extends HomePageModel {
  Future<void> initHomePage() async {
    try {
      await fetchNotes();
      await subscribeToChanges();
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  Future<void> subscribeToChanges() async {
    try {
      var changeInDb = dbRepo.isar.notes.watchLazy(fireImmediately: true);
      changeInDb.listen((_) async {
        await fetchNotes();
      });
    } catch (ex, stack) {
      isLoading = false;
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

  Future<void> fetchNotes() async {
    try {
      isLoading = true;
      await dbRepo.isar.txn(() async {
        todaysRemainder = await dbRepo.isar.notes
            .filter()
            .whenToAlertBetween(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, 23, 59))
            .sortByWhenToAlert()
            .build()
            .findAll();

        pinnedNotes = await dbRepo.isar.notes
            .filter()
            .isPinnedEqualTo(true)
            .sortByCreatedAtDesc()
            .build()
            .findAll();

        allNotes = await dbRepo.isar.notes
            .filter()
            .isPinnedEqualTo(false)
            .sortByCreatedAtDesc()
            .build()
            .findAll();
      });
      isLoading = false;
    } catch (ex, stack) {
      isLoading = false;
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }
}
