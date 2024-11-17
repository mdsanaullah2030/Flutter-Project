import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotelbooking/location/UpdateLocation.dart';
import 'package:hotelbooking/model/Location.dart';
import 'package:hotelbooking/service/location_service.dart';
import 'package:http/http.dart' as http;

class LocationViewAdd extends StatefulWidget {
  const LocationViewAdd({super.key});

  @override
  State<LocationViewAdd> createState() => _LocationViewAddState();
}

class _LocationViewAddState extends State<LocationViewAdd> {
  late Future<List<Location>> futureLocations;
  List<Location> allLocations = [];
  List<Location> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    futureLocations = LocationService().fetchLocation().then((locations) {
      setState(() {
        allLocations = locations;
        filteredLocations = locations; // Initially, display all locations
      });
      return locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
      ),
      body: FutureBuilder<List<Location>>(
        future: futureLocations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No locations available.'));
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
                          height: 150,
                          fit: BoxFit.cover,
                        )
                            : Icon(Icons.location_on),
                        title: Text(location.name ?? 'Unnamed Location'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        ),




                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to AllHotelViewPage with the selected location
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UpdateLocationPage(location: location ,)),
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
                            'Update Locaton',
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
    );
  }
}
