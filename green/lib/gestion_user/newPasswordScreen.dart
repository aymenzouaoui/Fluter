import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/common/page_header.dart';
import 'package:flutter_login_register_ui/home_screen.dart';
import 'package:flutter_login_register_ui/screens/screen.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:flutter_login_register_ui/widgets/my_password_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  bool isPasswordVisible = true;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FadeTransition(
            
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PageHeader(),
              MyPasswordField(
                isPasswordVisible: isPasswordVisible,
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add additional password validation if needed
                  return null;
                },
                controller: _newPasswordController,
              ),
              SizedBox(height: size.height * 0.02), // Responsive spacing
              MyPasswordField(
                isPasswordVisible: isPasswordVisible,
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add additional password validation if needed
                  return null;
                },
                controller: _confirmPasswordController,
              ),
              SizedBox(height: size.height * 0.02), // Responsive spacing
              ElevatedButton(
                onPressed: () => _resetPassword(context),
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _resetPassword(BuildContext context) async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in all fields");
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    // Additional password validation can be added here

   try {
    await authService.newPassword(widget.email, newPassword);
    // If this point is reached, password update was successful
    Fluttertoast.showToast(msg: "Password successfully updated");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
    // Navigate to another screen or perform other actions as necessary
  } catch (error) {
    // If an error is thrown, handle it here (e.g., show an error toast)
    Fluttertoast.showToast(msg: "Failed to update password");
  }
  }
}
