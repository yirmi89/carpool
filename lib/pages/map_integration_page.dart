import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:carpool/methods/common_methods.dart';
import 'package:carpool/generated/l10n.dart';

class MapIntegrationPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  MapIntegrationPage({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _MapIntegrationPageState createState() => _MapIntegrationPageState();
}

class _MapIntegrationPageState extends State<MapIntegrationPage> {
  late GoogleMapController _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final CommonMethods commonMethods = CommonMethods();

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData loc) {
      _currentLocation = loc;
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
            zoom: 15,
          ),
        ),
      );
    });
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    final groups = await FirebaseFirestore.instance.collection('groups').get();
    setState(() {
      for (var doc in groups.docs) {
        final data = doc.data();
        final groupName = data['groupName'] as String;
        final destinationAddress = data['destinationAddress'] as String;

        // Here, you can convert the destinationAddress to LatLng if you have geocoding service

        // For demonstration, assuming fixed LatLng values
        final latLng = LatLng(37.7749, -122.4194); // replace with actual coordinates

        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: latLng,
            infoWindow: InfoWindow(
              title: groupName,
              snippet: destinationAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
    });
  }

  Future<void> _goToCurrentLocation() async {
    final loc = await _location.getLocation();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _searchGroupByName(String groupName) async {
    final groups = await FirebaseFirestore.instance
        .collection('groups')
        .where('groupName', isEqualTo: groupName)
        .get();

    if (groups.docs.isNotEmpty) {
      final data = groups.docs.first.data();
      final destinationAddress = data['destinationAddress'] as String;

      // Convert destinationAddress to LatLng if you have geocoding service

      // For demonstration, assuming fixed LatLng values
      final latLng = LatLng(37.7749, -122.4194); // replace with actual coordinates

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15,
          ),
        ),
      );

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(groups.docs.first.id),
            position: latLng,
            infoWindow: InfoWindow(
              title: groupName,
              snippet: destinationAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      });
    } else {
      // Show error message if group not found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).error),
          content: Text(S.of(context).groupNotFound),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1C4B93);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // San Francisco coordinates
              zoom: 10,
            ),
            markers: _markers,
            myLocationEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: S.of(context).chooseAddress,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await commonMethods.getAddresses(_searchController.text, pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _searchController.text = suggestion.toString();
                    // You can implement moving to this location on the map if you have coordinates
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    hintText: S.of(context).enterGroupName,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (value) {
                    _searchGroupByName(value);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: primaryColor,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
