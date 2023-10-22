
import 'package:notebook/pages/homePage/homePage.model.dart';

import '../../helpers/customLogger.dart';

class HomePageVM  extends HomePageModel{

  Future<void> fetchNotes() async {
    try {
      
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
    }
  }

}