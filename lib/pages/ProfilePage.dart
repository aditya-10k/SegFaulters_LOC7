import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:segfaultersloc/pages/HomePage.dart';
import 'package:segfaultersloc/pages/LandingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'guest'; 
      print(userRole);
    });
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.transparent,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Landingpage()),
      );
    } catch (error) {
      print('Error during logout: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while logging out'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBackground(
      overlayColor: Colors.red,
      child: Center(
        child: userRole == null
            ? CircularProgressIndicator()
            : userRole == 'corp'
                ? CorpProfile(logoutCallback: _logout)
                : userRole == 'org'
                    ? OrgProfile(logoutCallback: _logout)
                    : GuestProfile(logoutCallback: _logout),
      ),
    );
  }
}


class Corporation {
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String>? sectors; // Nullable field
  final String? description; // Nullable field
  final double? csrBudget; // Nullable field
  final Location location;

  Corporation({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.sectors, // Nullable field
    this.description, // Nullable field
    this.csrBudget, // Nullable field
    required this.location,
  });

  factory Corporation.fromJson(Map<String, dynamic> json) {
    return Corporation(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      sectors: json['sectors'] != null
          ? List<String>.from(json['sectors'] as List)
          : null, // Handle null values in sectors
      description: json['description'] as String?, // Nullable field
      csrBudget: json['csr_budget'] != null
          ? json['csr_budget'] as double
          : null, // Handle null value for csrBudget
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates: List<double>.from(json['coordinates'] as List),
    );
  }
}

class CorpProfile extends StatefulWidget {
  final VoidCallback logoutCallback;

  const CorpProfile({super.key, required this.logoutCallback});

  @override
  _CorpProfileState createState() => _CorpProfileState();
}

class _CorpProfileState extends State<CorpProfile> {
  Corporation? corporationData;

  // Function to fetch the corporation data
  Future<void> fetchCorporationData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('uid');
      print('$token ss');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse("http://localhost:5000/api/data/getCorporate/$token"),
        // headers: {
        //   "Authorization": "Bearer $token",
        // },
      );

      if (response.statusCode == 200) {
        setState(() {
          corporationData = Corporation.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load corporation data');
      }
    } catch (e) {
      print('Error fetching corporation data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCorporationData(); // Fetch data once on initialization
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width *0.6,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(255, 216, 135, 238), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 244, 96, 42).withOpacity(0.2),
                blurRadius: 10,
              )
            ]
          ),
          child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Profile",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'PixelyB', // Set the font family to PixelyB
      ),
    ),
    SizedBox(height: 20),
    // Display loading or error states
    corporationData == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Name: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Phone: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.phone,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Address: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.address,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Sectors: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.sectors!.join(', '),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Description: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    corporationData!.description ?? "N/A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'CSR Budget: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                  Spacer(),
                  Text(
                    '₹${corporationData!.csrBudget ?? "0.00"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Increase font size
                      fontFamily: 'PixelyB', // Set the font family to PixelyB
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.logoutCallback,
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: 'PixelyR'
                  )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class Ngo {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> sectors;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location location;

  Ngo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.sectors,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  factory Ngo.fromJson(Map<String, dynamic> json) {
    return Ngo(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      sectors: List<String>.from(json['sectors'] as List),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'sectors': sectors,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}



class OrgProfile extends StatefulWidget {
  final VoidCallback logoutCallback;

  const OrgProfile({super.key, required this.logoutCallback});

  @override
  _OrgProfileState createState() => _OrgProfileState();
}

class _OrgProfileState extends State<OrgProfile> {
  Ngo? ngoData;

  @override
  void initState() {
    super.initState();
    _fetchNgoData();
  }

  // Function to fetch the NGO data
  Future<void> _fetchNgoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('uid');

      if (token == null) return;

      final response = await http.get(
        Uri.parse("http://localhost:5000/api/data/getNgo/$token"),
        // headers: {
        //   "Authorization": "Bearer $token",
        // },
      );

      if (response.statusCode == 200) {
        setState(() {
          ngoData = Ngo.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load NGO data');
      }
    } catch (e) {
      print('Error fetching NGO data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(255, 216, 135, 238), width: 4),
            boxShadow:[
              BoxShadow(
                color: const Color.fromARGB(255, 244, 96, 42).withOpacity(0.2),
                blurRadius: 10,
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NGO Profile",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'PixelyB',
                ),
              ),
              SizedBox(height: 20),

              // Check if data is loaded
              if (ngoData == null)
                Center(child: CircularProgressIndicator())
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name:', ngoData!.name),
                    _buildInfoRow('Email:', ngoData!.email),
                    _buildInfoRow('Phone:', ngoData!.phone),
                    _buildInfoRow('Address:', ngoData!.address),
                    _buildInfoRow('Sectors:', ngoData!.sectors.join(', ')),
                    _buildInfoRow('Description:', ngoData!.description ?? "N/A"),
                    _buildInfoRow(
                      'Location:',
                      '${ngoData!.location.type} (${ngoData!.location.coordinates.join(', ')})',
                    ),
                  ],
                ),
              SizedBox(height: 20),

              // Logout Button
              ElevatedButton(
                onPressed: widget.logoutCallback,
                child: Text(
                  "Logout",
                  style: TextStyle(fontFamily: 'PixelyR')
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build rows for displaying NGO info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'PixelyB',
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'PixelyB',
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class GuestProfile extends StatelessWidget {
  final VoidCallback logoutCallback;

  const GuestProfile({super.key, required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Welcome, Guest",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: logoutCallback,
          child: Text("Logout"),
        ),
      ],
    );
  }
}
