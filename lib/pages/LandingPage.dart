import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/LoginOption.dart';
import 'package:segfaultersloc/pages/SignupOption.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  bool _showJoinUsButton = false;
  bool _isLoginHovered = false;
  bool _isSignupHovered = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        _showJoinUsButton = true;
      });
    });
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
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(20),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontFamily: 'PixelyR',
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Empowering communities through impactful Corporate Social Responsibility initiatives for a sustainable future.',
                        cursor: '|',
                        speed: Duration(milliseconds: 50),
                      ),
                    ],
                    isRepeatingAnimation: false,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
              if (_showJoinUsButton)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AnimatedOpacity(
                    opacity: _showJoinUsButton ? 1.0 : 0.0,
                    duration: Duration(seconds: 2),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          'Join us now!',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontFamily: 'PixelyR',
                          ),
                        ),
                        SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _showJoinUsButton ? 1.0 : 0.0,
                          duration: Duration(seconds: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _isLoginHovered = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _isLoginHovered = false;
                                  });
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> Loginoption()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white),
                                      gradient: _isLoginHovered
                                          ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                              colors: [
                                              
                                                Color(0xFF498EE9),
                                                Color(0xFFB674B2),
                                              ],
                                            )
                                          : null,
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'PixelyR',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _isSignupHovered = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _isSignupHovered = false;
                                  });
                                },
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> Signupoption()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white),
                                      gradient: _isSignupHovered
                                          ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                              colors: [
                                               
                                                Color(0xFF498EE9),
                                                Color(0xFFB674B2),
                                              ],
                                            )
                                          : null,
                                    ),
                                    child: Text(
                                      'Signup',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'PixelyR',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              height: 50,
              width: 50,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
