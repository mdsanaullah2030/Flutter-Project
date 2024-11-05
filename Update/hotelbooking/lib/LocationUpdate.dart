import 'package:flutter/material.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:hotelbooking/service/location_service.dart';


class LocationUpdate extends StatefulWidget {
  final Location location; // Pass the location to be updated

  LocationUpdate({required this.location});

  @override
  _LocationUpdateState createState() => _LocationUpdateState();
}

class _LocationUpdateState extends State<LocationUpdate> {
  final _formKey = GlobalKey<FormState>();
  final LocationService _locationService = LocationService();

  // Controllers to manage text input fields
  late TextEditingController _nameController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing location data
    _nameController = TextEditingController(text: widget.location.name);
    _imageController = TextEditingController(text: widget.location.image);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _updateLocation() async {
    if (_formKey.currentState!.validate()) {
      // Create an updated Location object
      Location updatedLocation = Location(
        id: widget.location.id,
        name: _nameController.text,
        image: _imageController.text,
      );

      try {
        await _locationService.updateLocation(updatedLocation);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location updated successfully')),
        );
        Navigator.pop(context); // Go back after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update location')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateLocation,
                child: Text('Update Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
