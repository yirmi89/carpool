import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpool/generated/l10n.dart';
import 'package:geocoding/geocoding.dart';

class SearchBarWithFiltersPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  SearchBarWithFiltersPage({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _SearchBarWithFiltersPageState createState() => _SearchBarWithFiltersPageState();
}

class _SearchBarWithFiltersPageState extends State<SearchBarWithFiltersPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _destinationFilterController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> _allGroups = [];
  List<DocumentSnapshot> _filteredGroups = [];
  bool _loading = false;
  late String userDepartureCity;

  @override
  void initState() {
    super.initState();
    _loadUserDepartureLocation();
  }

  Future<void> _loadUserDepartureLocation() async {
    setState(() {
      _loading = true;
    });

    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('departureLocation')) {
          final departureLocation = data['departureLocation'];
          userDepartureCity = await _extractCityFromAddress(departureLocation);
          _fetchGroups();
        }
      }
    }
  }

  Future<void> _fetchGroups() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('groups').get();
    final List<DocumentSnapshot> allGroups = snapshot.docs;

    setState(() {
      _allGroups = allGroups;
      _filteredGroups = allGroups.where((group) {
        final groupDestination = group['destinationAddress'];
        return groupDestination.contains(userDepartureCity);
      }).toList();
      _loading = false;
    });
  }

  Future<String> _extractCityFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final placemarks = await placemarkFromCoordinates(locations[0].latitude, locations[0].longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? '';
      }
    }
    return '';
  }

  void _filterGroups(String query) {
    final List<DocumentSnapshot> filteredGroups = _allGroups.where((group) {
      final String groupName = group['groupName'].toLowerCase();
      return groupName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredGroups = filteredGroups;
    });
  }

  void _filterGroupsByDestination(String destination) {
    final List<DocumentSnapshot> filteredGroups = _allGroups.where((group) {
      final String groupDestination = group['destinationAddress'].toLowerCase();
      return groupDestination.contains(destination.toLowerCase());
    }).toList();

    setState(() {
      _filteredGroups = filteredGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93); // Adjusted color from the carpool logo

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).searchForGroups,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set the arrow color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: S.of(context).searchGroups,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _filterGroups(_searchController.text),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _destinationFilterController,
                  decoration: InputDecoration(
                    labelText: S.of(context).filterByDestination,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _filterGroupsByDestination(_destinationFilterController.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _loading
              ? const CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: _filteredGroups.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot group = _filteredGroups[index];
                final String groupName = group['groupName'];
                final String destination = group['destinationAddress'];
                final int maxUsers = group['maxUsers'];
                final int currentUsers = group['currentUsers'];
                final int remainingSeats = maxUsers - currentUsers;
                final bool isFull = remainingSeats <= 0;

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text(destination),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (isFull)
                              Text(
                                S.of(context).groupIsFull,
                                style: TextStyle(color: Colors.red),
                              )
                            else
                              Text(
                                S.of(context).placesLeft(remainingSeats),
                                style: TextStyle(color: Colors.green),
                              ),
                            if (!isFull)
                              ElevatedButton(
                                onPressed: () => _joinGroup(context, group.id, remainingSeats),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(S.of(context).join),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinGroup(BuildContext context, String groupId, int remainingSeats) async {
    showDialog(
      context: context,
      builder: (context) {
        int childrenToAdd = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context).joinGroup),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).howManyChildren),
                  DropdownButton<int>(
                    value: childrenToAdd,
                    items: List.generate(remainingSeats, (index) => index + 1)
                        .map((int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    ))
                        .toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          childrenToAdd = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(S.of(context).close),
                ),
                TextButton(
                  onPressed: () async {
                    final user = _auth.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
                        'currentUsers': FieldValue.increment(childrenToAdd),
                        'participants': FieldValue.arrayUnion([user.uid]) // Add user ID to participants array
                      });

                      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                        'groups': FieldValue.arrayUnion([groupId])
                      });

                      Navigator.pop(context);
                      _showSuccessDialog(context);
                      _fetchGroups();
                    }
                  },
                  child: Text(S.of(context).join),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).success),
        content: Text(S.of(context).congratulations),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }
}
