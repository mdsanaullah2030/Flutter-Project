import 'package:flutter/material.dart';
import 'package:hotelbooking/booking/Invoice.dart';
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

  Future<void> _viewBookingPdf(Booking booking) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Hotel Booking Details", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Hotel: ${booking.hotelName}"),
            pw.Text("Room Type: ${booking.roomType}"),
            pw.Text("Check-in: ${booking.checkindate}"),
            pw.Text("Check-out: ${booking.checkoutdate}"),
            pw.Text("Total Price: \$${booking.totalprice}"),
            pw.Text("User: ${booking.userName}"),
            pw.Text("Email: ${booking.userEmail}"),
          ],
        ),
      ),
    );

    // // Get the directory to save the PDF
    // final output = await getTemporaryDirectory();
    // final filePath = "${output.path}/booking_${booking.id}.pdf";
    // final file = File(filePath);
    //
    // // Save the PDF file
    // await file.writeAsBytes(await pdf.save());
    //
    // // Optionally, open or share the PDF file (you can implement this feature as well)
    // print('PDF saved to: $filePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blue, Colors.greenAccent,Colors.teal], // Define gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text('All Boking'),
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Optional: Remove shadow
          ),
        ),
      ),
      body: Container( // Use Container to apply the decoration
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightGreen[50]!, // First color
                Colors.blue[50]!,
                Colors.indigo[50]!,
                Colors.red[50]!, // Second color
              ],
              begin: Alignment.topLeft, // Start of the gradient
              end: Alignment.bottomRight, // End of the gradient
            ),
          ),
          child: FutureBuilder<List<Booking>>(
            future: futureBooking, // Replace with your actual future data source
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No bookings available', style: TextStyle(fontSize: 16)));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final booking = snapshot.data![index];
                    return MouseRegion(
                      onEnter: (_) {
                        // You can add any hover logic here (e.g., changing color)
                      },
                      onExit: (_) {
                        // Revert changes when mouse leaves
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.white, // Background color of the card
                        elevation: 5, // Optional: adds shadow to the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  'Hotel: ${booking.hotelName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                   
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateBookingPage(booking: booking),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )


      ),
    );
  }

}

