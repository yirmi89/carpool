import 'package:flutter/material.dart';
import 'package:carpool/generated/l10n.dart';

class GroupPage extends StatelessWidget {
  final String groupName;
  final String groupId;
  final void Function(Locale) onLocaleChange;

  const GroupPage({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).goToAllGroups),
        ),
      ),
    );
  }
}
