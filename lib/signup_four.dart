import 'package:famer_eats/verification.dart';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupFour extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String businessName;
  final String informalName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String registrationProof;
  final String token;
  final String socialId;
  final String type;
  const SignupFour({
    Key? key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.businessName,
    required this.informalName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.registrationProof,
    required this.token,
    required this.socialId,
    required this.type,
  }) : super(key: key);

  @override
  State<SignupFour> createState() => _SignupFourState();
}
class _SignupFourState extends State<SignupFour> {

  // String? _deviceToken;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getDeviceToken();
  // }
  //
  // void _getDeviceToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? token = await messaging.getToken();
  //   setState(() {
  //     _deviceToken = token;
  //   });
  // }
  bool mondayStart = false;
  bool mondayEnd = false;
  bool tuesdayStart = false;
  bool tuesdayEnd = false;
  bool wednesdayStart = false;
  bool wednesdayEnd = false;
  bool thursdayStart = false;
  bool thursdayEnd = false;
  bool fridayStart = false;
  bool fridayEnd = false;
  bool saturdayStart = false;
  bool saturdayEnd = false;
  bool sundayStart = false;
  bool sundayEnd = false;
  Map<String, bool> timeSlots = {
    '8:00 AM - 10:00 AM': false,
    '10:00 AM - 1:00 PM': false,
    '1:00 PM - 4:00 PM': false,
    '4:00 PM - 7:00 PM': false,
    '7:00 PM - 10:00 PM': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            _header(context),
            SizedBox(height: 30),
            _businessHoursSection(),
            SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Full Name: ${widget.fullName}');
                print('Email: ${widget.email}');
                print('Password: ${widget.password}');
                print('Phone: ${widget.phone}');
                print('Business Name: ${widget.businessName}');
                print('Informal Name: ${widget.informalName}');
                print('Address: ${widget.address}');
                print('City: ${widget.city}');
                print('State: ${widget.state}');
                print('Zip Code: ${widget.zipCode}');
                print('Registration Proof: ${widget.registrationProof}');
                // Check if at least one day is selected and at least one time slot is selected for that day
                if (!mondayStart &&
                    !tuesdayStart &&
                    !wednesdayStart &&
                    !thursdayStart &&
                    !fridayStart &&
                    !saturdayStart &&
                    !sundayStart) {
                  showToast('Please select at least one day');
                } else if (!_atLeastOneTimeSlotSelected()) {
                  // Show message if no time slot is selected
                  showToast('Please select at least one time slot for each selected day');
                } else {
                  // Call the registerUser function only if at least one day and one time slot are selected
                  registerUser();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: Color(0xFFD5715B),
              ),
              child: const Text(
                "Signup",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void registerUser() async {
    final String baseUrl = 'https://sowlab.com/assignment/user/register';
   // final String deviceToken = widget.token.isEmpty ? 'No token available' : widget.token;

    try {
      // Construct the form data
      final Map<String, dynamic> formData = {
        "full_name": widget.fullName,
        "email": widget.email,
        "password": widget.password,
        "phone": widget.phone,
        "business_name": widget.businessName,
        "informal_name": widget.informalName,
        "address": widget.address,
        "city": widget.city,
        "state": widget.state,
        "zip_code": widget.zipCode,
        "role": "farmer",
        "registration_proof": widget.registrationProof,
        "business_hours": _getSelectedBusinessHours(),
        "device_token": widget.token,
        "type": widget.type,
        "social_id": widget.socialId
      };

      // Print the form data
      print('Form Data: $formData');

      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      // Handle the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'];
        print('Message: $message');
        final bool success = responseData['success'];
        if (success) {
          // Registration successful, navigate to verification screen
          showToast(message);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerificationScreen()),
          );
        } else {
          // Registration failed, print error message
          showToast(message);
          print('Registration failed: $message');
        }
      } else {
        // Registration failed due to server error
        showToast("Registration failed due to server error");
        print('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred during registration process
      showToast("Error registering user");
      print('Error registering user: $e');
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
  Map<String, List<String>> _getSelectedBusinessHours() {
    Map<String, List<String>> selectedHours = {};

    if (mondayStart) selectedHours['mon'] = _getSelectedSlots();
    if (tuesdayStart) selectedHours['tue'] = _getSelectedSlots();
    if (wednesdayStart) selectedHours['wed'] = _getSelectedSlots();
    if (thursdayStart) selectedHours['thu'] = _getSelectedSlots();
    if (fridayStart) selectedHours['fri'] = _getSelectedSlots();
    if (saturdayStart) selectedHours['sat'] = _getSelectedSlots();
    if (sundayStart) selectedHours['sun'] = _getSelectedSlots();

    return selectedHours;
  }

  List<String> _getSelectedSlots() {
    List<String> selectedSlots = [];

    timeSlots.entries.forEach((entry) {
      if (entry.value) {
        selectedSlots.add(entry.key);
      }
    });

    return selectedSlots;
  }
  Widget _header(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FarmerEats", // Replace with your app name
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Light',
              fontSize: 15,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 40),
        Text(
          "Signup 4 of 4",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        ),
        SizedBox(height: 10),
        Text(
          "Business Hours",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _businessHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose the hours your farm is open for pickups.\nThis will allow customers to order deliveries',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 35),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('M', mondayStart,
                      () => setState(() => mondayStart = !mondayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('T', tuesdayStart,
                      () => setState(() => tuesdayStart = !tuesdayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('W', wednesdayStart,
                      () => setState(() => wednesdayStart = !wednesdayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('Th', thursdayStart,
                      () => setState(() => thursdayStart = !thursdayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('F', fridayStart,
                      () => setState(() => fridayStart = !fridayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('S', saturdayStart,
                      () => setState(() => saturdayStart = !saturdayStart)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _dayInitial('Su', sundayStart,
                      () => setState(() => sundayStart = !sundayStart)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _timeSlotGrid(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _timeSlotGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 3,
      children: timeSlots.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            setState(() {
              timeSlots[entry.key] = !timeSlots[entry.key]!;
            });
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: timeSlots[entry.key]!
                  ? Color(0xFFF8C569)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                entry.key,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dayInitial(String initial, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, // Adjust the width as needed
        height: 40, // Adjust the height as needed
        decoration: BoxDecoration(
          color: selected ? Color(0xFFD5715B) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  bool _atLeastOneTimeSlotSelected() {
    if (mondayStart && !_isAtLeastOneSlotSelectedForDay('mon')) return false;
    if (tuesdayStart && !_isAtLeastOneSlotSelectedForDay('tue')) return false;
    if (wednesdayStart && !_isAtLeastOneSlotSelectedForDay('wed')) return false;
    if (thursdayStart && !_isAtLeastOneSlotSelectedForDay('thu')) return false;
    if (fridayStart && !_isAtLeastOneSlotSelectedForDay('fri')) return false;
    if (saturdayStart && !_isAtLeastOneSlotSelectedForDay('sat')) return false;
    if (sundayStart && !_isAtLeastOneSlotSelectedForDay('sun')) return false;
    return true;
  }

  bool _isAtLeastOneSlotSelectedForDay(String day) {
    for (var slot in timeSlots.entries) {
      if (slot.value) return true;
    }
    return false;
  }

}

