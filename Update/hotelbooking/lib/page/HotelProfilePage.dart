



import 'package:flutter/material.dart';

class HotelProfilePage extends StatelessWidget {
  final String hotelName;
  final String hotelImageUrl;
  final String address;
  final String rating;
  final int minPrice;
  final int maxPrice;

  HotelProfilePage({
    required this.hotelName,
    required this.hotelImageUrl,
    required this.address,
    required this.rating,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hotelName Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hotel Image
            Image.network(
             'https://images.pexels.com/photos/24805042/pexels-photo-24805042/free-photo-of-view-of-the-mountains-at-sunset-from-the-terrace-with-a-swimming-pool.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Hotel Details
            Text(
              hotelName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Rating: $rating ⭐',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Price Range: \$${minPrice.toString()} - \$${maxPrice.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // View Rooms Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to rooms list or call an API to fetch rooms for this hotel
                print('View Rooms clicked');
              },
              icon: Icon(Icons.room_service),
              label: Text('View Rooms'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            // Manage Bookings Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to bookings management page
                print('Manage Bookings clicked');
              },
              icon: Icon(Icons.book_online),
              label: Text('Manage Bookings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            // Edit Hotel Profile Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to edit hotel profile page
                print('Edit Profile clicked');
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
