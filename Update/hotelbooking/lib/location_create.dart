
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:hotelbooking/service/location_service.dart';
class LocationCreate extends StatefulWidget {
  const LocationCreate({super.key});

  @override
  State<LocationCreate> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationCreate> {
  late Future<List<Location>> futureLocations;
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureLocations = LocationService().fetchLocation();
  }

  void _addLocation() async {
    if (_nameController.text.isNotEmpty) {
      final newLocation = Location(
        name: _nameController.text,
        image: _imageController.text,
      );

      try {
        await LocationService().createLocation(newLocation);
        setState(() {
          futureLocations = LocationService().fetchLocation(); // Refresh list
        });
        Navigator.of(context).pop(); // Close the dialog
      } catch (e) {
        print("Error creating location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Locations"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add New Location'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Location Name'),
                      ),
                      TextField(
                        controller: _imageController,
                        decoration: InputDecoration(labelText: 'Image URL'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _addLocation,
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Location>>(
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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final location = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: location.image != null
                        ? Image.network(
                      "http://localhost:8080/images/location/${location.image}",
                      width: 50,
                      height: 50,
                    )
                        : Icon(Icons.location_on),
                    title: Text(location.name ?? 'Unnamed Location'),
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