import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/SignupCorp.dart';
import 'package:segfaultersloc/pages/SigupPageorg.dart';

class Signupoption extends StatefulWidget {
  const Signupoption({super.key});

  @override
  State<Signupoption> createState() => _LoginoptionState();
}

class _LoginoptionState extends State<Signupoption> {
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
              width: MediaQuery.of(context).size.width * 0.4, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=> Signuporg()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        'Signup as NGO',
                        style: TextStyle(
                          fontFamily: 'PixelyR',
                          fontSize: 20, 
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.white.withOpacity(0.4),
                    thickness: 1, 
                    indent: 0, 
                    endIndent: 0,
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> Signupcorp()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        'Signup as Corporation',
                        style: TextStyle(
                          fontFamily: 'PixelyR',
                          fontSize: 20, 
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
