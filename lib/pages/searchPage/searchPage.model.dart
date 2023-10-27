import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import '../../repositories/IsarDBRepo/isarSDRepo.dart';
import '../../repositories/noteRepo/noteRepoModel.dart';

part 'searchPage.model.g.dart';

class SearchPageModel = _SearchPageModelBase with _$SearchPageModel;

abstract class _SearchPageModelBase with Store {
  Timer? debounce;
  @observable
  List<Note> quiredNotes = [];

  @observable
  bool isLoading = false;

  // Repos
  final IsarDBRepo dbRepo = GetIt.I.get<IsarDBRepo>();
}
