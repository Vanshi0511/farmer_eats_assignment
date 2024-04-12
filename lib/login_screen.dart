import 'dart:convert';

import 'package:famer_eats/signup_one.dart';
import 'package:famer_eats/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'forgot_password.dart';

class LoginPage extends StatelessWidget {
  // Global variables for type and socialId
  String? globalType;
  String? globalSocialId;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  LoginPage({Key? key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              _header(context),
              SizedBox(
                height: 50,
              ),
              _inputField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FarmerEats", // Replace with your app name
            style: TextStyle(
                fontFamily: 'BeVietnamPro-Light',
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 60),
          const Text(
            "Welcome back!",
            style: TextStyle(
                fontFamily: 'BeVietnamPro-Medium',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "New Here ? ",
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro-Medium',
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "Create account",
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro-Medium',
                        color: Color(0xFFD5715B),
                      ),
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

  _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
              hintText: "Email Address",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.grey.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.alternate_email)),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffix: GestureDetector(
              onTap: () {
                // Navigate to ForgotPasswordScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: const Text(
                "Forgot?",
                style: TextStyle(color: Color(0xFFD5715B)),
              ),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            final email = _emailController.text;
            final password = _passwordController.text;
            if (email.isEmpty && password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter your email and password.'),
                ),
              );
            } else if (email.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter your email.'),
                ),
              );
            } else if (password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter your password.'),
                ),
              );
            } else {
              loginUser(context, email, password, type: 'email');
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Color(0xFFD5715B),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Text(
            "or login with",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 40), // Add some space between the text and the cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLogoCard(context, 'assets/images/g_logo.png', type: 'google'),
            _buildLogoCard(context, 'assets/images/apple_logo.png',
                type: 'apple'),
            _buildLogoCard(context, 'assets/images/fb_logo.png',
                type: 'facebook'),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoCard(BuildContext context, String imagePath,
      {String? type}) {
    return GestureDetector(
      onTap: () {
        if (type == 'google') {
          // Handle Google sign-in
          signInWithGoogle(context);
        } else if (type == 'facebook') {
          // Handle Facebook sign-in
          signInWithFacebook(context);
        } else {
          // Default to email login
          loginUser(context, _emailController.text, _passwordController.text,
              type: type);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 4,
        color: Colors.white,
        child: Container(
          width: 80,
          height: 50,
          padding: EdgeInsets.all(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'], // Request email and public profile permissions
      );
      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final String token = accessToken.token;
        final userId = accessToken.userId;
        print('Facebook access token: $token');
        print('Facebook user ID: $userId');
        globalType = 'Facebook';
        globalSocialId = userId;
        final userData = await FacebookAuth.instance.getUserData();
        final String? email = userData['email'];
        _emailController.text = email ?? '';

      }
    } catch (error) {
      print('Facebook sign-in error: $error');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Initialize GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Get the authentication tokens
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final String token = googleSignInAuthentication.accessToken!;
        final String socialId = googleSignInAccount.id;
        print('Google sign-in token: $token');
        print('Google sign-in socialId: $socialId');
        globalType = 'Google';
        globalSocialId = socialId;
        AuthCredential credential=await GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication?.accessToken,
            idToken: googleSignInAuthentication?.idToken
        );
        UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);
        print(userCredential.user?.displayName);
        print(userCredential.user?.email);
        print(userCredential.user?.phoneNumber);
        final User? user = userCredential.user;
        // Check if user information exists
        showToast("Implementing google sign in");
        if (user != null) {
          _emailController.text = user.email ?? '';
        }

      }
    } catch (error) {
      // Handle sign-in errors
      print('Google sign-in error: $error');
    }
  }
  Future<void> loginUser(BuildContext context, String email, String password,
      {String? type, String? socialId}) async {
    String? deviceToken;
    _firebaseMessaging.getToken().then((token) {
      deviceToken = token;
      print('Device Token: $deviceToken');
      print("Firebase Messaging Token: $token\n");

    });

    final String apiUrl = 'https://sowlab.com/assignment/user/login';
    final Map<String, dynamic> formData = {
      "email": email,
      "password": password,
      "role": "farmer",
      "device_token": deviceToken,
      "type": globalType ?? "Email",
      "social_id": globalSocialId ?? "0"
    };
    print('FormData: $formData');
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'];
      print('login message: $message');
      final bool success = responseData['success'];
      if (success) {
        // Login successful, navigate to verification screen
        showToast(message);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerificationScreen()),
        );
      } else {
        showToast(message);
        print('Login message: $message');
      }
    } else {
      // Login failed due to server error
      throw Exception('Failed to login');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFFD5715B),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
