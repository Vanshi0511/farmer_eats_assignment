import 'package:famer_eats/login_screen.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Set to true to prevent navigating back
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/vector.png')),
                SizedBox(height: 20),
                Text(
                  'You\'re all done!',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Text(
                  'Hang tight! we are currently reviewing your account and\nwill follower with you in 2-3 business days. In the\nmeantime, you can setup your inventory.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'BeVietnamPro-Regular',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Color(0xFFD5715B),
              ),
              child: const Text(
                'Got It!',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
