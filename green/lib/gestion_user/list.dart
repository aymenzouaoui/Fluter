import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/UserListTable.dart';
import 'package:flutter_login_register_ui/gestion_user/pagination.dart';
import 'package:flutter_login_register_ui/gestion_user/user_app_theme.dart';

import '/gestion_user/calendar_popup_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '/services/auth_service.dart';
import 'filters_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with TickerProviderStateMixin {
  String? selectedUserId;

  int currentPage = 1;
  int pageSize = 6; // Number of items per page
  List<Map<String, dynamic>> allUsers = []; // All users fetched from the server
  List<Map<String, dynamic>> usersToShow =
      []; // Users to show on the current page

  late final AuthService authService;
  AnimationController? animationController;
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> displayedUsers = [];
  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  Map<String, bool> userBanStatus =
      {}; // Map to store the ban status for each user

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize the authService here
    authService = AuthService();

    // Fetch all users and set initial page
    authService.getAllUsers().then((fetchedUsers) {
      setState(() {
        allUsers = fetchedUsers;
        userList = fetchedUsers;
        userBanStatus = Map.fromIterable(
          fetchedUsers,
          key: (user) => user['id'].toString(),
          value: (user) => user['isBanned'] ?? false,
        );
        displayedUsers = fetchedUsers;
        setPage(1); // Set initial page
      });
    });
  }

  Future<bool> getData() async {
    try {
      List<Map<String, dynamic>> users = await authService.getAllUsers();
      print('Users: $users');
      await Future<dynamic>.delayed(const Duration(milliseconds: 200));

      // Initialize userBanStatus with the ban status for each user
      Map<String, bool> initialUserBanStatus = Map.fromIterable(
        users,
        key: (user) => user['id'].toString(),
        value: (user) => user['isBanned'] ?? false,
      );

      setState(() {
        userList = users;
        userBanStatus = initialUserBanStatus;
        displayedUsers =
            users; // Initialize displayedUsers with all users initially
      });

      return true;
    } catch (error) {
      print('Error fetching users: $error');
      return false;
    }
  }

  void searchUsers(String query) {
    setState(() {
      displayedUsers = userList
          .where((user) =>
              user['userName'] != null &&
              user['userName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatisticsCard(),
                  _buildConnectedUsersCard(), // Positioned right below the statistics card
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                getSearchBarUI(),
                // Uncomment the line below if you want to include the filter bar
                getFilterBarUI(
                    context: context,
                    title: 'User List',
                    userList: displayedUsers),
                Expanded(
                  child: CustomUserDataTable(
                    displayedUsers: displayedUsers,
                    userBanStatus: userBanStatus,
                    showBanConfirmationDialog: _showBanConfirmationDialog,
                    showBanDurationConfirmationDialog:
                        _showBanDurationConfirmationDialog,
                  ),
                ),
                PaginationWidget(
                  currentPage: currentPage,
                  pageSize: pageSize,
                  totalItems: allUsers.length,
                  onPageChanged: setPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    // Example statistics calculations for all users
    int totalUsers = userList.length;
    int activeUsers = userList.where((user) => !user['isBanned']).length;
    int bannedUsers = totalUsers - activeUsers;

    // Fetch the selected user's data using the selectedUserId
    final selectedUser = userList.firstWhere(
      (user) => user['id'] == selectedUserId,
      orElse: () => <String, dynamic>{}, // Provide a default empty map
    );

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('User Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildStatisticItem('Total Users', totalUsers),
            _buildStatisticItem('Active Users', activeUsers),
            _buildStatisticItem('Banned Users', bannedUsers),
            // Add more statistics as needed
            SizedBox(height: 20),
            if (selectedUser.isNotEmpty)
              Column(
                children: [
                  Text('Selected User Statistics',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildStatisticItem(
                      'Login Count', selectedUser['loginCount'] ?? 'N/A'),
                  _buildStatisticItem('Total Time Spent',
                      selectedUser['totalTimeSpent'] ?? 'N/A'),
                  // Add more statistics for the selected user here
                ],
              ),
          ],
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  int connectedUsersCurrentPage = 1;
  int connectedUsersPageSize = 2; // Number of items per page

  Widget _buildConnectedUsersCard() {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Connected Users',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: authService.getConnectedUsers(
                selectedDate.toString(),
                page: connectedUsersCurrentPage,
                pageSize: connectedUsersPageSize,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
                  List<Map<String, dynamic>> connectedUsers = data['connectedUsers'];
                  int totalItems = data['total'];

                  return Column(
                    children: [
                      ...connectedUsers.map((user) {
                        return Card(
                          child: ListTile(
                            title: Text(user['email'] ?? 'Unknown'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time Connected: ${user['timeConnected'] ?? 'N/A'}',
                                ),
                                Text(
                                  'Login Count: ${user['loginCount']?.toString() ?? 'N/A'}',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      PaginationWidget(
                        currentPage: connectedUsersCurrentPage,
                        pageSize: connectedUsersPageSize,
                        totalItems: totalItems,
                        onPageChanged: (int page) {
                          setState(() {
                            connectedUsersCurrentPage = page;
                          });
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildStatisticItem(String title, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(count.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showBanConfirmationDialog(
      String userName, String userId, bool isBanned) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text('Confirm Action'),
          content: Text(
              'Are you sure you want to ${isBanned ? 'unban' : 'ban'} $userName?'),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                bool success = false;
                try {
                  if (isBanned) {
                    await authService.unbanUser(userId);
                    success = true;
                  } else {
                    await authService.banUser(userId);
                    success = true;
                  }
                  // Update userList and userBanStatus immediately
                  List<Map<String, dynamic>> updatedUsers =
                      await authService.getAllUsers();
                  Map<String, bool> updatedUserBanStatus = Map.fromIterable(
                    updatedUsers,
                    key: (user) => user['id'].toString(),
                    value: (user) => user['isBanned'] ?? false,
                  );
                  setState(() {
                    userList = updatedUsers;
                    userBanStatus = updatedUserBanStatus;
                    refreshUserData();
                  });
                  refreshUserData();
                  // Optional: Show a snackbar or another dialog to confirm the action
                } catch (error) {
                  // Handle error, e.g., show a snackbar or log the error
                  print('Error: $error');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> refreshUserData() async {
    try {
      List<Map<String, dynamic>> updatedUsers = await authService.getAllUsers();
      setState(() {
        allUsers = updatedUsers;
        setPage(currentPage); // Maintain the current page but refresh the users
      });
    } catch (error) {
      print('Error refreshing user data: $error');
    }
  }

  void setPage(int pageNumber) {
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = min(startIndex + pageSize, allUsers.length);
    setState(() {
      currentPage = pageNumber;
      displayedUsers = allUsers.sublist(startIndex, endIndex);
      userList = allUsers; // Keep track of all users
      // userBanStatus remains unchanged as it's initialized once
      userBanStatus = {
        for (var user in allUsers)
          user['id'].toString(): user['isBanned'] ?? false
      };
    });
  }

// Function to show the confirmation dialog
  void _showBanDurationConfirmationDialog(
      String userName, String userId, String duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Confirm Ban Duration'),
          content: Text('Ban $userName for $duration?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await authService.banUserWithDuration(userId, duration);
                  print('Banned $userName for $duration');
                  // Handle additional logic after confirmation
                } catch (error) {
                  print('Error: $error');
                  // Handle error
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: UserAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 4,
                  ),
                  child: TextField(
                    onChanged: (String txt) {
                      searchUsers(txt);
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: UserAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'userName...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: UserAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    FontAwesomeIcons.search,
                    size: 20,
                    color: UserAppTheme.buildLightTheme().backgroundColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> userList,
  }) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: UserAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, -2),
                  blurRadius: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          color: UserAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 4,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${userList.length} User found',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => FiltersScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.sort,
                              color:
                                  UserAppTheme.buildLightTheme().primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedUserStatisticsCard() {
    // Fetch the selected user's data using the selectedUserId
    final selectedUser = userList.firstWhere(
        (user) => user['id'] == selectedUserId,
        orElse: () => <String, dynamic>{} // Provide a default empty map
        );

    // Check if the selected user has data before building the stats card
    if (selectedUser.isEmpty) {
      return SizedBox
          .shrink(); // If no user is selected or the user data is empty, show nothing.
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selected User Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                'Login Count: ${selectedUser['loginCount'] ?? 'N/A'}'), // Use 'N/A' if loginCount is null
            Text(
                'Total Time Spent: ${selectedUser['totalTimeSpent'] ?? 'N/A'}'), // Use 'N/A' if totalTimeSpent is null
            // Add more statistics for the selected user here
          ],
        ),
      ),
    );
  }

  void _onUserSelected(String userId) {
    setState(() {
      selectedUserId = userId;
    });
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
