import 'package:expenses_manager/expenses.dart';
import 'package:flutter/material.dart';

// setting color theme
var kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Colors.amber,
);
// dark mode theme
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.amber,
);
void main() {
  // locking the screen orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((fn) {
  //   // only run the app after the orientation has been locked
  //   runApp(const MainApp());
  // });

  // without device orientation
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // setting the app theming can be done here and only here
    return MaterialApp(
      // add dark mode theme
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.normal,
                color: kDarkColorScheme.onSecondaryContainer,
              ),
            ),
        iconTheme: ThemeData().iconTheme.copyWith(
              color: kDarkColorScheme.onSecondaryContainer,
            ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.onPrimaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.onSecondaryContainer,
        ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: const Expenses(),
    );
  }
}
