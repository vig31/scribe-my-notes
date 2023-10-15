import 'package:isar/isar.dart';

import '../noteRepo/noteRepoModel.dart';
part 'tagRepoModel.g.dart';

@Collection()
@Name("Tag")
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String tagName;

  late int colorCode;

  final notes = IsarLinks<Note>();
}
