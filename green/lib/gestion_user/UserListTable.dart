import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomUserDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> displayedUsers;
  final Map<String, bool> userBanStatus;
  final Function(String, String, bool) showBanConfirmationDialog;
  final Function(String, String, String) showBanDurationConfirmationDialog;
  

  CustomUserDataTable({
    Key? key,
    required this.displayedUsers,
    required this.userBanStatus,
    required this.showBanConfirmationDialog,
    required this.showBanDurationConfirmationDialog,
  }) : super(key: key);

  @override
  _CustomUserDataTableState createState() => _CustomUserDataTableState();
}

class _CustomUserDataTableState extends State<CustomUserDataTable> {
  String selectedUserId="6584609a3959af824734f76f";

  int? sortColumnIndex;
  
  bool isAscending = true;
  final String baseUrl = "http://192.168.1.16:9090";

  final Map<String, Future<Map<String, dynamic>>> _userStatsCache = {};

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    if (!_userStatsCache.containsKey(userId)) {
      _userStatsCache[userId] = _fetchUserStats(userId);
    }
    return _userStatsCache[userId]!;
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

  Widget buildActions(
      Map<String, dynamic> userData, String userId, bool isBanned) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => widget.showBanConfirmationDialog(
              userData['userName'], userId, isBanned),
          icon: Icon(isBanned ? Icons.undo : Icons.block, size: 14),
          label:
              Text(isBanned ? 'Unban' : 'Ban', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            primary: isBanned ? Colors.green : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => widget.showBanDurationConfirmationDialog(
              userData['userName'], userId, value),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(value: '4320', child: Text('Ban for 3 days')),
            PopupMenuItem<String>(value: '1440', child: Text('Ban for 1 day')),
            PopupMenuItem<String>(
                value: '10080', child: Text('Ban for 1 week')),
          ],
          icon: Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Map<String, bool> loginCountActive = {};
  Widget buildLoginCount(String userId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserStats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userStats = snapshot.data ?? {};
          final loginCount = userStats['loginCount'] ?? 0;
          double loginCountPercentage = loginCount / 30;

          return MouseRegion(
            onEnter: (_) {
              Fluttertoast.showToast(
                msg: "Login Count: $loginCount",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text('Login Count'),
                Slider(
                  value: loginCountPercentage,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    // Handle the onChanged event if needed
                  },
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildTotalTimeSpent(String userId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserStats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userStats = snapshot.data ?? {};
          final totalTimeSpent = userStats['timeSpent'] ?? 0;
          final totalTimeSpentPercentage = totalTimeSpent /
              (24 *
                  60 *
                  60); // Adaptez cette formule selon votre logique métier

          return MouseRegion(
            onEnter: (_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Fermer automatiquement après 4 secondes
                  Timer(Duration(seconds: 4), () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  });

                  return AlertDialog(
                    title: Text('Total Time Spent'),
                    content: TweenAnimationBuilder(
                      duration: Duration(seconds: 1),
                      tween: Tween<double>(
                          begin: 0, end: totalTimeSpentPercentage),
                      builder: (context, double value, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              backgroundColor: Colors.grey,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            SizedBox(height: 20),
                            Text(
                                '${(value * totalTimeSpent).toStringAsFixed(0)} seconds'),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    value: totalTimeSpentPercentage,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded( // Use Expanded to ensure the table doesn't take infinite height
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            sortColumnIndex: sortColumnIndex,
            sortAscending: isAscending,
            columnSpacing: 20.0,
            columns: <DataColumn>[
             // DataColumn(label: Text('Index')),
              DataColumn(label: Text('Image')),
            DataColumn(
              label: Text('Name'),
              numeric: false,
              onSort: (columnIndex, _) {
                sortData(
                    columnIndex, (user) => '${user['nom']} ${user['prenom']}');
              },
            ),
            DataColumn(
              label: Text('Username'),
              numeric: false,
              onSort: (columnIndex, _) {
                sortData(columnIndex, (user) => user['userName']);
              },
            ),
            DataColumn(
              label: Text('Email'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Role'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Actions'),
              numeric: false,
            ),
            /*
            DataColumn(
              label: Text('Login Count'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Total Time Spent'),
              numeric: false,
            ),*/
          ],
         rows: widget.displayedUsers.asMap().entries.map<DataRow>((entry) {
              final int index = entry.key + 1;
              final Map<String, dynamic> userData = entry.value;
              final String userId = userData['id'];
              final bool isBanned = widget.userBanStatus[userId] ?? false;

              return DataRow(
                onSelectChanged: (bool? selected) {
                  if (selected == true) {
                    setState(() {
                      selectedUserId = userId; // Set the selectedUserId state
                    });
                  }
                },
              cells: <DataCell>[
                //DataCell(Text('$index')),
                DataCell(CircleAvatar(
                  backgroundImage: NetworkImage(userData['imageRes']),
                  radius: 20,
                )),
                DataCell(Text('${userData['nom']} ${userData['prenom']}')),
                DataCell(Text(userData['userName'])),
                DataCell(Text(userData['email'])),
                DataCell(Text(userData['role'])),
                DataCell(buildActions(userData, userId, isBanned)),
               // DataCell(buildLoginCount(userId)),
                //DataCell(buildTotalTimeSpent(userId)),
              ],
            );
          }).toList(),
          ),
        ),
        ),
        if (selectedUserId != null) buildUserInfoCard(selectedUserId!), // Display the user info card if a user is selected
      ],
    );
  }
  

  Widget buildUserInfoCard(String userId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserStats(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        } else {
          final userStats = snapshot.data!;
          final loginCount = userStats['loginCount'] ?? 'N/A';
          final timeSpent = userStats['timeSpent'] ?? 'N/A'; // Time spent in seconds

          // Convert timeSpent to a more readable format if necessary

          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Login Count'),
                      buildLoginCount(userId),
                      Text('$loginCount'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Time Spent'),
                      buildTotalTimeSpent(userId),
                      Text('$timeSpent seconds'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void sortData(int columnIndex,
      Comparable<dynamic> Function(Map<String, dynamic> user) getField) {
    setState(() {
      sortColumnIndex = columnIndex;
      if (isAscending) {
        widget.displayedUsers
            .sort((a, b) => getField(a).compareTo(getField(b)));
      } else {
        widget.displayedUsers
            .sort((a, b) => getField(b).compareTo(getField(a)));
      }
      isAscending = !isAscending;
    });
  }
}
