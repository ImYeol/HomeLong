import 'dart:convert';

import 'package:http/http.dart';

class GPSService {}

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyAGd5wfEqmJWKd4zxjsBHqrNYBn9T4tNjw';
  static final String iosKey = 'AIzaSyD0Palsyb5Wtg5_0uFHm6E6uFfCw0OD7W8';
  static final String other = 'AIzaSyDJlAkU9g2IFIyhfgx1xv_oke1hk1w2nKQ';

  //TODO: for debugging
  final apiKey = other;

  // final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

// Future<Place> getPlaceDetailFromId(String placeId) async {
//   final request =
//       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';
//   final response = await client.get(request);
//
//   if (response.statusCode == 200) {
//     final result = json.decode(response.body);
//     if (result['status'] == 'OK') {
//       final components =
//       result['result']['address_components'] as List<dynamic>;
//       // build result
//       final place = Place();
//       components.forEach((c) {
//         final List type = c['types'];
//         if (type.contains('street_number')) {
//           place.streetNumber = c['long_name'];
//         }
//         if (type.contains('route')) {
//           place.street = c['long_name'];
//         }
//         if (type.contains('locality')) {
//           place.city = c['long_name'];
//         }
//         if (type.contains('postal_code')) {
//           place.zipCode = c['long_name'];
//         }
//       });
//       return place;
//     }
//     throw Exception(result['error_message']);
//   } else {
//     throw Exception('Failed to fetch suggestion');
//   }
// }
}
