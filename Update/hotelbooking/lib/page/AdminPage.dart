import 'package:flutter/material.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/location/AddLocation.dart';
import 'package:hotelbooking/location/UpdateLocation.dart';
import 'package:hotelbooking/location/location_view.dart';

import 'package:hotelbooking/page/loginpage.dart';


class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        automaticallyImplyLeading: false, // Hides the back button
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.people),
              label: Text('View Users'),
              onPressed: () {
                // Navigate to users page or call an API to fetch users
                print("View Users clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.hotel),
              label: Text('Manage Hotels'),
              onPressed: () {
                // Navigate to manage hotels page or call an API to manage hotels
                print("Manage Hotels clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),


            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Update Locatn'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>LocationView()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),






            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Hotel'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>AddHotelPage()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),






            ElevatedButton.icon(
              icon: Icon(Icons.location_city),
              label: Text('Add Hotel'),
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>AddLocationPage()),
                ); // Example logout: navigate back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),


            ElevatedButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () {
                // Navigate to settings page
                print("Settings clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Example logout: navigate back to login
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}