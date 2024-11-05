import 'package:flutter/material.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/model/lcation.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';



class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String _selectedRating = '3';

  List<Location> _locations = [];
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  // Load locations for the dropdown
  Future<void> _loadLocations() async {
    try {
      final locations = await HotelService().fetchAllLocations();
      setState(() {
        _locations = locations;
        if (locations.isNotEmpty) _selectedLocation = locations[0]; // Set default
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  // Pick an image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageData = bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  // Save the hotel details
  Future<void> _saveHotel() async {
    if (_formKey.currentState!.validate() && _imageFile != null && _selectedLocation != null) {
      if (double.parse(_minPriceController.text) > double.parse(_maxPriceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum price must be greater than minimum price.')),
        );
        return;
      }

      final hotel = Hotel(
        id: 0,
        name: _nameController.text,
        address: _addressController.text,
        rating: _selectedRating,
        minPrice: double.parse(_minPriceController.text),
        maxPrice: double.parse(_maxPriceController.text),
        image: '',
        location: _selectedLocation!,
      );

      try {
        await HotelService().createHotel(hotel, _imageFile!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hotel added successfully!')),
        );

        _nameController.clear();
        _addressController.clear();
        _minPriceController.clear();
        _maxPriceController.clear();
        _imageFile = null;
        _imageData = null;
        setState(() {});
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding hotel: ${e.toString()}')),
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
                validator: (value) => value == null || value.isEmpty ? 'Enter hotel name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value == null || value.isEmpty ? 'Enter address' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRating,
                items: ['1', '2', '3', '4', '5']
                    .map((rating) => DropdownMenuItem(
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
                validator: (value) => value == null || value.isEmpty ? 'Enter minimum price' : null,
              ),
              TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Maximum Price'),
                validator: (value) => value == null || value.isEmpty ? 'Enter maximum price' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Location>(
                value: _selectedLocation,
                items: _locations.map((location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Text(location.name ?? 'Unknown Location'),
                  );
                }).toList(),
                onChanged: (location) => setState(() => _selectedLocation = location),
                decoration: InputDecoration(labelText: 'Location'),
              ),

              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
                onPressed: _pickImage,
              ),
              if (_imageData != null) Image.memory(_imageData!, height: 150, fit: BoxFit.cover),
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