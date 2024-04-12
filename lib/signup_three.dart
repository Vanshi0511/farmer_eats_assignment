import 'package:famer_eats/signup_four.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpThirdPage extends StatefulWidget {
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
  final String token;
  final String socialId;
  final String type;

  SignUpThirdPage({
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
    required this.token,
    required this.socialId,
    required this.type,
  }) : super(key: key);

  @override
  State<SignUpThirdPage> createState() => _SignUpThirdPageState();
}

class _SignUpThirdPageState extends State<SignUpThirdPage> {
  String _selectedFilePath = '';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.name!;
      });
    }
  }

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
            _fileUploadSection(),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Check if the required field is empty
                if (_selectedFilePath.isEmpty) {
                  // Show message if the required field is empty
                  showToast("Please select a registration proof file");
                } else {
                  // Navigate to the next page if all required fields are filled
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupFour(
                          fullName: widget.fullName,
                          email: widget.email,
                          password: widget.password,
                          phone: widget.phone,
                          businessName: widget.businessName,
                          informalName: widget.informalName,
                          address: widget.address,
                          city: widget.city,
                          state: widget.state,
                          zipCode: widget.zipCode,
                          registrationProof: _selectedFilePath.split('/').last,
                          token: widget.token,
                          socialId: widget.socialId,
                          type: widget.type),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                backgroundColor: Color(0xFFD5715B),
              ),
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
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
          "Signup 3 of 4",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        ),
        SizedBox(height: 10),
        Text(
          "Verification",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _fileUploadSection() {
    return Column(
      children: [
        Text(
          'Attach proof of registration (e.g. Florida Fresh, USDA Approved, USDA Organic)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Attach proof of registration",
              style: TextStyle(
                  fontFamily: 'BeVietnamPro-Light',
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD5715B),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Icon(
                Icons.camera_enhance,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Visibility(
          visible: _selectedFilePath.isNotEmpty,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedFilePath.isEmpty
                          ? 'No file selected'
                          : _selectedFilePath,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      // Clear the selected file path
                      setState(() {
                        _selectedFilePath = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
