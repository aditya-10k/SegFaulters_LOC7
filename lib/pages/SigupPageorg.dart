import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:segfaultersloc/pages/HomePage.dart';
import 'package:segfaultersloc/pages/LoginPageOrg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signuporg extends StatefulWidget {
  const Signuporg({Key? key}) : super(key: key);

  @override
  _SignuporgState createState() => _SignuporgState();
}

class _SignuporgState extends State<Signuporg> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _sectorOptions = [
    "Educational",
    "Healthcare",
    "Environment",
    "Skill Development",
    "Community Development",
    "Diversity",
    "Disaster Relief",
    "Animal Welfare"
  ];
  final List<String> _selectedSectors = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _registerNgo() async {
    final url = Uri.parse('http://localhost:5000/api/auth/registerNgo');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'sectors': _selectedSectors,
          'description': '',
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Signup successful! Logging in...'),
              backgroundColor: Colors.green),
        );
        final responseData = json.decode(response.body);
        print('Login successful: ${responseData}');

        final String jwtToken = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', jwtToken);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      } else {
        final errorResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Signup failed: ${errorResponse['message']}'),
              backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red),
      );
    }
  }

  void _signup() {
    if (_formKey.currentState!.validate() && _selectedSectors.isNotEmpty) {
      _registerNgo();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select at least one sector.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/landingpage.png', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 4))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sign Up as NGO',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontFamily: 'PixelyB')),
                    const SizedBox(height: 20),
                    _buildTextField('Name', _nameController),
                    _buildTextField('Email', _emailController,
                        keyboardType: TextInputType.emailAddress),
                    _buildTextField('Password', _passwordController,
                        obscureText: true),
                    _buildTextField('Address', _addressController),
                    _buildTextField('Phone', _phoneController,
                        keyboardType: TextInputType.phone),
                    _buildSectorDropdown(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.3)),
                      ),
                      onPressed: _signup,
                      child: const Text('Sign Up',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()));
                      },
                      child: Text('Already registered? Log in',
                          style: TextStyle(
                              fontFamily: 'intersB',
                              color: const Color.fromARGB(255, 12, 64, 154),
                              fontWeight: FontWeight.w500)),
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

  Widget _buildSectorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Sectors",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sectorOptions.map((sector) {
            bool isSelected = _selectedSectors.contains(sector);
            return ChoiceChip(
              label: Text(sector,
                  style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSectors.add(sector);
                  } else {
                    _selectedSectors.remove(sector);
                  }
                });
              },
              selectedColor: Colors.white,
              backgroundColor: Colors.grey.withOpacity(0.5),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontFamily: 'PixelyR'),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label, labelStyle: TextStyle(color: Colors.white)),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }
}
