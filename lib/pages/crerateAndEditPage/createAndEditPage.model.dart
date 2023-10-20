import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:notebook/repositories/IsarDBRepo/isarSDRepo.dart';
import 'package:notebook/repositories/noteRepo/noteRepoModel.dart';

import '../../repositories/imagePickerRepo/imagePickerRepo.dart';
import '../../repositories/tagRepo/tagRepoModel.dart';
part 'createAndEditPage.model.g.dart';

class CreateAndEditPageModel = _CreateAndEditPageModelBase
    with _$CreateAndEditPageModel;

abstract class _CreateAndEditPageModelBase with Store {
  @observable
  List<Tag> tags = [];

  @observable
  Tag? selectedTag;

  @observable
  bool isLoading = false;
  
  @observable
  bool isPinned = false;

  @observable
  String selectedImagePath = "";

  Note? editNote;

  bool isEdit = false;

  int editNoteId = -1;

  // Repos
  final IsarDBRepo dbRepo = GetIt.I.get<IsarDBRepo>();

  final ImagePickerRepo imagePickerRepo = GetIt.I.get<ImagePickerRepo>();
}
