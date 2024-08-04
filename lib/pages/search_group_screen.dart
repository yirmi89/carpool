import 'package:flutter/material.dart';
import 'package:carpool/pages/map_integration_page.dart';
import 'package:carpool/pages/search_bar_with_filters_page.dart';
import 'package:carpool/generated/l10n.dart';

class SearchGroupScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SearchGroupScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _SearchGroupScreenState createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends State<SearchGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).chooseSearchOption,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Set the arrow color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildMenuButton(
                  context,
                  S.of(context).searchByOpenSearch,
                  Icons.search,
                  primaryColor,
                  SearchBarWithFiltersPage(onLocaleChange: widget.onLocaleChange),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildMenuButton(
                  context,
                  S.of(context).searchOnMap,
                  Icons.map,
                  primaryColor,
                  MapIntegrationPage(onLocaleChange: widget.onLocaleChange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0), // Adding margin to separate the buttons
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity, // Fill available space
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 80),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
