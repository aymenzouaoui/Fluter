class DailyStats {
  String userId;
  DateTime date;
  int loginCount;
  int timeSpent;

  DailyStats({
    required this.userId,
    required this.date,
    this.loginCount = 0,
    this.timeSpent = 0,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      loginCount: json['loginCount'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'loginCount': loginCount,
      'timeSpent': timeSpent,
    };
  }

  @override
  String toString() {
    return 'DailyStats{userId: $userId, date: $date, loginCount: $loginCount, timeSpent: $timeSpent}';
  }
}
