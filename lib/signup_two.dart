import 'package:famer_eats/signup_four.dart';
import 'package:famer_eats/signup_three.dart';
import 'package:flutter/material.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SignUpSecondPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String token;
  final String socialId;
  final String type;
  const SignUpSecondPage({
    Key? key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.token,
    required this.socialId,
    required this.type,
  }) : super(key: key);

  @override
  State<SignUpSecondPage> createState() => _SignUpSecondPageState();
}

class _SignUpSecondPageState extends State<SignUpSecondPage> {
  late String _selectedState = 'Madhya Pradesh';

  List<String> _states = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
  late TextEditingController _businessNameController;
  late TextEditingController _informalNameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  @override
  void initState()
  {
    super.initState();
    _businessNameController = TextEditingController();
    _informalNameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


    body:
    SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          _header(context),
          SizedBox(height: 30),
          _inputField(context),
          SizedBox(height: 50),
        ],
      ),
    )
    ,
      bottomNavigationBar:
      Padding(
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
                // Check if any field is empty
                if (_businessNameController.text.isEmpty) {
                  showToast("Please enter your business name");
                } else if (_informalNameController.text.isEmpty) {
                  showToast("Please enter your informal name");
                } else if (_addressController.text.isEmpty) {
                  showToast("Please enter your address");
                } else if (_cityController.text.isEmpty) {
                  showToast("Please enter your city");
                } else if (_zipCodeController.text.isEmpty) {
                  showToast("Please enter your ZIP code");
                } else if (_selectedState == null) {
                  showToast("Please select your state");
                } else {
                  // Call the API only if all fields are filled
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpThirdPage(
                        fullName: widget.fullName,
                        email: widget.email,
                        password: widget.password,
                        phone: widget.phone,
                        businessName: _businessNameController.text,
                        informalName: _informalNameController.text,
                        address: _addressController.text,
                        city: _cityController.text,
                        state: _selectedState,
                        zipCode: _zipCodeController.text,
                        token:widget.token,
                        socialId:widget.socialId,
                        type:widget.type
                      ),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24),
                backgroundColor: Color(0xFFD5715B),
              ),
              child: Text(
                "Continue",
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
          "Signup 2 of 4",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        ),
        SizedBox(height: 10),
        Text(
          "Farm Info",
          style: TextStyle(
              fontFamily: 'BeVietnamPro-Medium',
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _businessNameController,
          decoration: InputDecoration(
            hintText: "Business Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.business),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: _informalNameController,
          decoration: InputDecoration(
            hintText: "Informal Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.emoji_emotions_outlined),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: "Street Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.home_outlined),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            hintText: "City",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _stateController,
                    decoration: InputDecoration(
                      hintText: 'State',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return _states.where((state) =>
                        state.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (String? suggestion) {
                    setState(() {
                      _selectedState = suggestion!;
                      _stateController.text = _selectedState;
                      //_zipCodeController.text = suggestion;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedState = value!,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _zipCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter ZipCode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
