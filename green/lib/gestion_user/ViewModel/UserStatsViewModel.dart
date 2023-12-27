import 'package:flutter/foundation.dart';
import 'package:flutter_login_register_ui/services/auth_service.dart';

/*
class UserStatsViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Map<String, dynamic> _userDailyStats = {};
  Map<String, dynamic> _allUsersGlobalStats = {};

  Map<String, dynamic> get userDailyStats => _userDailyStats;
  Map<String, dynamic> get allUsersGlobalStats => _allUsersGlobalStats;

  Future<void> fetchUserDailyStats(String userId, DateTime date) async {
    try {
      final userDailyStats = await _authService.getUserDailyStats(userId, date);
      _userDailyStats = userDailyStats;
      notifyListeners();
    } catch (error) {
      // Handle error as needed
      print('Error fetching user daily stats: $error');
    }
  }

  Future<void> fetchAllUsersGlobalStats() async {
    try {
      final allUsersGlobalStats = await _authService.getAllUsersGlobalStats();
      _allUsersGlobalStats = allUsersGlobalStats;
      notifyListeners();
    } catch (error) {
      // Handle error as needed
      print('Error fetching all users global stats: $error');
    }
  }
}
*/