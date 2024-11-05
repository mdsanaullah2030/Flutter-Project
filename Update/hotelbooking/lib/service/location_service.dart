import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:hotelbooking/service/AuthService.dart';

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



  // Method to update a location
  Future<void> updateLocation(Location location) async {
    if (location.id == null) {
      throw Exception('Location ID is required for update');
    }

    final response = await http.put(
      Uri.parse('$apiUrl${location.id}'), // Use the location ID in the URL
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(location.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }



  //Location Data Save//

  final Dio _dio = Dio();

  final AuthService authService = AuthService();


  Future<Location?> createHotel(Location hotel, XFile? image) async {
    final formData = FormData();

    formData.fields.add(MapEntry('hotel', jsonEncode(hotel.toJson())));

    if (image != null) {
      final bytes = await image.readAsBytes();
      formData.files.add(MapEntry('image', MultipartFile.fromBytes(
        bytes,
        filename: image.name,
      )));
    }

    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.post(
        '${apiUrl}save',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Location.fromJson(data); // Parse response data to Hotel object
      } else {
        print('Error creating hotel: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Error creating hotel: ${e.message}');
      return null;
    }
  }

}
