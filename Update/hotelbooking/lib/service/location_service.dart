import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotelbooking/model/Lcation.dart';
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






//All Location get kora Hotel show kora jono//


  Future<List<Location>> getAllLocations() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Location.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      throw Exception('Error fetching locations; please try again later.');
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



  Future<Location?> createLocation(Location location, XFile? image) async {
    final formData = FormData();

    formData.fields.add(MapEntry('location', jsonEncode(location.toJson())));

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












  String _checkinDate = '';
  String _checkoutDate = '';

  // Setters for check-in and check-out dates
  void setCheckinDate(String date) {
    _checkinDate = date;
  }

  void setCheckoutDate(String date) {
    _checkoutDate = date;
  }

  // Getters for check-in and check-out dates
  String getCheckinDate() {
    return _checkinDate;
  }

  String getCheckoutDate() {
    return _checkoutDate;
  }











}
