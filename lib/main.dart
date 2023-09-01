import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrumboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class HttpClientService {
  HttpClient? _httpClient;

  Future<void> initializeHttpClient() async {
    if (_httpClient == null) {
      ByteData caData = await rootBundle.load('assets/rootCA.pem');
      ByteData certData = await rootBundle.load('assets/fluttertest+4-client.pem');
      ByteData keyData = await rootBundle.load('assets/fluttertest+4-client-key.pem');
      List<int> caBytes = caData.buffer.asUint8List();
      List<int> certBytes = certData.buffer.asUint8List();
      List<int> keyBytes = keyData.buffer.asUint8List();

      SecurityContext secContext = SecurityContext(withTrustedRoots: true)
        ..setTrustedCertificatesBytes(caBytes)
        ..useCertificateChainBytes(certBytes)
        ..usePrivateKeyBytes(keyBytes);

      _httpClient = HttpClient(context: secContext);
    }
  }

  Future<HttpClient> getHttpClient() async {
    if (_httpClient == null) {
      await initializeHttpClient();
    }
    return _httpClient!;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = '';
  HttpClientService _httpClientService = HttpClientService();

  Future<void> register() async {
    try {
      final httpClient = await _httpClientService.getHttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('https://10.0.2.2:8443/api/Auth/register'),
      );

      final response = await request.close();

      if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      // Process the response as needed
      setState(() {
        message = 'Registration/Login successful';
      });
    } 
    else{
      final responseBody = await response.transform(utf8.decoder).join();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');
      setState(() {
        message = 'Registration/Login failed';
      });
    }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  Future<void> login() async {
    try {
      final httpClient = await _httpClientService.getHttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('https://10.0.2.2:8443/api/Auth/login'),
      );

      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        // Process the response as needed

        setState(() {
          message = 'Login successful';
        });
      } else {
        setState(() {
          message = 'Login failed';
        });
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrumboard'),
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
