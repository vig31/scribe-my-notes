import 'package:isar/isar.dart';
import '../tagRepo/tagRepoModel.dart';
part 'noteRepoModel.g.dart';

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

  Note updateWithEditedAt() {
    final Note newNote = Note();
    newNote.id = id;
    newNote.title = title;
    newNote.note = note;
    newNote.coverImagePath = coverImagePath;
    newNote.isAssetAsCoverImage = isAssetAsCoverImage;
    newNote.createdAt = createdAt;
    newNote.editedAt = DateTime.now();
    newNote.whenToAlert = whenToAlert;
    newNote.isDeleted = isDeleted;
    newNote.tag.value = tag.value;
    newNote.tag.saveSync();
    newNote.tag.loadSync();
    return newNote;
  }
}