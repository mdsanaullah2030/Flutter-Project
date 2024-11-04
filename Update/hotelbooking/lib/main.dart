import 'package:flutter/material.dart';
import 'package:hotelbooking/AddHotelPage.dart';
import 'package:hotelbooking/HomeBody.dart';
import 'package:hotelbooking/all_hotel_view_page.dart';
import 'package:hotelbooking/digain.dart';
import 'package:hotelbooking/home.dart';
import 'package:hotelbooking/hotellist.dart';
import 'package:hotelbooking/inout.dart';
import 'package:hotelbooking/location.dart';
import 'package:hotelbooking/location_view.dart';
import 'package:hotelbooking/registrationpage.dart';
import 'package:hotelbooking/view_booking.dart';
import 'package:hotelbooking/view_room.dart';
import 'package:hotelbooking/welcome.dart';

import 'location_create.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home:LocationView(

      ),
    );
  }
}
