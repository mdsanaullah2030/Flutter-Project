import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:date_field/date_field.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;
  String? selectedGender;
  DateTime? selecteDOB;
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uCell = cell.text;
      String uAddress = address.text;
      String uGender = selectedGender ?? 'Other';
      String uDob = selecteDOB != null ? selecteDOB!.toIso8601String() : '';

      // Send data to the server
      final response = await _sendDataToBackend(uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration successful!');
      } else if (response.statusCode == 409) {
        print('User already exists!');
      } else {
        print('Registration failed with status: ${response.statusCode}');
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name, String email, String password, String cell, String address, String gender, String dob) async {
    const String url = 'http://localhost:8080/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffB81736),
              Color(0xff2B1836),
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: name,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87), // Set icon color to white
                  ),
                ),

                SizedBox(height: 20),
                TextField(
                  controller: email,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.black87), // Set icon color to white
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: password,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: Colors.black87), // Set icon color to white
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPassword,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: Colors.black87), // Set icon color to white
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: cell,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Cell',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.phone, color: Colors.black87), // Set icon color to white
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: address,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.white60), // Set label text color to white
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87), // Set border color to white
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo), // Set focused border color to white
                    ),
                    prefixIcon: Icon(Icons.maps_home_work_rounded, color: Colors.black87), // Set icon color to white
                  ),
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dob,
                  onChanged: (DateTime? value) {
                    selecteDOB = value;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Gender:',
                      style: TextStyle(color: Colors.white), // Set color for "Gender:" label
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          Text(
                            'Male',
                            style: TextStyle(color: Colors.white), // Set color for "Male"
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          Text(
                            'Female',
                            style: TextStyle(color: Colors.white), // Set color for "Female"
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Other',
                            groupValue: selectedGender,
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          Text(
                            'Other',
                            style: TextStyle(color: Colors.white), // Set color for "Other"
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.amber,
                      decoration: TextDecoration.underline,
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
