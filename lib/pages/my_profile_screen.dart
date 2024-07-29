import 'package:flutter/material.dart';
import 'package:carpool/generated/l10n.dart';

class MyProfileScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChange;

  const MyProfileScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).profile,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Example profile details
              Text(
                S.of(context).firstName + ': John',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).lastName + ': Doe',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).email + ': john.doe@example.com',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Example of using onLocaleChange to switch languages
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(S.of(context).selectLanguage),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('English'),
                            onTap: () {
                              onLocaleChange(Locale('en'));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text('עברית'),
                            onTap: () {
                              onLocaleChange(Locale('he'));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(S.of(context).selectLanguage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
