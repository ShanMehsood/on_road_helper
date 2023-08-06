import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:road_helper/splashscreen/splash_screen.dart';

Future main () async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  //This class defines the MainScreen widget,
  // which is a stateful widget. Stateful
  // widgets can change their state during the
  // lifetime of the widget.

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //BuildContext is a locator that is used to track each widget in a tree and
    // locate them and their position in the tree.In Flutter, the context refers
    // to the location of a widget in the widget tree. It provides information about
    // the surrounding environment and services that the widget might need. For example,
    // the context can contain information such as the theme of the app, the locale,
    // the screen size, and more.
    return const MaterialApp(
      title: 'Flutter Demo',

      home: SplashScreen(),
    );
  }
}

