import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';

import '../repositories/noteRepo/noteRepoModel.dart';
import '../repositories/tagRepo/tagRepoModel.dart';

final List<CollectionSchema> dbSchemas = [TagSchema, NoteSchema];

final GlobalKey appKey = GlobalKey();
