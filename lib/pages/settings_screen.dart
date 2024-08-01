import 'package:flutter/material.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en'; // Default value

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    _saveSelectedLanguage(languageCode);
    widget.onLocaleChange(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C4B93),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(S.of(context).selectLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(
                  child: Text('English'),
                  value: 'en',
                ),
                DropdownMenuItem(
                  child: Text('עברית'),
                  value: 'he',
                ),
              ],
              onChanged: (String? languageCode) {
                if (languageCode != null) {
                  _changeLanguage(languageCode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
