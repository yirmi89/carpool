import 'package:flutter/material.dart';

class SearchGroupScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const SearchGroupScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Group'),
      ),
      body: Center(
        child: Text('Search Group Screen'),
      ),
    );
  }
}
