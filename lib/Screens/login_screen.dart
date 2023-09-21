import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task1_rosenfield_health/Screens/servers_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome back!"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _loginMessage = '';

  // Function to perform login
  void _performLogin(String username, password) async {
    try {
      // Send a POST request to the authentication API
      Response response = await post(
        Uri.parse('https://icodesuite.com/icodecrnapi/v1/api/Authentication/login'),
        headers: {
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check the login status from the response data
        if (responseData['status'] != -1) {
          setState(() {
            _loginMessage = 'Login successfully!';
          });

          // Extract and store the token
          String token = responseData['resource']['token']; // Extract the token from the 'resource' object
          print('Token: $token');

          // Store the token in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);


          // Navigate to the home page on successful login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ServersScreen()),
          );
        } else {
          setState(() {
            _loginMessage = 'Login failed!';
          });
        }
      } else {
        //print('Login failed with status code: ${response.statusCode}');
        setState(() {
          _loginMessage = 'Login failed!';
        });
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Email/Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email/username';
                }
                // Use a regular expression to check for spaces
                if (value!.contains(' ')) {
                  return 'Username cannot contain spaces';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _performLogin(_usernameController.text.toString(),
                      _passwordController.text.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _loginMessage,
              style: TextStyle(
                color: _loginMessage == 'Login successfully!'
                    ? Colors.green
                    : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
