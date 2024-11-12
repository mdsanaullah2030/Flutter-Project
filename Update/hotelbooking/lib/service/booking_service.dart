import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotelbooking/model/booking.dart';
import 'package:hotelbooking/service/AuthService.dart';
import 'package:http/http.dart' as http;

class BookingService {
  final String apiUrl = 'http://localhost:8080/api/booking/';

  //Bookng Data show//

  Future<List<Booking>> fetchBookings() async {
    final response = await http.get(Uri.parse(apiUrl));

    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> bookingJson = json.decode(response.body);
      return bookingJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }





  //Bookng save//

  final Dio _dio = Dio();

  final AuthService authService = AuthService();





  Future<Booking?> createHotel(Booking booking) async {
    final formData = FormData();

    // Add only the hotel data to formData
    formData.fields.add(MapEntry('hotel', jsonEncode(booking.toJson())));

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
        return Booking.fromJson(data); // Parse response data to Hotel object
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