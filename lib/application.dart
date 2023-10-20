import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

import 'pages/crerateAndEditPage/createAndEditPage.view.dart';
import 'pages/homePage/homePage.view.dart';
import 'resources/theme/theme.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      )),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: "/create",
      onGenerateRoute: onGenrateRoute,
      localizationsDelegates: const [
        AppFlowyEditorLocalizations.delegate,
      ],
    );
  }
}

Route onGenrateRoute(RouteSettings settings) {
  // Extract the route name
  final String routeName = settings.name ?? "/";

  switch (routeName) {
    case '/':
      return MaterialPageRoute(builder: (_) => const HomePageView());
    case '/create' || "/edit":
      return MaterialPageRoute(builder: (_) =>  CreateAndEditPageView(editNoteId: (settings.arguments as Map?)?["editNoteId"] ?? -1 , isEdit:  (settings.arguments as Map?)?["isEdit"] ?? false ,));
    default:
      // Handle unknown routes here or return an error route
      return MaterialPageRoute(builder: (_) => const HomePageView());
  }
}
