
import 'package:flutter/material.dart';

class SavedNotesScreen extends StatelessWidget {
  const SavedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Notes'),
      ),
      body: const Center(
        child: Text('Your saved notes will appear here.'),
      ),
    );
  }
}
