import 'package:flutter/material.dart';
import 'package:hotelbooking/model/booking.dart';

import 'package:hotelbooking/service/booking_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ViewBooking extends StatefulWidget {
  const ViewBooking({super.key});

  @override
  State<ViewBooking> createState() => _AllBookingViewPageState();
}

class _AllBookingViewPageState extends State<ViewBooking> {
  late Future<List<Booking>> futureBooking;

  @override
  void initState() {
    super.initState();
    futureBooking = BookingService().fetchBookings();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
      ),
      body: FutureBuilder<List<Booking>>(
        future: futureBooking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Hotel: ${booking.hotelName}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Room Type: ${booking.roomType}'),
                              Text('Check-in: ${booking.checkindate}'),
                              Text('Check-out: ${booking.checkoutdate}'),
                              Text('Total Price: \$${booking.totalprice}'),
                              Text('User: ${booking.userName}'),
                              Text('Email: ${booking.userEmail}'),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
