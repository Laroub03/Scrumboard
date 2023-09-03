import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrumboard/http_client_service.dart'; 
import 'package:scrumboard/scrum_board_screen.dart'; 

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  String message = '';
  final HttpClientService _httpClientService = HttpClientService();

  // Function to perform user registration
  Future<void> register() async {
    try {
      final httpClient = await _httpClientService.getHttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('https://10.0.2.2:8443/api/Auth/register'),
      );

      // Set request headers for JSON data
      request.headers.set('Content-Type', 'application/json');

      // Data to be sent for registration
      final registrationData = {
        'username': 'testuser',
        'password': 'testpassword',
      };

      // Encode registration data as JSON and write it to the request
      request.write(jsonEncode(registrationData));

      // Send the request and receive the response
      final response = await request.close();

      if (response.statusCode == 200) {
        // Registration successful
        final responseBody = await response.transform(utf8.decoder).join();

        setState(() {
          message = 'Registration successful';
        });
      } else {
        // Registration failed
        final responseBody = await response.transform(utf8.decoder).join();
        print('Registration Failed - Response Status Code: ${response.statusCode}');
        print('Registration Failed - Response Body: $responseBody');
        setState(() {
          message = 'Registration failed';
        });
      }
    } catch (error) {
      // Handle any errors that occur during registration
      print('Registration Error: $error');
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  // Function to perform user login
  Future<void> login() async {
    try {
      final httpClient = await _httpClientService.getHttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('https://10.0.2.2:8443/api/Auth/login'),
      );

      // Set request headers for JSON data
      request.headers.set('Content-Type', 'application/json');

      // Data to be sent for login
      final loginData = {
        'username': 'testuser',
        'password': 'testpassword',
      };
      
      request.write(jsonEncode(loginData));

      final response = await request.close();

      if (response.statusCode == 200) {
        // Login successful
        final responseBody = await response.transform(utf8.decoder).join();

        setState(() {
          message = 'Login successful';
        });

        // Navigate to the Scrumboard screen upon successful login
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ScrumboardScreen()),
        );
      } else {
        // Login failed
        final responseBody = await response.transform(utf8.decoder).join();
        print('Login Failed - Response Status Code: ${response.statusCode}');
        print('Login Failed - Response Body: $responseBody');
        setState(() {
          message = 'Login failed';
        });
      }
    } catch (error) {
      // Handle any errors that occur during login
      print('Login Error: $error');
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
