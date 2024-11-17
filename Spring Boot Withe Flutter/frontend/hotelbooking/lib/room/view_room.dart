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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple,Colors.indigoAccent,Colors.indigoAccent,Colors.lightBlueAccent,Colors.indigo], // Mix of blue and purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image at the top
                                  room.image != null
                                      ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.network(
                                      "http://localhost:8080/images/room/${room.image}",
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Room details below the image
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room.roomType.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Price: \$${room.price?.toStringAsFixed(2) ?? 'N/A'}\n'
                                              'Area: ${room.area ?? 'N/A'} sq. ft.\n'
                                              'Adults: ${room.adultNo ?? 0}, Children: ${room.childNo ?? 0}\n'
                                              'Availability: ${room.availability ? "Available" : "available"}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BookingForm(room: room),
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
                                          child: const Text(
                                            'Book Room',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
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
            );
          }
        },
      ),
    );
  }
}
