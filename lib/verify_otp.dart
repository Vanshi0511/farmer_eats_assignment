import 'dart:convert';

import 'package:famer_eats/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({Key? key}) : super(key: key);

  final TextEditingController _otpController = TextEditingController();
  Future<void> verifyOtp(BuildContext context, String otp) async {
    final String apiUrl = 'https://sowlab.com/assignment/user/verify-otp';
    final Map<String, dynamic> formData = {"otp": otp};

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
      print('Verify OTP message: $message');

      if (success) {
        final String token = responseData['token'];
        showToast(message);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: token)),
        );
      } else {
        print('OTP verification failed: $message');
        showToast(message);
      }
    } else {
      showToast("Response Failed");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: 50),
              _header(context),
              SizedBox(height: 50),
              PinPut(
                fieldsCount: 5,
                onSubmit: (String pin) {
                  verifyOtp(context, pin);
                },
                textStyle: const TextStyle(fontSize: 20.0),
                eachFieldWidth: 50.0,
                eachFieldHeight: 50.0,
                focusNode: FocusNode(),
                controller: _otpController,
                submittedFieldDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                selectedFieldDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                followingFieldDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(height: 40),
              _buttonField(context),
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
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 60),
          const Text(
            "Verify OTP",
            style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                text: const TextSpan(
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

  Widget _buttonField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            final otp = _otpController.text;
            if (otp.isEmpty) {
              showToast('Please enter OTP.');
            } else {
              verifyOtp(context, otp);
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
        const SizedBox(height: 15),
        Center(
          child: GestureDetector(
            onTap: () {
              // Resend OTP
            },
            child: const Text(
              "Resend Code",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
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
}
