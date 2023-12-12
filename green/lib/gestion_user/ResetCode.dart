import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/constants.dart';
import 'package:flutter_login_register_ui/gestion_user/common/custom_form_button.dart';

import 'package:flutter_login_register_ui/models/homelist.dart';
import 'package:flutter_login_register_ui/screens/signin_page.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:flutter_login_register_ui/widgets/my_text_field.dart';

import 'common/custom_input_field.dart';
import 'common/page_heading.dart';
import 'page_header.dart';

class ForgetCodePage extends StatefulWidget {
  const ForgetCodePage({Key? key}) : super(key: key);

  @override
  State<ForgetCodePage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetCodePage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _forgetPasswordFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Forgot password',
                        ),
                        TextFormField(
                          style: kTextFormFieldStyle(),
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_rounded),
                            hintText: 'gmail',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter gmail';
                            } else if (!value.endsWith('@gmail.com')) {
                              return 'please enter valid gmail';
                            }
                            return null;
                          },
                        ),
                        CustomFormButton(
                          innerText: 'Submit',
                          onPressed: _handleForgetPassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                         builder: (context) => SignInPage()))     },
                            child: const Text(
                              'Back to login',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939393),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
        // Call the sendResetCode method from the AuthService
        await authService.sendResetCode(_emailController.text);

        // Show success message or navigate to a confirmation page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reset code sent successfully')),
        );
      } catch (error) {
        // Handle errors, e.g., display an error message
        print('Error sending reset code: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to send reset code. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
