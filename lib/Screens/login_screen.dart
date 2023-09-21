import 'package:flutter/material.dart';
import 'package:task1_rosenfield_health/Screens/servers_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your background color
      appBar: AppBar(
        title: const Text(
          "Welcome back!",
          style: TextStyle(
            // Customize title text style here
          ),
        ),
        backgroundColor: Colors.blue, // Customize app bar color
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _loginMessage = '';

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
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email/Username',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 16,
                // Customize text style for input fields here
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email/username';
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
              style: const TextStyle(
                fontSize: 16,
                // Customize text style for input fields here
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
                  // Perform login or validation logic here
                  final username = _emailController.text;
                  final password = _passwordController.text;

                  if (username == 'jsmith' && password == '123456') {
                    setState(() {
                      _loginMessage = 'Login successfully!';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ServersScreen()),
                      );
                    });
                  } else if (username != 'jsmith') {
                    setState(() {
                      _loginMessage = 'Invalid username';
                    });
                  } else if (password != '123456') {
                    setState(() {
                      _loginMessage = 'Invalid password';
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                // Customize button style here
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  // Customize text style for the button here
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
