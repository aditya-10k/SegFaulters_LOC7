import 'package:flutter/material.dart';
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

class CorpProfile extends StatelessWidget {
  final VoidCallback logoutCallback;

  const CorpProfile({super.key, required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Corporate Profile",
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

class OrgProfile extends StatelessWidget {
  final VoidCallback logoutCallback;

  const OrgProfile({super.key, required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "NGO Profile",
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
