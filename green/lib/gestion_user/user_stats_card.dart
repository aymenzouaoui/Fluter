// user_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/services/StatsService.dart';


class UserStatsCard extends StatefulWidget {
  final String userId;
  final String token;

  const UserStatsCard({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  _UserStatsCardState createState() => _UserStatsCardState();
}

class _UserStatsCardState extends State<UserStatsCard> {
  Map<String, dynamic>? userStats;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final stats = await StatsService().getUserStats(widget.userId, widget.token);
      setState(() {
        userStats = stats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingCard();
    }

    if (error != null) {
      return _buildErrorCard();
    }

    return _buildStatsCard();
  }

  Widget _buildLoadingCard() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Error loading stats: $error'),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${userStats!['userName']} Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Login Count: ${userStats!['loginCount']}'),
            Text('Time Spent: ${userStats!['timeSpent']}'),
            // Ajoutez ici d'autres informations statistiques
          ],
        ),
      ),
    );
  }
}
