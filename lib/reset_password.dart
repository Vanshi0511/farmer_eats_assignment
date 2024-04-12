import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'verification.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String token;
  ResetPasswordScreen({Key? key, required this.token});

  final TextEditingController _confirmPasswordController =
  TextEditingController();
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
            "FarmerEats",
            style: TextStyle(
                fontFamily: 'BeVietnamPro-Light',
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 60),
          const Text(
            "Reset Password",
            style: TextStyle(
                fontFamily: 'BeVietnamPro-Medium',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              // Navigate to login screen
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Remember Your Password ? ",
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro-Medium',
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "Login",
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

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "New Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: "Confirm New Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            final password = _passwordController.text;
            final confirmPassword = _confirmPasswordController.text;
            if (password.isEmpty && confirmPassword.isEmpty) {
              showToast('Please fill both password and confirm password fields.');
            } else if (password.isEmpty) {
              showToast('Please fill the password field.');
            } else if (confirmPassword.isEmpty) {
              showToast('Please fill the confirm password field.');
            } else {
              resetPassword(context, password, confirmPassword);
            }
          },

          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Color(0xFFD5715B),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
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
  Future<void> resetPassword(BuildContext context, String password, String confirmPassword) async {
    final String apiUrl = 'https://sowlab.com/assignment/user/reset-password';
    final Map<String, dynamic> formData = {
      "token": token,
      "password": password,
      "cpassword": confirmPassword
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final bool success = responseData['success'];
      final String message = responseData['message'];
      print('Reset password message: $message');

      if (success) {
        // Navigate to VerificationScreen
        showToast(message);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerificationScreen()),
        );
      } else {
        showToast(message);
        print('Password reset failed: $message');
      }
    } else {
      showToast('Failed to reset password. Please try again.');
    }
  }

}
