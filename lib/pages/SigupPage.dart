import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<Signuppage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // TODO: Add your login logic here.
      print('Logging in with Email: $email and Password: $password');
    }
  }

  void _navigateToSignIn() {
    // TODO: Replace with your navigation logic
    print('Navigating to Sign In page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[ 
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
                    'Signup',
                    style: TextStyle(fontSize: 50,
                    fontFamily: 'PixelyB'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _navigateToSignIn,
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
                          backgroundColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.3))
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
        ]
      ),
    );
  }
}
