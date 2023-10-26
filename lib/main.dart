import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'application.dart';
import 'helpers/constants.dart';
import 'repositories/IsarDBRepo/isarSDRepo.dart';
import 'repositories/imagePickerRepo/imagePickerRepo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const Application());
}

Future<void> initApp() async {
  var appDir = (await getTemporaryDirectory()).path;
  Directory(appDir).delete(recursive: true);

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Channel',
        channelDescription: 'Notification channel for basic notifications',
        importance: NotificationImportance.High,
        criticalAlerts: true,
        enableVibration: true,
        enableLights: true,
        playSound: true,
      ),
    ],
  );
  var instance = IsarDBRepo();
  await instance.initDBWithSchema(schemas: dbSchemas);
  GetIt.I.registerLazySingleton<IsarDBRepo>(() => IsarDBRepo());
  GetIt.I.registerLazySingleton<ImagePickerRepo>(() => ImagePickerRepo());
}
