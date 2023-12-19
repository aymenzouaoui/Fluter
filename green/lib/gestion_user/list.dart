import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/gestion_user/UserListTable.dart';
import 'hotel_app_theme.dart';
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

    // Call getData() here to ensure it is called only once
    getData();
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
    body: userList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Row(
            children: [
              Expanded(
                flex: 2, // Adjust flex ratio to control width of the card
                child: _buildStatisticsCard(),
              ),
              Expanded(
                flex: 5, // Adjust flex ratio to control width of the data table
                child: Column(
                  children: [
                    getSearchBarUI(),
                    getFilterBarUI(
                      context: context,
                      title: 'Filter',
                      userList: displayedUsers.isEmpty ? userList : displayedUsers,
                    ),
                    Expanded(
                      child: displayedUsers.isEmpty
                          ? Center(child: Text('No matching users.'))
                          : CustomUserDataTable(
                              displayedUsers: displayedUsers,
                              userBanStatus: userBanStatus,
                              showBanConfirmationDialog: _showBanConfirmationDialog,
                              showBanDurationConfirmationDialog: _showBanDurationConfirmationDialog,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
  );
}

Widget _buildStatisticsCard() {
  // Example statistics calculations
  int totalUsers = userList.length;
  int activeUsers = userList.where((user) => !user['isBanned']).length;
  int bannedUsers = totalUsers - activeUsers;

  return Card(
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('User Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildStatisticItem('Total Users', totalUsers),
          _buildStatisticItem('Active Users', activeUsers),
          _buildStatisticItem('Banned Users', bannedUsers),
          // Add more statistics as needed
        ],
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
        Text(count.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                try {
                  if (isBanned) {
                    await authService.unbanUser(userId);
                  } else {
                    await authService.banUser(userId);
                  }
                  setState(() {
                    userBanStatus[userId] = !isBanned;
                  });
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
// Function to show the confirmation dialog
void _showBanDurationConfirmationDialog(String userName, String userId, String duration) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
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
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
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
              color: HotelAppTheme.buildLightTheme().primaryColor,
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
                    color: HotelAppTheme.buildLightTheme().backgroundColor,
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
              color: HotelAppTheme.buildLightTheme().backgroundColor,
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
          color: HotelAppTheme.buildLightTheme().backgroundColor,
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
                                  HotelAppTheme.buildLightTheme().primaryColor,
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
