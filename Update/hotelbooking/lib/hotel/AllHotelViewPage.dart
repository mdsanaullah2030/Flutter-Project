import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/hotel/UpdateHotelPage.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/Location.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:hotelbooking/room/view_room.dart';

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

  
  
  
  //Location data show//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hotels in ${widget.location.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent, Colors.red,Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                return Center(child: Text('Welcome to Our Hotels'));
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   // 'No description available',
                      //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      // ),
                      SizedBox(height: 8),
                      Divider(),
                    ],
                  ),
                );
              }
            },
          ),
          
          
          
          
          //Hotel data list//
          
          
          Expanded(
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
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Displaying the hotel image
                            hotel.image != null
                                ? Image.network(
                                    "http://localhost:8080/images/hotel/${hotel.image}",
                                    height: 200, // Adjusted image height
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.hotel, size: 100),
                            // Default icon if no image
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  hotel.name ?? 'Unnamed Hotel',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotel.address ??
                                        'No address available'),
                                    Text('Rating: ${hotel.rating ?? 'N/A'}'),
                                  ],
                                ),
                                trailing: Text(
                                  '${hotel.minPrice ?? 'N/A'} - ${hotel.maxPrice ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),



                          //RatingBar//

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RatingBar.builder(
                                initialRating:
                                    double.tryParse(hotel.rating ?? '0') ?? 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20.0,
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




                            // Favorite button
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Favorite button
                                  IconButton(
                                    icon: Icon(
                                      hotel.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: hotel.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hotel.isFavorite = !hotel.isFavorite;
                                      });
                                    },
                                  ),




                                  // Add Hotel button
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddHotelPage(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return Colors.lightBlueAccent.shade700; // Hover color
                                        }
                                        return Colors.amber; // Default color
                                      }),
                                      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.blueGrey.shade900.withOpacity(0.2); // Ripple effect color
                                        }
                                        return null; // Default ripple effect
                                      }),
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12), // Rounded corners
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.add_home_work, color: Colors.white), // Icon color
                                        const SizedBox(width: 8),
                                        Text(
                                          'Add Hotel',
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),





                                  // View Room button
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoomDetailsPage(hotel: hotel),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return Colors.lightBlueAccent.shade700; // Hover color
                                        }
                                        return Colors.amber; // Default color
                                      }),
                                      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.deepPurple.shade900.withOpacity(0.2); // Ripple effect color
                                        }
                                        return null; // Default ripple effect
                                      }),
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12), // Rounded corners
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Room',
                                      style: TextStyle(
                                        color: Colors.white, // Set text color to white
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
      ),
    );
  }
}
