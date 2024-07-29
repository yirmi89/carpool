import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool/generated/l10n.dart';

class MapIntegrationPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const MapIntegrationPage({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _MapIntegrationPageState createState() => _MapIntegrationPageState();
}

class _MapIntegrationPageState extends State<MapIntegrationPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    FirebaseFirestore.instance.collection('groups').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        GeoPoint point = doc['location'];
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(point.latitude, point.longitude),
            infoWindow: InfoWindow(title: doc['name']),
          ),
        );
      });

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).map),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(31.0461, 34.8516), // Center of Israel
          zoom: 8,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
