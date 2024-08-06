import 'package:google_maps_webservice/places.dart';

class CommonMethods {
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: '');

  Future<List<String>> getAddresses(String city, String pattern) async {
    final response = await _places.autocomplete(
      pattern,
      components: [Component(Component.country, 'il')],
    );
    if (response.isOkay) {
      return response.predictions.map((p) => p.description!).toList();
    } else {
      return <String>[];  // Return an empty list instead of List<String?>
    }
  }
}
