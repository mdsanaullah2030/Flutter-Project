import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/Lcation.dart';

import 'package:hotelbooking/service/location_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:hotelbooking/service/AuthService.dart';

class UpdateLocationPage extends StatefulWidget {
  final Location location;

  UpdateLocationPage({required this.location});

  @override
  _UpdateLocationPageState createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  XFile? _selectedImage;
  final LocationService _locationService = LocationService();
  final Dio _dio = Dio(); // Initialize Dio instance

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.location.name ?? '';
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> updateLocation(Location location, XFile? image) async {
    final formData = FormData();

    // Add location data as a JSON string part
    formData.fields.add(MapEntry('location', jsonEncode(location.toJson())));

    // Add image file if selected
    if (image != null) {
      final bytes = await image.readAsBytes();
      formData.files.add(MapEntry(
        'image',
        MultipartFile.fromBytes(bytes, filename: image.name),
      ));
    }

    // Instantiate AuthService and get the token
    final authService = AuthService(); // Create an instance of AuthService
    final token = await authService.getToken(); // Use the instance to call getToken()

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.put(
        'your_api_url_here/location/${location.id}', // Replace with your actual API URL
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update location');
      }
    } catch (e) {
      throw Exception('Error updating location: $e');
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Location'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Location Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  _selectedImage == null
                      ? Text('No image selected')
                      : FutureBuilder<Uint8List>(
                    future: _selectedImage!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          height: 100,
                          width: 100,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error loading image');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Select Image'),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Location updatedLocation = widget.location;
                    // updatedLocation.name = _nameController.text;

                    try {
                      await updateLocation(updatedLocation, _selectedImage);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Location updated successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating location: $e')),
                      );
                    }
                  }
                },
                child: Text('Update Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
