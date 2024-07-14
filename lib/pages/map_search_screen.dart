import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math'; // Import the math library for sin, cos, atan2, sqrt, and pi

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  GoogleMapController? _controller;
  LocationData? _currentLocation;
  double _searchRadius = 5.0; // in kilometers
  Set<Marker> _markers = <Marker>{}; // Initialize the markers set

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
      _loadDummyGroups();
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

  void _loadDummyGroups() {
    if (_currentLocation == null) return;

    final userLocation = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    final radiusInMeters = _searchRadius * 1000;

    // Example hardcoded group data
    final groups = [
      {
        'name': 'Group 1',
        'location': LatLng(userLocation.latitude + 0.01, userLocation.longitude + 0.01),
      },
      {
        'name': 'Group 2',
        'location': LatLng(userLocation.latitude + 0.02, userLocation.longitude + 0.02),
      },
      {
        'name': 'Group 3',
        'location': LatLng(userLocation.latitude - 0.01, userLocation.longitude - 0.01),
      },
    ];

    Set<Marker> markers = {};
    for (var group in groups) {
      final groupLocation = group['location'] as LatLng;

      if (_calculateDistance(userLocation, groupLocation) <= radiusInMeters) {
        markers.add(
          Marker(
            markerId: MarkerId(group['name'] as String),
            position: groupLocation,
            infoWindow: InfoWindow(title: group['name'] as String),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // meters
    final double dLat = _degreesToRadians(end.latitude - start.latitude);
    final double dLng = _degreesToRadians(end.longitude - start.longitude);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) * cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Groups on Map'),
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Search Radius: ${_searchRadius.toStringAsFixed(1)} km'),
                Slider(
                  min: 1,
                  max: 20,
                  divisions: 19,
                  value: _searchRadius,
                  onChanged: (value) {
                    setState(() {
                      _searchRadius = value;
                      _loadDummyGroups();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
