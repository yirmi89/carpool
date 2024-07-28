import 'package:flutter/material.dart';
import 'package:carpool/generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(S.of(context).selectLanguage),
            trailing: DropdownButton<String>(
              value: 'en', // default value or get it from settings
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
                  onLocaleChange(Locale(languageCode));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
