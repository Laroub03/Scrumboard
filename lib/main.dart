import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JWT Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = '';

  Future<void> authenticate() async {
    // Set up HttpClient to accept self-signed certificates
    http.Client client = http.Client();
    client.badCertificateCallback = (cert, host, port) => true;

    try {
      final response = await client.post(
        Uri.parse('https://10.0.2.2:7121/authenticate'),
        // Add necessary headers or body data if needed
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['Token'] as String;
        // Store the token securely, e.g., using SharedPreferences or other storage methods

        setState(() {
          message = 'Authentication successful';
        });
      } else {
        setState(() {
          message = 'Authentication failed';
        });
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter JWT Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: authenticate,
              child: Text('Authenticate'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
