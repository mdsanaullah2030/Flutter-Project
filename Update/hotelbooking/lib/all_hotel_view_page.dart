import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotelbooking/AddHotelPage.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:hotelbooking/view_room.dart';

class AllHotelViewPage extends StatefulWidget {
  final Location location;

  AllHotelViewPage({required this.location});

  @override
  State<AllHotelViewPage> createState() => _AllHotelViewPageState();
}

class _AllHotelViewPageState extends State<AllHotelViewPage> {
  late Future<List<Hotel>> futureHotels;
  late Future<Location> futureLocation;

  @override
  void initState() {
    super.initState();
    futureHotels = HotelService().fetchRoomsByHotelId(widget.location.id!);
    futureLocation = HotelService().fetchHotelById(widget.location.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels in ${widget.location.name}'),
      ),
      body: Column(
        children: [
          // Fetch and display location details at the top
          FutureBuilder<Location>(
            future: futureLocation,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Location data not available'));
              } else {
                final location = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (location.image != null && location.image!.isNotEmpty)
                        Image.network(
                          "http://localhost:8080/images/location/${location.image}",
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 8),
                      Text(
                        location.name ?? 'Location Name',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'No description available',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                    ],
                  ),
                );
              }
            },
          ),
          Expanded(
            // Fetch and display hotels in the location
            child: FutureBuilder<List<Hotel>>(
              future: futureHotels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hotels available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final hotel = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: hotel.image != null
                                  ? Image.network(
                                "http://localhost:8080/images/hotel/${hotel.image}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.hotel),
                              title: Text(hotel.name ?? 'Unnamed Hotel'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hotel.address ?? 'No address available'),
                                  Text('Rating: ${hotel.rating ?? 'N/A'}'),
                                ],
                              ),
                              trailing: Text(
                                  '${hotel.minPrice ?? 'N/A'} - ${hotel.maxPrice ?? 'N/A'}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RatingBar.builder(
                                initialRating: double.tryParse(hotel.rating ?? '0') ?? 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15.0,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    hotel.rating = rating.toString();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: hotel.isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hotel.isFavorite = !hotel.isFavorite;
                                      });
                                    },
                                  ),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddHotelPage(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // Keeps the button compact
                                      children: const [
                                        Icon(Icons.add_home_work), // Replace with your preferred icon
                                        SizedBox(width: 8), // Space between icon and text
                                        Text('Add Hotel'),
                                      ],
                                    ),
                                  ),




                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoomDetailsPage(hotel: hotel),
                                        ),
                                      );
                                    },
                                    child: const Text('View Room'),
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
      ),
    );
  }
}
