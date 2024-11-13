import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/Location.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:hotelbooking/service/location_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';

class UpdateHotelPage extends StatefulWidget {
  final Hotel? hotel;  // Add hotel as an optional parameter for updates

  const UpdateHotelPage({Key? key, this.hotel}) : super(key: key);

  @override
  State<UpdateHotelPage> createState() => _UpdateHotelPageState();
}

class _UpdateHotelPageState extends State<UpdateHotelPage> {
  final _formKey = GlobalKey<FormState>();

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedLocation;
  List<Location> _locations = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String _selectedRating = '3'; // default rating

  Hotel? _hotel;
  @override
  void initState() {
    super.initState();

    // Check if hotel is passed in and not null
    if (widget.hotel != null) {
      _hotel = widget.hotel;

      // Check each field before accessing it
      _nameController.text = _hotel?.name ?? ''; // Default to empty string if null
      _addressController.text = _hotel?.address ?? ''; // Default to empty string if null
      _minPriceController.text = _hotel?.minPrice?.toString() ?? ''; // Default to empty string if null
      _maxPriceController.text = _hotel?.maxPrice?.toString() ?? ''; // Default to empty string if null
      _selectedRating = _hotel?.rating ?? '3'; // Default to '3' if null

      // Make sure location is not null before accessing its properties
      _selectedLocation = _hotel?.location?.id?.toString() ?? ''; // Default to empty string if location is null
    }

    _loadLocations();
  }



  Future<void> _loadLocations() async {
    try {
      List<Location> locations = await LocationService().getAllLocations();
      setState(() {
        _locations = locations;
        if (_hotel != null && _hotel!.location != null) {
          _selectedLocation = _hotel!.location?.id.toString();
        } else if (_locations.isNotEmpty) {
          _selectedLocation = _locations[0].id.toString();
        }
      });
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> _saveHotel() async {
    if (_formKey.currentState!.validate() && (selectedImage != null || webImage != null)) {
      if (double.parse(_minPriceController.text) > double.parse(_maxPriceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maximum price must be greater than minimum price.')));
        return;
      }

      final hotelData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'rating': _selectedRating,
        'minPrice': _minPriceController.text,
        'maxPrice': _maxPriceController.text,
        'location': {'id': _selectedLocation},
      };

      var uri = _hotel == null ? Uri.parse('http://localhost:8080/api/hotel/save') : Uri.parse('http://localhost:8080/api/hotel/update/${_hotel!.id}');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(http.MultipartFile.fromString(
        'hotel',
        jsonEncode(hotelData),
        contentType: MediaType('application', 'json'),
      ));

      if (kIsWeb && webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage!,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', selectedImage!.path));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hotel ${_hotel == null ? 'added' : 'updated'} successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to ${_hotel == null ? 'add' : 'update'} hotel.')));
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred while ${_hotel == null ? 'adding' : 'updating'} hotel.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete the form and upload an image.')));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${_hotel == null ? 'Add' : 'Edit'} Hotel')),
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
                    .map((rating) => DropdownMenuItem(value: rating, child: Text('Rating: $rating')))
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
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                items: _locations
                    .map((location) => DropdownMenuItem(
                  value: location.id.toString(),
                  child: Text(location.name),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedLocation = value!),
                decoration: InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text('Pick Image'),
                  ),
                  if (selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(selectedImage!.name),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveHotel,
                child: Text('${_hotel == null ? 'Add' : 'Update'} Hotel'),
              ),
              if (_hotel != null)
                TextButton(
                  onPressed: _clearForm,
                  child: Text('Clear Form'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
