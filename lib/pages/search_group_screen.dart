import 'package:flutter/material.dart';

class SearchGroupScreen extends StatelessWidget {
  const SearchGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Group'),
      ),
      body: const Center(
        child: Text('Search Group Screen'),
      ),
    );
  }
}
