import 'dart:convert';
import 'package:http/http.dart' as http;

class StatsService {
  final String baseUrl = "http://192.168.1.16:9090/auth";

  StatsService();

  // Récupère les statistiques quotidiennes et globales d'un utilisateur spécifique
  Future<Map<String, dynamic>> getUserStats(String userId, String token) async {
    final url = Uri.parse('$baseUrl/userstats/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user stats, status code: ${response.statusCode}');
    }
  }

  // Récupère les statistiques globales de tous les utilisateurs
  Future<Map<String, dynamic>> getAllUsersStats(String token) async {
    final url = Uri.parse('$baseUrl/allusersstats');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load all users stats, status code: ${response.statusCode}');
    }
  }
}
