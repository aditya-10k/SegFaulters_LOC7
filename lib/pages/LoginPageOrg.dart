import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:segfaultersloc/pages/HomePage.dart';
import 'package:segfaultersloc/pages/SigupPageorg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

    Future<void> _loginApi(String email, String password) async {
    final url = Uri.parse('http://localhost:5000/api/auth/loginNgo');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Login successful: ${responseData}');

        final String jwtToken = responseData['token'];
        final String userId = responseData['user']['id'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', jwtToken);
        await prefs.setString('uid', userId);
        await prefs.setString('role', 'org');
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homepage()));
        
      } else {
        final errorResponse = json.decode(response.body);
        print('Login failed: ${errorResponse['message']}');
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${errorResponse['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
      
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      _loginApi(email, password);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/landingpage.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login as NGO',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: 'PixelyB',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white, fontFamily: 'PixelyB'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white), // White label text
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white, // White prefix icon
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white, fontFamily: 'PixelyB'),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white), // White label text
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // White border
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white, // White prefix icon
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Signuporg()));
                          },
                          child: Text(
                            'New? Sign In',
                            style: TextStyle(
                              fontFamily: 'intersB',
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
                          ),
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
