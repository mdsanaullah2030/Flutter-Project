import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HotelService {


  Future<Location> fetchHotelById(int locationId) async {
    final String url = 'http://localhost:8080/api/location/$locationId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Location.fromJson(data);
    } else {
      throw Exception('Failed to load hotel data');
    }
  }


  Future<List<Hotel>> fetchRoomsByHotelId(int locationId) async {
    final String url = 'http://localhost:8080/api/hotel/getHotelsByLocationId?locationId=$locationId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((hotel) =>
              Hotel.fromJson(hotel as Map<String, dynamic>)).toList();
        } else if (data is Map) {
          return [Hotel.fromJson(data as Map<String, dynamic>)];
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        print('Failed to load hotel data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load hotel data');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}
