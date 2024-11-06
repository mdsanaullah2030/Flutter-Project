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
  int totalPrice = 0;
  int roomPrice = 100; // Example room price, replace with dynamic fetching if needed
  final BookingService bookingService = BookingService();

  void calculateTotalPrice() {
    if (checkInDate != null && checkOutDate != null) {
      int dayCount = checkOutDate!.difference(checkInDate!).inDays;
      setState(() {
        totalPrice = dayCount * roomPrice;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create a new booking instance
      Booking booking = Booking(
        checkindate: checkInDate,
        checkoutdate: checkOutDate,
        totalprice: totalPrice,
      );

      try {
        bool success = await bookingService.confirmBooking(booking);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking confirmed successfully!')),
          );
        }
      } catch (e) {
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
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => checkInDate = picked);
                    calculateTotalPrice();
                  }
                },
                child: Text('Select Check-In Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: checkInDate != null
                        ? checkInDate!.add(Duration(days: 1))
                        : DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => checkOutDate = picked);
                    calculateTotalPrice();
                  }
                },
                child: Text('Select Check-Out Date'),
              ),
              Text('Total Price: \$${totalPrice}'),
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
