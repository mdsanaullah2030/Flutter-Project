import 'package:flutter/material.dart';

import 'package:hotelbooking/AdminPage.dart';
import 'package:hotelbooking/HotelProfilePage.dart';
import 'package:hotelbooking/all_hotel_view_page.dart';
import 'package:hotelbooking/registrationpage.dart';
import 'package:hotelbooking/service/AuthService.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class LoginPage extends StatelessWidget {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
              hotelImageUrl: 'http://localhost:8080/images/hotel/Hotel Sarina Dhaka_7bcf8c73-6309-478d-8395-3f0e91b10ec8',  // Example image URL
              address: '123 Main St, Cityville',      // Example address
              rating: '4.5',                          // Example rating
              minPrice: 100,                          // Example minimum price
              maxPrice: 300,                          // Example maximum price
            ),
          ),
        );
      } else if (role == 'USER') {
        // Navigator.pushReplacement(
        //   context,
        //   // MaterialPageRoute(builder: (context) => AllHotelViewPage(location: loginpage)),
        // );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }


  // Future<void> loginUser(BuildContext context) async {
  //   final url = Uri.parse('http://localhost:8080/login');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email.text, 'password': password.text}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final token = responseData['token'];
  //
  //     // Decode JWT to get 'sub' and 'role'
  //     Map<String, dynamic> payload = Jwt.parseJwt(token);
  //     String sub = payload['sub'];
  //     String role = payload['role'];
  //
  //     // Store token, sub, and role securely
  //     await storage.write(key: 'token', value: token);
  //     await storage.write(key: 'sub', value: sub);
  //     await storage.write(key: 'role', value: role);
  //
  //     print('Login successful. Sub: $sub, Role: $role');
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => AllHotelViewPage()),
  //     );
  //
  //   } else {
  //     print('Login failed with status: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
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
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                )
            ),
            SizedBox(height: 20),

            // Login Text Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}