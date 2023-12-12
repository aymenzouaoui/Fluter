import 'dart:convert';
import 'package:http/http.dart' as http;
import '../gestion_user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl="http://192.168.1.16:9090";

  AuthService();
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/loginiios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('user') &&
            responseData.containsKey('token')) {
          final user = responseData['user'];
          final token = responseData['token'];

          // Sauvegarder le token localement
          await saveSession('token', token);

          return responseData;
        } else {
          print('Invalid responseData format');
          throw Exception('Invalid responseData format');
        }
      } else if (response.statusCode == 401) {
        // Handle invalid credentials
        print('Invalid credentials');
        throw Exception('Invalid credentials');
      } else {
        // Handle other errors
        print('Failed to login. Status code: ${response.statusCode}');
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during login: $error');
      throw Exception('Error during login: $error');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String email, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'email': email, 'password': password, 'username': username}),
    );

    if (response.statusCode == 200) {
      // Registration successful, parse the response
      return jsonDecode(response.body);
    } else {
      // Registration failed, handle the error
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> logoutUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Logout successful, parse the response
      return jsonDecode(response.body);
    } else {
      // Logout failed, handle the error
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String id,
      String email,
      String nom,
      String prenom,
      String adress,
      String cin,
      String userName,
      String imageRes) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/user/$id'), // Use the appropriate endpoint for updating user by ID
      headers: {
        'Content-Type': 'application/json',
        // Add any other headers, such as authorization if needed
      },
      body: jsonEncode({
        'email': email,
        'nom': nom,
        'prenom': prenom,
        'adress': adress,
        'cin': cin,
        'userName': userName,
        'imageRes': imageRes,
      }),
    );

    if (response.statusCode == 200) {
      // Update successful, parse the response
      return jsonDecode(response.body);
    } else {
      // Update failed, handle the error
      throw Exception('Failed to update user');
    }
  }

  Future<http.Response> uploadImageToCloudinary(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/upload-image-to-cloudinary'), // Replace with your server endpoint
        body: {'imageUrl': imageUrl},
      );

      return response;
    } catch (error) {
      throw Exception('Error uploading image to Cloudinary: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      // Retrieve the authentication token from SharedPreferences
      String? authToken = await getSession('token');

      if (authToken == null) {
        // Token not found, handle the error
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Include the authentication token
        },
      );

      if (response.statusCode == 200) {
        // Fetch successful, parse the response
        List<dynamic> userList = jsonDecode(response.body);

        // Convert the list to a list of maps
        List<Map<String, dynamic>> users =
            userList.map((user) => Map<String, dynamic>.from(user)).toList();

        return users;
      } else {
        // Fetch failed, handle the error
        throw Exception('Failed to fetch users');
      }
    } catch (error) {
      throw Exception('Error fetching users: $error');
    }
  }

  Future<void> saveSession(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getSession(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<User?> getLoggedInUser() async {
    try {
      // Récupérer le token d'authentification depuis SharedPreferences
      String? authToken = await getSession('token');

      if (authToken == null) {
        // Token non trouvé, gérer l'erreur
        print('Token d\'authentification non trouvé');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.16:9090/auth/loggeduser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userJson = jsonDecode(response.body);
        print(response.body);
        // Créer un objet User
        User user = User.fromJson(userJson);

        // Afficher les champs individuels de l'objet User
        print('User Connected:');
        print('ID: ${user.id}');
        print('Email: ${user.email}');
        print('Nom: ${user.nom}');
        print('Prenom: ${user.prenom}');
        // Ajouter d'autres champs si nécessaire

        return user;
      } else {
        // Gérer la réponse d'erreur
        print(
            'Échec de la récupération des données de l\'utilisateur. Code d\'état : ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Gérer les erreurs réseau ou autres
      print(
          'Erreur lors de la récupération des données de l\'utilisateur : $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> sendResetCode(String email) async {
    print("aaaaaaaaaaaaa");
    
    
    print(email);
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/user/sendResetCode'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Successful reset code sent, parse the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle failure, maybe throw an exception or return an error message
        throw Exception('Failed to send reset code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error sending reset code: $error');
      throw Exception('Failed to send reset code');
    }
  }

 Future<bool> verifyResetCode(String email, String enteredCode) async {
  try {
    final response = await http.post(
      Uri.parse('your_base_url/user/verifyResetCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'resetCode': enteredCode}),
    );

    if (response.statusCode == 200) {
      // Server returned success, reset code is valid
      return true;
    } else {
      // Reset code is not valid
      return false;
    }
  } catch (error) {
    // Handle network errors or other exceptions
    print('Error verifying reset code: $error');
    throw Exception('Failed to verify reset code');
  }
}

Future<void> banUser(String userId) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/$userId/ban'),
  );

  if (response.statusCode == 200) {
    print('Utilisateur banni avec succès');
  } else {
    print('Erreur lors du bannissement : ${response.statusCode}');
  }
}

Future<void> unbanUser(String userId) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/$userId/unban'),
  );

  if (response.statusCode == 200) {
    print('Utilisateur débanni avec succès');
  } else {
    print('Erreur lors du débannissement : ${response.statusCode}');
  }
}

Future<void> banUserWithDuration(String userId, int durationInMinutes) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/$userId/banWithDuration'),
    body: {'durationInMinutes': durationInMinutes.toString()},
  );

  if (response.statusCode == 200) {
    print('Utilisateur banni avec succès pour une durée définie');
  } else {
    print('Erreur lors du bannissement avec durée : ${response.statusCode}');
  }
}


}
