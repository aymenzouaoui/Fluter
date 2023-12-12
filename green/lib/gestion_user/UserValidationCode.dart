import 'package:flutter/material.dart';

class UserValidationCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x99B7DAA6),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back button press
              },
            ),
            Text(
              'Enter Verification Code',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Please enter the verification code sent to your email',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTextInput('1'),
                buildTextInput('2'),
                buildTextInput('3'),
                buildTextInput('4'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Handle verification button press
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.all(16.0),
              ),
              child: Text(
                'Verify',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(
              'Didn\'t receive the code?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle resend code button press
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.all(16.0),
              ),
              child: Text(
                'Resend Code',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextInput(String label) {
    return Container(
      width: 60,
      child: TextField(
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserValidationCode(),
  ));
}
