import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'login_screen.dart';
import 'signup_two.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // String token = '';
  String socialId = '';
  String selectedImagePath = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    String? deviceToken;
    _firebaseMessaging.getToken().then((value) {
      deviceToken = value;
      print('Device Token: $deviceToken');
    });
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            _header(context),
            SizedBox(height: 30),
            _inputField(context),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              width: 226,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  print('Full Name: ${fullNameController.text}');
                  print('Email: ${emailController.text}');
                  print('Phone: ${phoneController.text}');
                  print('Password: ${passwordController.text}');

                  // Check if any field is empty
                  if (fullNameController.text.isEmpty) {
                    showToast("Please enter your full name");
                  } else if (emailController.text.isEmpty) {
                    showToast("Please enter your email");
                  } else if (phoneController.text.isEmpty) {
                    showToast("Please enter your phone number");
                  } else if (passwordController.text.isEmpty) {
                    showToast("Please enter your password");
                  } else {
                    // Call the API only if all fields are filled
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpSecondPage(
                          fullName: fullNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          phone: "+91"+phoneController.text,
                          token: deviceToken ?? '',
                          socialId: socialId,
                          type: selectedImagePath.contains('g_logo') ? 'Google' :
                          selectedImagePath.contains('apple_logo') ? 'Apple' :
                          selectedImagePath.contains('fb_logo') ? 'Facebook' : 'Email',
                        ),
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Color(0xFFD5715B),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FarmerEats",
          style: TextStyle(
            fontFamily: 'BeVietnamPro-Light',
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 40),
        const Text(
          "Signup 1 of 4",
          style: TextStyle(
            fontFamily: 'BeVietnamPro-Medium',
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        const Text(
          "Welcome!",
          style: TextStyle(
            fontFamily: 'BeVietnamPro-Medium',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLogoCard('assets/images/g_logo.png'),
            _buildLogoCard('assets/images/apple_logo.png'),
            _buildLogoCard('assets/images/fb_logo.png'),
          ],
        ),
        SizedBox(height: 30),
        const Center(
          child: Text(
            "or signup with",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoCard(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Handle sign-in logic based on the logo tapped
        if (imagePath == 'assets/images/g_logo.png') {
          selectedImagePath= 'assets/images/g_logo.png';
          signInWithGoogle();
        } else if (imagePath == 'assets/images/apple_logo.png') {
          // Handle Apple sign-in
          selectedImagePath= 'assets/images/apple_logo.png';
        } else if (imagePath == 'assets/images/fb_logo.png') {
          selectedImagePath= 'assets/images/fb_logo.png';
          signInWithFacebook();
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


  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(
            hintText: "Full Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.alternate_email),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Mobile Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixText: "+91 ",
            prefixStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.phone),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
            _PhoneNumberFormatter(),
          ],
        ),
        SizedBox(height: 15),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock_outlined),
          ),
          obscureText: true,
        ),
        SizedBox(height: 15),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Re-enter Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock_outlined),
          ),
          obscureText: true,
        ),
      ],
    );
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
  // Facebook sign-in method
  Future<void> signInWithFacebook( ) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final String token = accessToken.token;
        final userId = accessToken.userId;
        print('Facebook access token: $token');
        print('Facebook user ID: $userId');
       // this.token = token;
        this.socialId = userId;
        // Fetch user data using Graph API
        final userData = await FacebookAuth.instance.getUserData();
        final String? email = userData['email'];
        final String? name = userData['name'];

        emailController.text = email ?? '';
        fullNameController.text = name ?? '';
      }
    } catch (error) {
      print('Facebook sign-in error: $error');
    }
  }

  Future<void> signInWithGoogle() async {
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
      //  this.token = token;
        this.socialId = socialId;
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
          // Update the text controllers with user information
          fullNameController.text = user.displayName ?? '';
          emailController.text = user.email ?? '';
          phoneController.text=user.phoneNumber??'';
        }
      }
    } catch (error) {
      // Handle sign-in errors
      print('Google sign-in error: $error');
    }
  }


}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Remove any non-digit characters
    newText = newText.replaceAll(RegExp(r'\D'), '');

    // Check if the text length exceeds 10
    if (newText.length > 10) {
      // Trim the text to 10 characters
      newText = newText.substring(0, 10);
    }

    // Calculate the selection index
    int selectionIndex = newText.length;

    // If the user has deleted characters, adjust the selection index
    if (newValue.selection.start < newValue.text.length) {
      selectionIndex -= (newValue.text.length - newText.length);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}