import 'package:flutter/material.dart';
import 'package:hotelbooking/model/Lcation.dart';
import 'package:hotelbooking/model/hotel.dart';

import 'package:hotelbooking/service/hotel_service.dart';

class UpdateHotelPage extends StatefulWidget {
  final Hotel hotel;

  UpdateHotelPage({required this.hotel});

  @override
  _UpdateHotelPageState createState() => _UpdateHotelPageState();
}

class _UpdateHotelPageState extends State<UpdateHotelPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String _rating = '3';
  String? _selectedLocation;
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _fetchLocations();
  }

  void _loadInitialData() {
    _nameController.text = widget.hotel.name ?? '';
    _addressController.text = widget.hotel.address ?? '';
    _minPriceController.text = widget.hotel.minPrice?.toString() ?? '';
    _maxPriceController.text = widget.hotel.maxPrice?.toString() ?? '';
    _rating = widget.hotel.rating ?? '3';
    _selectedLocation = widget.hotel.location?.id.toString();
  }

  Future<void> _fetchLocations() async {
    try {
      List<Location> locations = await HotelService().getLocations();
      setState(() {
        _locations = locations;
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<void> _updateHotel() async {
    if (_formKey.currentState!.validate()) {
      final updatedHotel = widget.hotel.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        rating: _rating,
        minPrice: double.parse(_minPriceController.text),
        maxPrice: double.parse(_maxPriceController.text),
        location: _locations.firstWhere((loc) => loc.id.toString() == _selectedLocation),
      );

      try {
        await HotelService().updateHotel(updatedHotel);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update hotel: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Hotel')),
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
                value: _rating,
                items: ['1', '2', '3', '4', '5']
                    .map((rating) => DropdownMenuItem(value: rating, child: Text('Rating: $rating')))
                    .toList(),
                onChanged: (value) => setState(() => _rating = value!),
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
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: _locations.map((location) => DropdownMenuItem(
                  value: location.id.toString(),
                  child: Text(location.name),
                )).toList(),
                onChanged: (value) => setState(() => _selectedLocation = value),
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null ? 'Select a location' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateHotel,
                child: Text('Update Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
