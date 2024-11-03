import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotelbooking/model/lcation.dart';

class LocationService {
  final String apiUrl = 'http://localhost:8080/api/location/';

  Future<List<Location>> fetchLocation() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> locationJson = json.decode(response.body);
      return locationJson.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  // New method to create a location
  Future<void> createLocation(Location location) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(location.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create location');
    }
  }
}
