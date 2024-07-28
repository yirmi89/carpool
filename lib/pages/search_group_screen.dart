import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/models/group.dart';

class SearchGroupScreen extends StatefulWidget {
  const SearchGroupScreen({super.key});

  @override
  _SearchGroupScreenState createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends State<SearchGroupScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadGroupsOnMap();
  }

  Future<void> _loadGroupsOnMap() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('groups').get();
    setState(() {
      _markers.clear();
      for (var doc in snapshot.docs) {
        Group group = Group.fromMap(doc.data() as Map<String, dynamic>);
        // Example coordinates, replace with actual group's location data
        double latitude = 37.7749;
        double longitude = -122.4194;

        _markers.add(
          Marker(
            markerId: MarkerId(group.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: group.name,
              snippet: group.description,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Groups on Map')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0), // Replace with initial position
          zoom: 10.0,
        ),
        markers: _markers,
      ),
    );
  }
}
