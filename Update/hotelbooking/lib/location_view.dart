import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotelbooking/all_hotel_view_page.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:hotelbooking/service/location_service.dart';
import 'package:intl/intl.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late Future<List<Location>> futureLocations;
  List<Location> allLocations = []; // To store all locations
  List<Location> filteredLocations = []; // To store filtered locations

  DateTime? checkInDate;
  DateTime? checkOutDate;

  int rooms = 1;
  int adults = 1;
  int children = 0;

  String searchQuery = ''; // To store the current search query

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
  void initState() {
    super.initState();
    futureLocations = LocationService().fetchLocation().then((locations) {
      allLocations = locations; // Store all locations
      filteredLocations = locations; // Initially, display all locations
      return locations;
    });
  }

  void _filterLocations(String query) {
    setState(() {
      searchQuery = query;
      filteredLocations = allLocations
          .where((location) => location.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
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
            SizedBox(height: 16.0),
            // Search bar
            TextField(
              onChanged: _filterLocations,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.amber,
                hintText: 'Search Locations',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
            Text("Available Locations:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<Location>>(
                future: futureLocations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No locations available'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = filteredLocations[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: location.image != null
                                    ? Image.network(
                                  "http://localhost:8080/images/location/${location.image}",
                                  width: 50,
                                  height: 50,
                                )
                                    : Icon(Icons.location_on),
                                title: Text(location.name ?? 'Unnamed Location'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to AllHotelViewPage with the selected location
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AllHotelViewPage(location: location ,)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'View Hotel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) {
    return Container(
      width: 120.0,
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
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Text(
                value.toString(),
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: Icon(Icons.add, size: 16.0),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
