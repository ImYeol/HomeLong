import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

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
  late String sessionToken;
  var apiKey;
  final client = Client();
  final log = Logger("PlaceApiProvider");

  static final String androidKey = 'AIzaSyAGd5wfEqmJWKd4zxjsBHqrNYBn9T4tNjw';
  static final String iosKey = 'AIzaSyD0Palsyb5Wtg5_0uFHm6E6uFfCw0OD7W8';
  static final String other = 'AIzaSyDJlAkU9g2IFIyhfgx1xv_oke1hk1w2nKQ';

  PlaceApiProvider({required String sessionToken}) {
    this.sessionToken = sessionToken;
    log.info("Platform:${Platform.operatingSystem}");

    if (Platform.isAndroid) {
      apiKey = androidKey;
    } else if (Platform.isIOS) {
      apiKey = iosKey;
    } else {
      apiKey = other;
    }
  }

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
}
