

import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/room.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RoomService {


  Future<Hotel> fetchHotelById(int hotelId) async {
    final String url = 'http://localhost:8080/api/hotel/$hotelId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Hotel.fromJson(data);
    } else {
      throw Exception('Failed to load hotel data');
    }
  }



  Future<List<Room>> fetchRoomsByHotelId(int hotelId) async {

    final String url = 'http://localhost:8080/api/room/r/searchroombyid?hotelid=$hotelId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          // Cast each item in the list to Map<String, dynamic> and parse
          return data.map((room) => Room.fromJson(room as Map<String, dynamic>)).toList();
        } else if (data is Map) {
          // Cast the single Map to Map<String, dynamic> and wrap in a list
          return [Room.fromJson(data as Map<String, dynamic>)];
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load room data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

}
