import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math'; // Import the math library for sin, cos, atan2, sqrt, and pi

class SearchByPlaceScreen extends StatefulWidget {
  const SearchByPlaceScreen({super.key});

  @override
  _SearchByPlaceScreenState createState() => _SearchByPlaceScreenState();
}

class _SearchByPlaceScreenState extends State<SearchByPlaceScreen> {
  GoogleMapController? _controller;
  LocationData? _currentLocation;
  Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    setState(() {
      if (_controller != null) {
        _controller!.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          ),
        );
      }
      _addCurrentLocationMarker();
    });
  }

  void _addCurrentLocationMarker() {
    if (_currentLocation == null) return;

    final userLocation = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: userLocation,
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });
  }

  void _searchPlace() {
    final query = _searchController.text;

    // Dummy data for example
    final groups = [
      {
        'name': 'School Group',
        'place': 'School',
        'location': LatLng(_currentLocation!.latitude! + 0.01, _currentLocation!.longitude! + 0.01),
      },
      {
        'name': 'Kindergarten Group',
        'place': 'Kindergarten',
        'location': LatLng(_currentLocation!.latitude! + 0.02, _currentLocation!.longitude! + 0.02),
      },
      {
        'name': 'Class Group',
        'place': 'Class',
        'location': LatLng(_currentLocation!.latitude! - 0.01, _currentLocation!.longitude! - 0.01),
      },
    ];

    Set<Marker> markers = {};
    for (var group in groups) {
      if (group['place'] == query) {
        markers.add(
          Marker(
            markerId: MarkerId(group['name'] as String),
            position: group['location'] as LatLng,
            infoWindow: InfoWindow(title: group['name'] as String),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Group by Place'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter place name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchPlace,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
                if (_currentLocation != null) {
                  _controller!.moveCamera(
                    CameraUpdate.newLatLng(
                      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                    ),
                  );
                }
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15,
              ),
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
