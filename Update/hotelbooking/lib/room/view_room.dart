import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotelbooking/booking/BookingForm.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/room.dart';
import 'package:hotelbooking/service/room_service.dart';

class RoomDetailsPage extends StatefulWidget {
  final Hotel hotel;

  RoomDetailsPage({required this.hotel});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  late Future<List<Room>> futureRooms;
  late Future<Hotel> futureHotel;

  @override
  void initState() {
    super.initState();
    // Initialize hotel and rooms data
    futureHotel = RoomService().fetchHotelById(widget.hotel.id!);
    futureRooms = RoomService().fetchRoomsByHotelId(widget.hotel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel and Room Details'),
      ),
      body: FutureBuilder<Hotel>(
        future: futureHotel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Hotel data not available'));
          } else {
            final hotel = snapshot.data!;
            return Column(
              children: [
                // Display hotel details
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hotel.image != null && hotel.image!.isNotEmpty)
                        Image.network(
                          "http://localhost:8080/images/hotel/${hotel.image}",
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 8),
                      Text(
                        hotel.name.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        hotel.address.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text("Rating: ${hotel.rating}"),
                      Text("Price Range: \$${hotel.minPrice} - \$${hotel.maxPrice}"),
                      SizedBox(height: 8),
                      Divider(),
                    ],
                  ),
                ),

                // Display list of rooms
                Expanded(
                  child: FutureBuilder<List<Room>>(
                    future: futureRooms,
                    builder: (context, roomSnapshot) {
                      if (roomSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (roomSnapshot.hasError) {
                        return Center(child: Text('Error: ${roomSnapshot.error}'));
                      } else if (!roomSnapshot.hasData || roomSnapshot.data!.isEmpty) {
                        return Center(child: Text('No rooms available'));
                      } else {
                        return ListView.builder(
                          itemCount: roomSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            final room = roomSnapshot.data![index];
                            return Card(
                              margin: const EdgeInsets.symmetric( horizontal: 16),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  room.roomType.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price: \$${room.price?.toStringAsFixed(2) ?? 'N/A'}\n'
                                          'Area: ${room.area ?? 'N/A'} sq. ft.\n'
                                          'Adults: ${room.adultNo ?? 0}, Children: ${room.childNo ?? 0}\n'
                                          'Availability: ${room.availability ? "Available" : "Not available"}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Button to view or book room
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BookingForm(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 24.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Book Room',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Display room image or icon if unavailable
                                trailing: room.image != null
                                    ? Image.network(
                                  "http://localhost:8080/images/room/${room.image}",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                                    : Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
