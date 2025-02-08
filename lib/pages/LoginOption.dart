import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/LoginPageCorp.dart';
import 'package:segfaultersloc/pages/LoginPageOrg.dart';

class Loginoption extends StatefulWidget {
  const Loginoption({super.key});

  @override
  State<Loginoption> createState() => _LoginoptionState();
}

class _LoginoptionState extends State<Loginoption> {
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
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=> Loginpage()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        'Login as NGO',
                        style: TextStyle(
                          fontFamily: 'PixelyB',
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
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> LoginpageCorp()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        'Login as Corporation',
                        style: TextStyle(
                          fontFamily: 'PixelyB',
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
