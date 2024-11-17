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


  Future<Booking?> saveBooking(Map<String, dynamic> bookingWithUserMap) async {
    try {
      String token = await authService.getToken() ?? '';
      final response = await _dio.post(
        '${apiUrl}save',
        data: bookingWithUserMap,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        print('Error saving booking: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Error saving booking: ${e.response?.data ?? e.message}');
      return null;
    }
  }


}