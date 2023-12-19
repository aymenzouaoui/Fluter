import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/custom_drawer/drawer_user_controller.dart';
import 'package:flutter_login_register_ui/gestion_user/ResetCode.dart';

import 'package:flutter_login_register_ui/home_screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widget.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final AuthService authService;
  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Initialize the authService here
    authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Color.fromRGBO(40, 97, 11, 1),
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            reverse: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Lottie.network(
                              'https://lottie.host/f7be39ed-7a57-4081-8e0c-e08a0df2e8b1/dNRPbnS0WC.json', // Replace with the path to your image asset
                              height: 500, // Adjust the height as needed
                              width: 1000, // Adjust the width as needed
                              fit:
                                  BoxFit.contain, // Adjust the BoxFit as needed
                            ),
                            Text(
                              "Welcome back.",
                              style: kHeadline,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "You've been missed!",
                              style: kBodyText2,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            MyTextField(
                              hintText: 'Phone, email or username',
                              inputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: emailController,
                            ),
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
                                } /*
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (!RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]')
                                    .hasMatch(value)) {
                                  return 'Password must contain both letters and numbers';
                                }
                                // Add any additional password validation rules here*/
                                return null;
                              },
                              controller: passwordController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextButton(
                        buttonName: 'Sign In',
                        onTap: () {
                          // Trigger the form validation
                          bool isValid =
                              _formKey.currentState?.validate() ?? false;

                          // If the form is valid, proceed with the login process
                          if (isValid) {
                            authService
                                .loginUser(
                              emailController.text,
                              passwordController.text,
                            )
                                .then((result) {
                              // Assuming `loginUser` returns a Future<Map<String, dynamic>>
                              if (result.containsKey('token')) {
                                final String token = result['token'];
                                final Map<String, dynamic> user =
                                    result['user'];

                                // Check if the token is not empty and proceed
                                if (token.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DrawerUserController(
                                        screenView: MyHomePage(),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Handle the case where login does not provide a token
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Login failed, please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                // If the result map doesn't contain the token key, handle the error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Invalid response from the server.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }).catchError((error) {
                              // Handle any errors from the login process
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('An error occurred: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          } else {
                            // If the form is not valid, show a snackbar or toast
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please correct the errors in the form.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        bgColor: Color.fromRGBO(40, 97, 11, 1),
                        textColor: const Color.fromARGB(221, 255, 255, 255),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgetCodePage()))
                              },
                              child: const Text(
                                'Forget password?',
                                style: TextStyle(
                                  color: Color.fromRGBO(40, 97, 11, 1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).paddingOnly(right: 20),
                            ),
                          ),
                          Text(
                            "Don't have an account? ",
                            style: kBodyText,
                          ).paddingOnly(left: 200),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SignUpView(),
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: kBodyText.copyWith(
                                color: Color.fromRGBO(40, 97, 11, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ).paddingOnly(left: 20),
                        ],
                      ).paddingAll(20),
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
}
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/ResetCode.dart';

import 'package:flutter_login_register_ui/custom_drawer/drawer_user_controller.dart';
import 'package:flutter_login_register_ui/home_screen.dart';
import 'package:flutter_login_register_ui/screens/register_page.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../widgets/widget.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final AuthService authService;
  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image(
            width: 24,
            color: Color.fromRGBO(40, 97, 11, 1),
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Lottie.network(
                'https://lottie.host/f7be39ed-7a57-4081-8e0c-e08a0df2e8b1/dNRPbnS0WC.json',
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back.", style: kHeadline),
                      SizedBox(height: 10),
                      Text("You've been missed!", style: kBodyText2),
                      SizedBox(height: 60),
                      MyTextField(
                        hintText: 'Phone, email or username',
                        inputType: TextInputType.text,
                        controller: emailController,
                        validator: (value) => _emailValidator(value),
                      ),
                      MyPasswordField(
                        isPasswordVisible: isPasswordVisible,
                        onTap: () => setState(() => isPasswordVisible = !isPasswordVisible),
                        controller: passwordController,
                        validator: (value) => _passwordValidator(value),
                      ),
                      SizedBox(height: 20),
                      MyTextButton(
                        buttonName: 'Sign In',
                        onTap: () => _handleSignIn(context),
                        bgColor: Color.fromRGBO(40, 97, 11, 1),
                        textColor: Colors.white,
                      ),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Please enter a valid email address';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    // Additional password validation logic can be added here
    return null;
  }

  void _handleSignIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      authService.loginUser(emailController.text, passwordController.text).then((result) {
        final String token = result['token'];
        if (token.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerUserController(screenView: MyHomePage())));
        }
      });
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetCodePage())),
            child: Text(
              'Forget password?',
              style: TextStyle(color: Color.fromRGBO(40, 97, 11, 1), fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          Text("Don't have an account? ", style: kBodyText),
          GestureDetector(
            onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SignUpView())),
            child: Text('Register', style: kBodyText.copyWith(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
    );
  }
}
*/