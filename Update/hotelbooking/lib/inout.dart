import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  int rooms = 1;
  int adults = 1;
  int children = 0;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: Text("Booking Details")),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB81736),
              Color(0xff2B1836),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Check-in Date:"),
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context, true),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.amber,
                hintText: checkInDate != null
                    ? dateFormat.format(checkInDate!)
                    : "Select Check-in Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text("Check-out Date:"),
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context, false),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.amber,
                hintText: checkOutDate != null
                    ? dateFormat.format(checkOutDate!)
                    : "Select Check-out Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildCounter("Rooms", rooms, (newValue) =>
                    setState(() => rooms = newValue))),
                SizedBox(width: 8.0),
                Expanded(child: _buildCounter("Adults", adults, (newValue) =>
                    setState(() => adults = newValue))),
                SizedBox(width: 8.0),
                Expanded(child: _buildCounter(
                    "Children", children, (newValue) =>
                    setState(() => children = newValue))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) {
    return Container(
      width: 120.0, // Set a fixed width for each counter box
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => onChanged(value > 0 ? value - 1 : 0),
                icon: Icon(Icons.remove, size: 16.0),
                // Adjust icon size as needed
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(), // Reduces IconButton size
              ),
              Text(
                value.toString(),
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: Icon(Icons.add, size: 16.0), // Adjust icon size as needed
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(), // Reduces IconButton size
              ),
            ],
          ),
        ],
      ),
    );
  }
}