import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:flutter_login_register_ui/gestion_user/ValidateResetCodeScreen.dart';
import 'package:flutter_login_register_ui/screens/signin_page.dart';
import 'package:flutter_login_register_ui/gestion_user/common/custom_form_button.dart';
import 'package:flutter_login_register_ui/gestion_user/common/page_heading.dart';
import 'package:flutter_login_register_ui/gestion_user/common/page_header.dart';

class ForgetCodePage extends StatefulWidget {
  const ForgetCodePage({Key? key}) : super(key: key);

  @override
  State<ForgetCodePage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetCodePage> with SingleTickerProviderStateMixin {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  AuthService authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(), // Custom widget
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Form(
                      key: _forgetPasswordFormKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          children: [
                            const PageHeading(title: 'Forgot password'), // Custom widget
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_rounded),
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              validator: (value) => EmailValidator.validate(value ?? '')
                                  ? null
                                  : "Please enter a valid email",
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            CustomFormButton(
                              innerText: 'Submit',
                              onPressed: _handleForgetPassword,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignInPage()),
                              ),
                              child: const Text(
                                'Back to login',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Color.fromARGB(255, 95, 140, 83),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleForgetPassword() async {
    if (_forgetPasswordFormKey.currentState!.validate()) {
      try {
        String userEmail = _emailController.text;
        await authService.sendResetCode(userEmail);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset code sent successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ValidateResetCodeScreen(email: userEmail),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reset code. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
