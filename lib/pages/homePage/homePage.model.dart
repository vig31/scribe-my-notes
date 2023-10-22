import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../repositories/IsarDBRepo/isarSDRepo.dart';
import '../../repositories/noteRepo/noteRepoModel.dart';
part 'homePage.model.g.dart';

class HomePageModel = _HomePageModelBase with _$HomePageModel;

abstract class _HomePageModelBase with Store {
  
  
  @observable
  bool isLoading = false;
  
  @observable
  List<Note> todaysRemainder = [];
 
  @observable
  List<Note> pinnedNotes = [];
 
  @observable
  List<Note> allNotes = [];

  // Repos
  final IsarDBRepo dbRepo = GetIt.I.get<IsarDBRepo>();
}
