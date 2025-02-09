import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:segfaultersloc/AppColors.dart';
import 'package:segfaultersloc/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageBackground(
      overlayColor: Colors.lightBlue,
      child: Center(
        child: userRole == null
            ? CircularProgressIndicator()
            : userRole == 'corp'
                ? CorpHomePage()
                : userRole == 'org'
                    ? OrgHomePage()
                    : GuestHomePage(),
      ),
    );
  }
}

class CorpHomePage extends StatefulWidget {
  @override
  State<CorpHomePage> createState() => _CorpHomePageState();
}

class _CorpHomePageState extends State<CorpHomePage> {
  String _locationMessage = "";
  double? _latitude;
  double? _longitude;
  List<dynamic> _nearbyNGOs = [];
  List<String> _selectedSectors = [];

  // List of available sectors
  List<String> sectors = [
    "Educational",
    "Healthcare",
    "Environment",
    "Skill Development",
    "Community Development",
    "Diversity",
    "Disaster Relief",
    "Animal Welfare"
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _fetchNearbyNGOs(); // Fetch NGOs when the page loads
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  // Fetch NGOs from Firestore
Future<void> _fetchNearbyNGOs() async {
  try {
    // Fetching NGO data from Firestore (assuming 'Ngo' is the collection name)
    var ngoSnapshot = await FirebaseFirestore.instance.collection("Ngo").get();

    setState(() {
      _nearbyNGOs = ngoSnapshot.docs.map((doc) {
        // Checking if the necessary fields exist in the document before accessing them
        return {
          'name': doc.data().containsKey('name') ? doc['name'] : 'Not available', // Check if 'name' field exists
          'sectors': doc.data().containsKey('sectors') ? List<String>.from(doc['sectors']) : [], // Check if 'sectors' field exists
          'address': doc.data().containsKey('address') ? doc['address'] : 'Not available', // Check if 'address' field exists
          'email': doc.data().containsKey('email') ? doc['email'] : 'Not available', // Check if 'email' field exists
          'phone': doc.data().containsKey('phone') ? doc['phone'] : 'Not available', // Check if 'phone' field exists
          'uid': doc.id, // Document ID as unique identifier
          'distance': 0, // Placeholder for distance calculation (if required later)
        };
      }).toList();
    });
  } catch (e) {
    print("Error fetching NGOs: $e");
    setState(() {
      _nearbyNGOs = [];  // Clear NGO list if there's an error
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load NGOs: $e'), backgroundColor: Colors.red),
    );
  }
}


  // Filter NGOs based on selected sectors
  List<dynamic> _filterNGOsBySectors() {
    if (_selectedSectors.isEmpty) {
      return _nearbyNGOs;  // Return all NGOs if no sectors selected
    }

    return _nearbyNGOs.where((ngo) {
      List<String> ngoSectors = ngo['sectors'] ?? [];
      return _selectedSectors.any((sector) => ngoSectors.contains(sector));
    }).toList();
  }

  @override
  @override
Widget build(BuildContext context) {
  List<dynamic> filteredNGOs = _filterNGOsBySectors();

  return Scaffold(
    body: Stack(
      children: [
        // Background image
        Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Image.asset(
        'assets/landingpage.png',
        fit: BoxFit.cover,
      ),
    ),
    // Overlay with some opacity
    Positioned.fill(
      child: Container(
        color: Colors.lightBlue.withOpacity(0.4),
      ),
    ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200,), // Space for the top content

              // Displaying Location info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _locationMessage,
                  style: TextStyle(color: Colors.white, fontFamily: 'PixelyR'),
                ),
              ),
              
              // Sectors Selection UI
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: sectors.map((sector) {
                    return ChoiceChip(
                      label: Text(sector),
                      selected: _selectedSectors.contains(sector),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedSectors.add(sector);
                          } else {
                            _selectedSectors.remove(sector);
                          }
                        });
                      },
                      backgroundColor: Colors.lightBlue,
                      selectedColor: AppColors.dustyPink,
                      labelStyle: TextStyle(color: Colors.white, fontFamily: 'PixelyR'),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20,),
              Text('NGOs in your locality',
                style: TextStyle(
                  color: AppColors.mintGreen,
                  fontFamily: 'PixelyB',
                  fontSize: 25
                ),
              ),
              SizedBox(height: 20,),

              // NGO list with its own scroll
              filteredNGOs.isEmpty
                  ? Center(child: SizedBox(
                    height: 600,
                    child: Text("No nearby NGOs found.", style: TextStyle(color: Colors.white, fontFamily: 'PixelyB'))))
                  : SizedBox(
                    
                    child: ListView.builder(
                        shrinkWrap: true,  // Makes sure the ListView takes only the needed space
                        physics: NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling independently
                        itemCount: filteredNGOs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 300),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,  // Container takes 60% of the screen width
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                border: Border.all(color: Colors.lightBlue, width: 0.5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // NGO Name
                                  Text(
                                    filteredNGOs[index]['name'] ?? "No Name",
                                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'PixelyB', fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  // Sector Row
                                  Row(
                                    children: [
                                      Text(
                                        "Sector: ",
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        filteredNGOs[index]['sectors'].join(', '),
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  // Address Row
                                  Row(
                                    children: [
                                      Text(
                                        "Address: ",
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        filteredNGOs[index]['address'] ?? 'Not available',
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  // Email Row
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ",
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      Spacer(),
                                      SelectableText(
                                        filteredNGOs[index]['email'] ?? 'Not available',
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.copy, color: Colors.white),
                                        onPressed: () {
                                          final email = filteredNGOs[index]['email'] ?? 'Not available';
                                          Clipboard.setData(ClipboardData(text: email));
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email copied to clipboard")));
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  // Phone Row
                                  Row(
                                    children: [
                                      Text(
                                        "Phone: ",
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      Spacer(),
                                      SelectableText(
                                        filteredNGOs[index]['phone'] ?? 'Not available',
                                        style: TextStyle(color: Colors.white, fontFamily: 'PixelyB', fontSize: 16.0),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.copy, color: Colors.white),
                                        onPressed: () {
                                          final phone = filteredNGOs[index]['phone'] ?? 'Not available';
                                          Clipboard.setData(ClipboardData(text: phone));
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone number copied to clipboard")));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ),
            ],
          ),
        ),
      ],
    ),
  );
}

}





class OrgHomePage extends StatefulWidget {
  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  String _locationMessage = "";
  List<dynamic> _nearbyNGOs = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      _fetchNearbyNGOs(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchNearbyNGOs(double latitude, double longitude) async {
    final url = Uri.parse("http://localhost:5000/api/geoR/find-nearbyCorporate");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
          "max": 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nearbyNGOs = data;
        });
      } else {
        throw Exception("Failed to fetch nearby Corporate: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching nearby Corporate: $e");
      setState(() {
        _nearbyNGOs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "NGO Home",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 20),
        Text(
          _locationMessage,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text("NGO Features"),
        ),
        SizedBox(height: 20),
        Text("Nearby Corporates:"),
        _nearbyNGOs.isEmpty
            ? Text("No nearby Corporates found.")
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _nearbyNGOs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_nearbyNGOs[index]['name'] ?? "No Name"),
                    subtitle: Text("Distance: ${_nearbyNGOs[index]['distance']} meters"),
                  );
                },
              ),
      ],
    );
  }
}

class GuestHomePage extends StatelessWidget {
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
          onPressed: () {},
          child: Text("Explore"),
        ),
      ],
    );
  }
}
