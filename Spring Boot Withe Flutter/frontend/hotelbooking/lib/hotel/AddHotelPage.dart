import 'dart:convert';
import 'dart:io';
import 'package:hotelbooking/hotel/AllHotelViewPage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/hotel/AllHotelViewPage.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/Location.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:hotelbooking/service/location_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';



class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {

  final _formKey = GlobalKey<FormState>();

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedLocation;
  List<Location> _locations = [];

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String _selectedRating = '3'; // default rating


  Future<void> _loadLocations() async {
    try {

      List<Location> locations = await LocationService().getAllLocations();

      setState(() {
        _locations = locations;
        _selectedLocation = _locations[0].id.toString();
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage; // Store the picked image as Uint8List
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> _saveHotel() async {
    if (_formKey.currentState!.validate() && selectedImage != null || webImage!=null) {
      // Check if minPrice is not greater than maxPrice
      if (double.parse(_minPriceController.text) > double.parse(_maxPriceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum price must be greater than minimum price.')),
        );
        return;
      }

      // Prepare the hotel JSON data
      final hotel = {
        'name': _nameController.text,
        'address': _addressController.text,
        'rating': _selectedRating,
        'minPrice': _minPriceController.text,
        'maxPrice': _maxPriceController.text,
        'location': {'id': _selectedLocation},
      };

      var uri = Uri.parse('http://localhost:8080/api/hotel/save');
      var request = http.MultipartRequest('POST', uri);

      // Add hotel data as JSON
      request.files.add(
        http.MultipartFile.fromString(
          'hotel',
          jsonEncode(hotel),
          contentType: MediaType('application', 'json'),
        ),
      );

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
            SnackBar(content: Text('Hotel added successfully!')),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AllHotelViewPage(location:),
          //   ),
          // );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add hotel. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error occurred while submitting: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while adding hotel.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _addressController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();

    setState(() {
      selectedImage = null;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadLocations();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Add New Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Hotel Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter hotel name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter address' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRating,
                items: ['1', '2', '3', '4', '5']
                    .map((rating) =>
                    DropdownMenuItem(
                      value: rating,
                      child: Text('Rating: $rating'),
                    ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRating = value!),
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextFormField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Minimum Price'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Enter minimum price'
                    : null,
              ),
              TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Maximum Price'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Enter maximum price'
                    : null,
              ),
              SizedBox(height: 16),


              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: _locations
                    .map((location) => DropdownMenuItem<String>(
                  value: location.id.toString(),  // Convert int id to String
                  child: Text(location.name),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedLocation = value),
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null ? 'Select a location' : null,
              ),

              SizedBox(height: 16),




              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: pickImage,
              ),
              // Display selected image preview
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
              else
                if (!kIsWeb && selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(selectedImage!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),

                  ),
              // Display image
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveHotel,
                child: Text('Save Hotel'),
              ),
            ],
          ),
        ),
      ),
    );


  }
}