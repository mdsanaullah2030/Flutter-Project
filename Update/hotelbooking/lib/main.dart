import 'package:flutter/material.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/CarouselSlider.dart';
import 'package:hotelbooking/hotel/all_hotel_view_page.dart';
import 'package:hotelbooking/home.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/registrationpage.dart';
import 'package:hotelbooking/booking/view_booking.dart';
import 'package:hotelbooking/room/view_room.dart';
import 'package:hotelbooking/welcome.dart';

import 'location/AddLocation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home:RegistrationPage(

      ),
    );
  }
}
