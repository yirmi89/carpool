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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set the arrow color to white
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 14),
          ],
        ),
      ),
    );
  }
}
