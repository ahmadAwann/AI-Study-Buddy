import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'features/saved_notes/services/hive_service.dart';

import 'features/saved_notes/screens/saved_notes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SavedNotesScreen(),
      // home: Scaffold(body: Center(child: Text('AI Study Buddy'))),
    );
  }
}
