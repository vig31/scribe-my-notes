import 'package:isar/isar.dart';
import 'package:notebook/helpers/customLogger.dart';
import 'package:path_provider/path_provider.dart';

class IsarDBRepo {
  // Private constructor
  IsarDBRepo._private();

  // The single instance of the class
  static final IsarDBRepo _instance = IsarDBRepo._private();

  // Factory constructor to access the instance
  factory IsarDBRepo() {
    return _instance;
  }

  // The database instance
  late final Isar isar;

  bool _initializedDB = false;

  Future<void> initDBWithSchema(
      {required List<CollectionSchema<dynamic>> schemas,
      String pathToDatabase = ""}) async {
    try {
      if (!_initializedDB) {
        final dir = await getApplicationDocumentsDirectory();
        isar = await Isar.open(
          schemas,
          directory: pathToDatabase.isEmpty ? dir.path : pathToDatabase,
          maxSizeMiB: double.maxFinite.toInt(),
        );
        _initializedDB = true;
      }
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }
}
