import 'dart:convert';
import 'package:http/http.dart' as http;
import '../gestion_user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
//aaaaaaaaaaaaaa
class AuthService {
  final String baseUrl = "http://192.168.1.16:9090";

  AuthService();

 Future<Map<String, dynamic>> fetchUserStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/userdailystats/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to fetch user stats. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user stats');
      }
    } catch (error) {
      print('Error fetching user stats: $error');
      throw Exception('Error fetching user stats');
    }
  }


Future<Map<String, dynamic>> getConnectedUsers(String day, {int page = 1, int pageSize = 10}) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/connectedusers/$day?page=$page&pageSize=$pageSize'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract the list of connected users and the total count from the response
      final List<Map<String, dynamic>> connectedUsersInfo =
          List<Map<String, dynamic>>.from(responseData['connectedUsers']);
      final int totalUsersCount = responseData['total'];

      // Return both the connected users info and the total count
      return {
        'connectedUsers': connectedUsersInfo,
        'total': totalUsersCount,
      };
    } else {
      // Handle other errors
      print('Failed to fetch connected users. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch connected users. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching connected users: $error');
    throw Exception('Error fetching connected users: $error');
  }
}

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
          {'email': email, 'password': password, 'userName': username}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);


      if (responseData.containsKey('email') ) {
        final email = responseData['email'];

        return responseData;
      } else {
        print('Invalid responseData format');
        throw Exception('Invalid responseData format');
      }
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
           String? authToken ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjU4NDBjNDI3YTA4NTk1MzM4ZmQ4YWFlIiwicm9sZSI6ImFkbWluIn0sImlhdCI6MTcwMzI5NDU2MywiZXhwIjoxNzAzMjk4MTYzfQ.geFZwqJiV0A42iOFYhbVkurqCdOVSFkMx4hGOpnOkaY";
           // await getSession('token');
      await getSession('token');

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
  Future<Map<String, dynamic>> _fetchUserStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/userdailystats/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to fetch user stats. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user stats');
      }
    } catch (error) {
      print('Error fetching user stats: $error');
      throw Exception('Error fetching user stats');
    }
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
        Uri.parse('$baseUrl/auth/loggeduser'),
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
        // Extract and save the token from the response
        final String token = responseData['token'] as String;
        await saveSession('token', token);
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
      print('aaaaaaaa');
      print(email);
      print(enteredCode);
      final response = await http.post(
        Uri.parse('$baseUrl/admin/verifyResetCode'),
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

  Future<void> banUserWithDuration(
      String userId, String durationInMinutes) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/$userId/banWithDuration'),
      body: {'durationInMinutes': durationInMinutes},
    );

    if (response.statusCode == 200) {
      print('Utilisateur banni avec succès pour une durée définie');
    } else {
      print('Erreur lors du bannissement avec durée : ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getBannedUser() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/admin/getBannedUsers'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> bannedUsers =
            jsonData.cast<Map<String, dynamic>>();
        return bannedUsers;
      } else {
        throw Exception('Failed to load banned users');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load banned users');
    }
  }

  Future<void> newPassword(String email, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/admin/newPassword'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        // Password updated successfully
        print('Password updated successfully for email: $email');
      } else {
        // Handle failure, maybe throw an exception or return an error message
        print('Failed to update password: ${response.statusCode}');
        throw Exception('Failed to update password');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error updating password: $error');
      throw Exception('Failed to update password');
    }
  }

  Future<bool> updateUserById(
      String userId, Map<String, dynamic> updatedData) async {
    String url = '$baseUrl/user/$userId'; // Replace with your actual server URL

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        return true; // Return true on success
      } else {
        print('Failed to update user. Status code: ${response.statusCode}');
        return false; // Return false on non-successful status code
      }
    } catch (e) {
      print('Error occurred while updating user: $e');
      return false; // Return false on exception
    }
  }

Future<Map<String, dynamic>> getUserDailyStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/userdailystats/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to fetch user daily stats. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user daily stats');
      }
    } catch (error) {
      print('Error fetching user daily stats: $error');
      throw Exception('Error fetching user daily stats');
    }
  }

  Future<Map<String, dynamic>> getUserGlobalStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/userglobalstats/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to fetch user global stats. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user global stats');
      }
    } catch (error) {
      print('Error fetching user global stats: $error');
      throw Exception('Error fetching user global stats');
    }
  }
 
}
