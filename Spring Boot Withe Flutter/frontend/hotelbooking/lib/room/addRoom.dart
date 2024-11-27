import 'dart:convert';
import 'dart:io';
import 'package:hotelbooking/hotel/AllHotelViewPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/model/hotel.dart';
import 'package:hotelbooking/room/view_room.dart';
import 'package:hotelbooking/service/hotel_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({super.key});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  String? _selectedHotel;
  List<Hotel> _hotels = [];

  // Controllers for form fields
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _adultNoController = TextEditingController();
  final TextEditingController _childNoController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  Future<void> _loadHotels() async {
    try {
      List<Hotel> hotels = await HotelService().getAllHotel();
      setState(() {
        _hotels = hotels;
        if (_hotels.isNotEmpty) {
          _selectedHotel = _hotels[0].id.toString();
        }
      });
    } catch (e) {
      print('Error loading hotels: $e');
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  Future<void> _saveRoom() async {
    if (_formKey.currentState!.validate() && (selectedImage != null || webImage != null)) {
      final room = {
        'roomType': _roomTypeController.text,
        'area': _areaController.text,
        'adultNo': _adultNoController.text,
        'childNo': _childNoController.text,
        'price': _priceController.text,
        'availability': _availabilityController.text,
        'hotel': {'id': _selectedHotel},
      };

      var uri = Uri.parse('http://localhost:8080/api/room/save');
      var request = http.MultipartRequest('POST', uri);

      // Add room data as JSON
      request.files.add(
        http.MultipartFile.fromString(
          'room',
          jsonEncode(room),
          contentType: MediaType('application', 'json'),
        ),
      );

      // Add image file
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
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Room added successfully!')),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RoomDetailsPage(hotel: null,),
          //   ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add room. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error occurred while submitting: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while adding room.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload an image.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color of the Scaffold
      backgroundColor: Colors.lightBlue[50],  // Change this to the color you prefer

      // AppBar with an icon
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text('Add New Room'),
            backgroundColor: Colors.transparent, // Transparent background to show gradient
            elevation: 0, // Remove shadow
          ),
        ),
      ),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _roomTypeController,
                  decoration: InputDecoration(
                    labelText: 'Room Type',
                    prefixIcon: Icon(Icons.bed),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter room type' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Icons.attach_money),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter price' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    labelText: 'Area',
                    prefixIcon: Icon(Icons.square_foot),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter area' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _adultNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Adults',
                    prefixIcon: Icon(Icons.people),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter number of adults' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _childNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Children',
                    prefixIcon: Icon(Icons.child_care),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter number of children' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _availabilityController,
                  decoration: InputDecoration(
                    labelText: 'Availability',
                    prefixIcon: Icon(Icons.event_available),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Enter availability' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedHotel,
                  items: _hotels.map((hotel) {
                    return DropdownMenuItem<String>(
                      value: hotel.id.toString(),
                      child: Text(hotel.name ?? 'Unnamed Hotel'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedHotel = value),
                  decoration: InputDecoration(
                    labelText: 'Hotel',
                    prefixIcon: Icon(Icons.hotel),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null ? 'Select a hotel' : null,
                ),
                SizedBox(height: 16),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Upload Image'),
                  onPressed: pickImage,
                ),
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
                ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  onPressed: _saveRoom,
                  label: Text('Save Room'),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
