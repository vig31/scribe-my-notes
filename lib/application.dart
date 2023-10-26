import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:notebook/pages/searchPage/searchPage.view.dart';

import 'helpers/constants.dart';
import 'pages/crerateAndEditPage/createAndEditPage.view.dart';
import 'pages/homePage/homePage.view.dart';
import 'resources/theme/theme.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, dark) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && dark != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = dark.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          key: appKey,
          debugShowCheckedModeBanner: false,
          theme: lightTheme.copyWith(colorScheme: lightColorScheme),
          darkTheme: darkTheme.copyWith(colorScheme: darkColorScheme),
          themeMode: ThemeMode.system,
          onGenerateRoute: onGenrateRoute,
          localizationsDelegates: const [
            AppFlowyEditorLocalizations.delegate,
          ],
        );
      },
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
      return MaterialPageRoute(
        builder: (_) => CreateAndEditPageView(
          editNoteId: (settings.arguments as Map?)?["editNoteId"] ?? -1,
          isEdit: (settings.arguments as Map?)?["isEdit"] ?? false,
        ),
      );
    case '/search':
      return MaterialPageRoute(
        builder: (_) => const SearchPage(),
      );
    default:
      // Handle unknown routes here or return an error route
      return MaterialPageRoute(builder: (_) => const HomePageView());
  }
}
