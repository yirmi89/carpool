import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIntegrationPage extends StatefulWidget {
  const MapIntegrationPage({super.key});

  @override
  _MapIntegrationPageState createState() => _MapIntegrationPageState();
}

class _MapIntegrationPageState extends State<MapIntegrationPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkers();
  }

  void _addMarkers() {
    setState(() {
      _markers.addAll([
        Marker(
          markerId: const MarkerId('group1'),
          position: const LatLng(45.521563, -122.677433),
          infoWindow: const InfoWindow(
            title: 'Ride Group 1',
            snippet: '5 seats available',
          ),
        ),
        Marker(
          markerId: const MarkerId('group2'),
          position: const LatLng(45.531563, -122.677433),
          infoWindow: const InfoWindow(
            title: 'Ride Group 2',
            snippet: '3 seats available',
          ),
        ),
        // Add more markers as needed
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Ride Groups'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
