import 'dart:async';
import 'dart:convert' show json;

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'locations.dart';
import 'restaurant.dart';

class ZomatoClient {
  final _apiKey = '1e3c349cc25d35cea4a89cf86995cd6b';
  final _host = 'developers.zomato.com';
  final _contextRoot = 'api/v2.1';

  Future<List<Locations>> fetchLocations(String query) async {
    print(query);
    final results = await request(
        path: 'locations', parameters: {'query': query, 'count': '10'});

    final suggestions = results['location_suggestions'];
    return suggestions
        .map<Locations>((json) => Locations.fromJson(json))
        .toList(growable: false);
  }

  Future<List<Restaurant>> fetchRestaurantsByMyPosition(
      Position location) async {
    final results = await request(path: 'search', parameters: {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
      'count': '10',
    });

    final restaurants = results['restaurants']
        .map<Restaurant>((json) => Restaurant.fromJson(json['restaurant']))
        .toList(growable: false);

    return restaurants;
  }


  Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final results = await http.get(uri, headers: _headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Map<String, String> get _headers =>
      {'Accept': 'application/json', 'user-key': _apiKey};
}
