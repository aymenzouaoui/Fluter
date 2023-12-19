import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';
import 'package:lottie/lottie.dart';

class UserEditScreen extends StatefulWidget {
  // Assuming you pass the user ID
  final String id;

  UserEditScreen({Key? key, required this.id}) : super(key: key);

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nom, prenom, email, adress, cin, userName, numTel, ID;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    // Initialize with default values or fetch from a server
    nom = '';
    prenom = '';
    email = '';
    adress = '';
    cin = '';
    userName = '';
    numTel = '';
    ID = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lottie Animation
            Expanded(
              flex: 2, // Adjust flex as needed
              child: Lottie.network(
                'https://lottie.host/a26f233c-3080-4a06-add9-2770b657b242/bHMGbORnIv.json',
                fit: BoxFit.cover,
              ),
            ),

            // Form Fields and Title
            Expanded(
              flex: 3, // Adjust flex as needed
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Text(
                        'Edit My Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField('Nom', (value) => nom = value ?? ''),
                          _buildTextField(
                              'Prenom', (value) => prenom = value ?? ''),
                          _buildTextField(
                              'Email', (value) => email = value ?? ''),
                          _buildTextField(
                              'Adress', (value) => adress = value ?? ''),
                          _buildTextField('CIN', (value) => cin = value ?? ''),
                          _buildTextField(
                              'Username', (value) => userName = value ?? ''),
                          _buildTextField(
                              'Num Tel', (value) => numTel = value ?? ''),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  // Assume updateUserById is an async function that returns a Future<void>
                                  // and you handle the success/failure logic inside it
                                  await authService.updateUserById(widget.id, {
                                    'nom': nom,
                                    'prenom': prenom,
                                    'email': email,
                                    'adress': adress,
                                    'userName': userName,
                                    'numTel': numTel
                                  }).then((_) {
                                    // If the update was successful, show the success dialog
                                    _showUpdateDialog();
                                  }).catchError((error) {
                                    // If there was an error, you can show an error dialog or message
                                    print('Failed to update user: $error');
                                  });
                                }
                              },
                              child: Text('Submit'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(40, 97, 11, 1),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 16.0), // 16 pixels of vertical padding
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color:
                const Color.fromRGBO(40, 97, 11, 1), // Color of the label text
            fontWeight: FontWeight.bold, // Thickness of the label text
          ),
          hintText: 'Enter your $label', // Placeholder text
          hintStyle: TextStyle(color: Colors.grey),
          filled: true, // If true, the text field will have a background color
          fillColor: Colors.white70, // Background color of the text field
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(40, 97, 11, 1),
                width:
                    1.0), // Border color and width when the TextFormField is enabled
            borderRadius: BorderRadius.circular(8.0), // Rounded border corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width:
                    2.0), // Border color and width when the TextFormField is focused
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red,
                width: 1.0), // Border color when the TextFormField has an error
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(Icons.person,
              color: Color.fromRGBO(40, 97, 11,
                  1)), // Optional icon at the start of the text field
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Color.fromRGBO(40, 97, 11, 1)),
            onPressed:
                () {}, // Optional icon at the end of the text field, e.g., to clear the input
          ),
        ),
        onSaved: onSave,
        // Add validators if needed
      ),
    );
  }

void _showUpdateDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners for the dialog
        ),
        title: Row(
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.green), // Success icon
            SizedBox(width: 10),
            Text('Success', style: TextStyle(color: Colors.green)), // Customized title
          ],
        ),
        content: Text(
          'User updated successfully.',
          style: TextStyle(color: Colors.black54), // Customized content text
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners for the button
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white), // Text color
            ),
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
