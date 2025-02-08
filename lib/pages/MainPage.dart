import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      _fetchNearbyNGOs(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchNearbyNGOs(double latitude, double longitude) async {
    final url = Uri.parse("http://localhost:5000/api/geoR/find-nearbyNgo");

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
        throw Exception("Failed to fetch nearby NGOs: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching nearby NGOs: $e");
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
          "Corporate Home",
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
          child: Text("Corporate Features"),
        ),
        SizedBox(height: 20),
        Text("Nearby NGOs:"),
        _nearbyNGOs.isEmpty
            ? Text("No nearby NGOs found.")
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
