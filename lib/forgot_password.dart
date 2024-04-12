import 'dart:convert';
import 'package:famer_eats/login_screen.dart';
import 'package:famer_eats/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();

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
              _inputField(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendCode(BuildContext context, String mobile) async {
    final String apiUrl = 'https://sowlab.com/assignment/user/forgot-password';
    final Map<String, dynamic> formData = {"mobile": "+91"+mobile};

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final bool success = responseData['success'];
      final String message = responseData['message'];
      print('Forgot password message: $message');
      if (success) {
        showToast(message);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyOtpScreen()),
        );
      } else {
        print('Forgot password message: $message');
        showToast(message);
      }
    }
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
            "Forgot Password?",
            style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
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
  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Enter Phone Number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixText: "+91 ",
            prefixIcon: Icon(Icons.phone_rounded),
          ),
          onChanged: (value) {
            // Remove any non-digit characters
            String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
            // If the length exceeds 10, trim it
            if (digitsOnly.length > 10) {
              digitsOnly = digitsOnly.substring(0, 10);
            }
            // Update the controller's value
            phoneController.value = TextEditingValue(
              text: digitsOnly,
              selection: TextSelection.collapsed(offset: digitsOnly.length),
            );
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(10), // 10 digits
          ],
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            final mobile = phoneController.text;
            if (mobile.isEmpty || mobile.length != 10) {
              showToast("Please enter a valid phone number.");
            } else {
              sendCode(context, mobile); // Send the mobile number without prefix
            }
          },
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Color(0xFFD5715B),
          ),
          child: Text(
            "Send Code",
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
}
