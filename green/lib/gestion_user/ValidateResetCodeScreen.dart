import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/newPasswordScreen.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/newPasswordScreen.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:lottie/lottie.dart';

class ValidateResetCodeScreen extends StatefulWidget {
  final String email;

  ValidateResetCodeScreen({required this.email});

  @override
  _ValidateResetCodeScreenState createState() =>
      _ValidateResetCodeScreenState();
}

class _ValidateResetCodeScreenState extends State<ValidateResetCodeScreen> {
  AuthService authService = AuthService();
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validate Reset Code'),
        backgroundColor: Color.fromRGBO(40, 97, 11, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child:  Lottie.network(
                              'https://lottie.host/f7be39ed-7a57-4081-8e0c-e08a0df2e8b1/dNRPbnS0WC.json', // Replace with the path to your image asset
                              height: 500, // Adjust the height as needed
                              width: 1000, // Adjust the width as needed
                              fit:
                                  BoxFit.contain, // Adjust the BoxFit as needed
                            ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Reset Code',
                          labelStyle: TextStyle(color: Colors.green),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            bool isValidCode =
                                await authService.verifyResetCode(
                                    widget.email, _codeController.text);

                            if (isValidCode) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewPasswordScreen(email: widget.email),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Invalid reset code. Please try again.'),
                                ),
                              );
                            }
                          } catch (error) {
                            print('Error validating reset code: $error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to validate reset code. Please try again.'),
                              ),
                            );
                          }
                        },
                        child: Text('Validate Code'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(
                              40, 97, 11, 1), // Button background color
                          onPrimary: Colors.white, // Button text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          elevation: 5, // Button elevation
                          textStyle: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                          shadowColor:
                              Colors.black.withOpacity(0.25), // Shadow color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvalidCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Code'),
          content:
              Text('The reset code you entered is invalid. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred while validating the code. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
