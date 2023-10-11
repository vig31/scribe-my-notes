import 'package:isar/isar.dart';

part 'localDatabaseServiceModel.g.dart';

@Collection()
@Name("Tag")
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String tagName;

  late int colorCode;

  final notes = IsarLinks<Note>();
}

@Collection()
@Name("Note")
class Note {
  Id id = Isar.autoIncrement;

  @Index()
  late String title;

  @Index()
  late String note;

  late String coverImagePath;

  bool isAssetAsCoverImage = false;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime editedAt;

  @Index()
  DateTime? whenToAlert;

  bool isDeleted = false;

  @Index()
  @Backlink(to: 'notes')
  var tag = IsarLink<Tag>();
}
