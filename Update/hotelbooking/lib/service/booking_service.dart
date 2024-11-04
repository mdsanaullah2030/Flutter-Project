import 'dart:convert';
import 'package:hotelbooking/model/booking.dart';
import 'package:http/http.dart' as http;

class BookingService {
  final String apiUrl = 'http://localhost:8080/api/booking/';

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

  Future<bool> confirmBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse('${apiUrl}save'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(booking.toJson()),
    );

    if (response.statusCode == 200) {
      print("Booking confirmed successfully!");
      return true;
    } else {
      throw Exception('Failed to confirm booking');
    }
  }




}