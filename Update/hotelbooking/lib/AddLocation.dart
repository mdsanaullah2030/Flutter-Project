import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotelbooking/service/location_service.dart';

class AddLocationPage extends StatefulWidget {
  @override
  _AddLocationPageState createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final LocationService _locationService = LocationService();

  String? _locationName;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _saveLocation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a Location object with name and image URL (if provided)
      Location newLocation = Location(
        name: _locationName,
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
      );

      try {
        // Pass the newLocation and uploaded image file (if any) to the service
        final createdLocation = await _locationService.createHotel(newLocation, _image);
        if (createdLocation != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location added successfully!")),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add location: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Location Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location name';
                  }
                  return null;
                },
                onSaved: (value) => _locationName = value,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Upload Image'),
                  ),
                  SizedBox(width: 10),
                  _image != null
                      ? Image.file(
                    File(_image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL (optional)'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _imageUrlController.text = value;
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLocation,
                child: Text('Save Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
