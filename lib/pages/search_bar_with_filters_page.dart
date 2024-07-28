import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/models/group.dart';

class SearchBarWithFiltersPage extends StatefulWidget {
  const SearchBarWithFiltersPage({super.key});

  @override
  _SearchBarWithFiltersPageState createState() => _SearchBarWithFiltersPageState();
}

class _SearchBarWithFiltersPageState extends State<SearchBarWithFiltersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDay = 'Any';

  final List<String> _days = [
    'Any',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Future<List<Group>> _searchGroups(String query, String day) async {
    QuerySnapshot snapshot;
    if (day == 'Any') {
      snapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('drivingDays', arrayContains: day)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
    }
    return snapshot.docs.map((doc) => Group.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Groups')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search by Group Name'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedDay,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
              items: _days.map<DropdownMenuItem<String>>((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<Group> results = await _searchGroups(_searchController.text.trim(), _selectedDay);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(results: results),
                  ),
                );
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultsPage extends StatelessWidget {
  final List<Group> results;

  const SearchResultsPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index].name),
            subtitle: Text(results[index].description),
            onTap: () {
              // Navigate to group details page
            },
          );
        },
      ),
    );
  }
}
