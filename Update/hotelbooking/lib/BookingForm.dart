import 'package:flutter/material.dart';
import 'package:hotelbooking/model/booking.dart';
import 'package:hotelbooking/service/booking_service.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int totalPrice = 0; // You might calculate this based on selected room
  String roomType = '';
  String hotelName = '';
  String userName = '';
  String userEmail = '';

  final BookingService bookingService = BookingService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Booking booking = Booking(
        checkindate: checkInDate!,
        checkoutdate: checkOutDate!,
        totalprice: totalPrice,
        roomType: roomType,
        hotelName: hotelName,
        userName: userName,
        userEmail: userEmail,
      );

      try {
        bool success = await bookingService.confirmBooking(booking);
        if (success) {
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking confirmed successfully!')),
          );
          // Optionally, navigate to another page or reset the form
        }
      } catch (e) {
        // Handle error, show message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'User Name'),
                onSaved: (value) {
                  userName = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'User Email'),
                onSaved: (value) {
                  userEmail = value!;
                },
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              // You might want to use a DatePicker for check-in and check-out dates
              ElevatedButton(
                onPressed: () async {
                  // Show Date Picker for check-in and check-out dates
                },
                child: Text('Select Dates'),
              ),
              // Add fields for room type, hotel name, and total price as needed
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
