import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/screens/signin_page.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import '../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/simple_ui_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.network(
              'https://lottie.host/f7be39ed-7a57-4081-8e0c-e08a0df2e8b1/dNRPbnS0WC.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body/// Main Body
Widget _buildMainBody(
    Size size, SimpleUIController simpleUIController, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment:
        size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
    children: [
      size.width > 600
          ? Container()
          : Lottie.network(
              'https://lottie.host/f7be39ed-7a57-4081-8e0c-e08a0df2e8b1/dNRPbnS0WC.json',
              height: size.height * 0.2,
              width: size.width,
              fit: BoxFit.fill,
            ),
      SizedBox(height: size.height * 0.03),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text('Sign Up', style: kLoginTitleStyle(size)),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text('Create Account', style: kLoginSubtitleStyle(size)),
      ),
      SizedBox(height: size.height * 0.03),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Username
              TextFormField(
                style: kTextFormFieldStyle(),
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Username',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  } else if (value.length < 4) {
                    return 'at least enter 4 characters';
                  } else if (value.length > 13) {
                    return 'maximum character is 13';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * 0.02),
              // Email
              TextFormField(
                style: kTextFormFieldStyle(),
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height * 0.02),
              // Password
              Obx(
                () => TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: passwordController,
                  obscureText: simpleUIController.isObscure.value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(simpleUIController.isObscure.value ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        simpleUIController.isObscureActive();
                      },
                    ),
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Confirm Password
              Obx(
                () => TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: confirmPasswordController,
                  obscureText: simpleUIController.isObscure.value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(simpleUIController.isObscure.value ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        simpleUIController.isObscureActive();
                      },
                    ),
                    hintText: 'Confirm Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                style: kLoginTermsAndPrivacyStyle(size),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              // Sign Up Button
              signUpButton(theme),
              SizedBox(height: size.height * 0.03),
              // Navigate to Login Screen
              GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (ctx) => SignInPage()));
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                  _formKey.currentState?.reset();
                  simpleUIController.isObscure.value = true;
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: kHaveAnAccountStyle(size),
                    children: [
                      TextSpan(text: " Login", style: kLoginOrSignUpTextStyle(size)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromRGBO(40, 97, 11, 1)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (passwordController.text != confirmPasswordController.text) {
                // Passwords don't match, show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Passwords do not match'),
                  ),
                );
              } else {
                authService
                    .registerUser(emailController.text, passwordController.text,
                        nameController.text)
                    .then((result) {
                  final String email = result['email'];
                  print("object");
                  print(email);
                  if (email.isNotEmpty) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  }
                });
              }
            }
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 24, // Adjust the font size
              fontWeight: FontWeight.bold, // Change the font weight
              color: const Color.fromARGB(
                  255, 255, 255, 255), // Change the text color
              letterSpacing: 1.2, // Adjust letter spacing
              // You can add other text style properties here as well
            ),
          )),
    );
  }
}
