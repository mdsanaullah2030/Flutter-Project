
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotelbooking/page/AdminPage.dart';
import 'package:hotelbooking/page/HotelProfilePage.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/page/registrationpage.dart';
import 'package:hotelbooking/service/AuthService.dart';



class LoginPage extends StatelessWidget {

  final TextEditingController email = TextEditingController();
  // ..text = 'Kutub@gmail.com';
  final TextEditingController password = TextEditingController() ;
  // ..text = '123456';
  final storage = new FlutterSecureStorage();
  AuthService authService=AuthService();



  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);

      // Successful login, role-based navigation
      final  role =await authService.getUserRole(); // Get role from AuthService


      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'HOTEL') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelProfilePage(
              hotelName: 'Grand Plaza',               // Example hotel name
              hotelImageUrl:'http://localhost:8080/images/hotel/Hotel Sarina Dhaka_7bcf8c73-6309-478d-8395-3f0e91b10ec8',  // Example image URL
              address: '123 Main St, Cityville',      // Example address
              rating: '4.5',                          // Example rating
              minPrice: 100,                          // Example minimum price
              maxPrice: 300,                          // Example maximum price
            ),
          ),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationView()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hotelb.jpg'), // Local asset image
            // For a network image, use: NetworkImage('https://example.com/image.jpg')
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white, // Icon color set to white
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent), // Outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Border color when focused
                ),
              ),
            ),

            SizedBox(height: 20),
            TextField(
              controller: password,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Label text color
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: Colors.white, // Icon color set to white
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent), // Outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Border color when focused
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginUser(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.amber,
              // elevation: 1.0, // Adds shadow to give a card effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
              ),
              child: Padding(
                padding: EdgeInsets.all(1.0), // Adds space inside the card
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text(
                    'Registration',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}