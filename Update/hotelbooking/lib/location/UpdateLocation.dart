import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/Location.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

class UpdateLocationPage extends StatefulWidget {
  final Location? location; // Optional location to edit

  const UpdateLocationPage({super.key, this.location});

  @override
  State<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  final _formKey = GlobalKey<FormState>();

  // Image selection variables
  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  // Controller for the location name field
  final TextEditingController _nameController = TextEditingController();
  bool get isEditMode => widget.location != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.location!.name;
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage; // For Web
        });
      }
    } else {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage; // For Mobile
        });
      }
    }
  }

  Future<void> _saveOrUpdateLocation() async {
    if (_formKey.currentState!.validate()) {
      var uri = isEditMode
          ? Uri.parse('http://localhost:8080/api/location/update/${widget.location!.id}')
          : Uri.parse('http://localhost:8080/api/location/save');

      var request = http.MultipartRequest(isEditMode ? 'PUT' : 'POST', uri);

      final location = Location(
        id: widget.location?.id ?? 0,
        name: _nameController.text,
        image: '',
      );

      request.files.add(
        http.MultipartFile.fromString(
          'location',
          jsonEncode(location.toJson()),
          contentType: MediaType('application', 'json'),
        ),
      );

      // Add the image file if available
      if (kIsWeb && webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage!,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditMode ? 'Location updated successfully!' : 'Location added successfully!')),
          );
          Navigator.pop(context, true); // Optionally close the page and return success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to ${isEditMode ? "update" : "add"} location. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while ${isEditMode ? "updating" : "adding"} location.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Location' : 'Add New Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Location Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Location Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter location name' : null,
              ),
              SizedBox(height: 16),
              // Image Upload Button
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: pickImage,
              ),
              // Display Selected Image Preview
              if (kIsWeb && webImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.memory(
                    webImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                )
              else if (!kIsWeb && selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(selectedImage!.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              // Save or Update Button
              ElevatedButton(
                onPressed: _saveOrUpdateLocation,
                child: Text(isEditMode ? 'Update Location' : 'Save Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
