import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/location/addshow.dart';
import 'package:hotelbooking/model/Location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();

  // Image selection variables
  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  // Controller for the hotel name field
  final TextEditingController _nameController = TextEditingController();

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

  Future<void> _saveLocation() async {
    if (_formKey.currentState!.validate() && (selectedImage != null || webImage != null)) {
      final hotel = {
        'name': _nameController.text,
      };

      var uri = Uri.parse('http://localhost:8080/api/location/save');
      var request = http.MultipartRequest('POST', uri);

      final location = Location(id: 0, name: _nameController.text, image: ''); // Replace with your actual image path if needed

      request.files.add(
        http.MultipartFile.fromString(
          'location',
          jsonEncode(location.toJson()),
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
            SnackBar(content: Text('Location added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add Location. Status code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while adding Location.')),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blue, Colors.greenAccent], // Define gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text('Add New Location'),
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            elevation: 0, // Optional: Remove shadow
          ),
        ),
      ),

      body: Container( // Use Container to apply the decoration
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightGreen[50]!, // First color
              Colors.blue[50]!,
              Colors.indigo[50]!,
              Colors.red[50]!, // Second color
            ],
            begin: Alignment.topLeft, // Start of the gradient
            end: Alignment.bottomRight, // End of the gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Location Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Location Name'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter location name' : null,
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
                // Save Button
                ElevatedButton(
                  onPressed: _saveLocation,
                  child: Text('Save Location'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationViewAdd()), // Navigate to LocationViewAdd
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
