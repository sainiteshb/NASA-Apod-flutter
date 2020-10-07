import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nasa_apod/providers/apod_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Apod.dart';

Future<void> main() async {
  await _initApp();
  runApp(MyApp());
}

// This function performs initial setup for this app.
Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  var settingsBox = await Hive.openBox('settings');
  if (settingsBox.get('isDarkTheme') == null) {
    settingsBox.put('isDarkTheme', false);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Box<dynamic>>(
          create: (context) => Hive.box('settings'),
        ),
        ChangeNotifierProvider(
          create: (context) => ApodProvider(
            date: DateTime.now(),
          ),
        ),
      ],
      builder: (BuildContext context, Widget child) {
        return ValueListenableBuilder(
          valueListenable: Provider.of<Box<dynamic>>(context).listenable(),
          builder: (BuildContext context, value, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Nasa APOD',
              theme: ThemeData(
                primaryColor: Colors.white,
              ),
              darkTheme: ThemeData.dark(),
              themeMode: Provider.of<Box<dynamic>>(context).get('isDarkTheme')
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: ApodPage(),
            );
          },
        );
      },
    );
  }
}
