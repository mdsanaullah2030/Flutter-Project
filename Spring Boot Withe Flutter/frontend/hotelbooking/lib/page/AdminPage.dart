import 'package:flutter/material.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/location/AddLocation.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/page/loginpage.dart';
import 'package:hotelbooking/room/addRoom.dart';

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
            // Admin photo section
            Center(
              child: CircleAvatar(
                radius: 50, // Size of the avatar
                backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/158471899?v=4', // Replace with the actual URL
                ),
                backgroundColor: Colors.grey[300], // Fallback color if image is not available
              ),
            ),
            SizedBox(height: 20),
            // Welcome text
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
              label: Text(
                'View Users',
                style: TextStyle(color: Colors.white),
              ),
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
              label: Text(
                'Manage Hotels',
                style: TextStyle(color: Colors.white),
              ),
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
              label: Text(
                'Location View',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Navigate to LocationView
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LocationView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.add), // Set icon color to white
              label: Text(
                'Add Hotel',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onPressed: () {
                // Navigate to AddHotelPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddHotelPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Background color of the button
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.location_city),
              label: Text(
                'Add Location',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Navigate to AddLocationPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddLocationPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.location_city),
              label: Text(
                'Add Room',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Navigate to AddRoomPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddRoomPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Implement logout functionality or navigate back to login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.white)),
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
