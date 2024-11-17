

import 'package:dio/dio.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/room.dart';
import 'package:hotelbooking/service/AuthService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';


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










//Hotel Show//


  final String apiUrl =
      'http://localhost:8080/api/room/'; // Adjust to match your backend URL

  Future<List<Hotel>> fetchHotels() async {

    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200 ) {
      final List<dynamic> hotelJson = json.decode(response.body);

      return hotelJson.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }






  //Data Save Dio worck data data input //


  final Dio _dio = Dio();

  final AuthService authService = AuthService();



  Future<Hotel?> createHotel(Hotel hotel, XFile? image) async {
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
        return Hotel.fromJson(data); // Parse response data to Hotel object
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
