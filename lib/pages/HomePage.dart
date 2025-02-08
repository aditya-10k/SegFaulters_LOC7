import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/LandingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> _logout() async {
    try {
      // Clear JWT token from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the LandingPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Landingpage()),
      );
    } catch (error) {
      print('Error during logout: $error');
      // Show error snackbar
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
