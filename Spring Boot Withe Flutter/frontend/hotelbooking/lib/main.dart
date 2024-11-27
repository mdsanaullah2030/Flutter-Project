import 'package:flutter/material.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/location/addshow.dart';
import 'package:hotelbooking/page/AdmnHome.dart';
import 'package:hotelbooking/page/CarouselSlider.dart';
import 'package:hotelbooking/hotel/AllHotelViewPage.dart';
import 'package:hotelbooking/page/home.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/page/registrationpage.dart';
import 'package:hotelbooking/booking/view_booking.dart';
import 'package:hotelbooking/room/view_room.dart';
import 'package:hotelbooking/page/welcome.dart';

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


      home:HomePage(

      ),
    );
  }
}
