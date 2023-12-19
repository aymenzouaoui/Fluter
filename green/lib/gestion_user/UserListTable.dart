import 'package:flutter/material.dart';

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
  int? sortColumnIndex;
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black), // Black border around the table
        ),
        child: DataTable(
          sortColumnIndex: sortColumnIndex,
          sortAscending: isAscending,
          columns: <DataColumn>[
            DataColumn(label: Text('Image')),
            DataColumn(
              label: Text('Name'),
              onSort: (columnIndex, _) {
                sortData(columnIndex, (user) => '${user['nom']} ${user['prenom']}');
              },
            ),
            DataColumn(
              label: Text('Username'),
              onSort: (columnIndex, _) {
                sortData(columnIndex, (user) => user['userName']);
              },
            ),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Actions')),
          ],
          rows: widget.displayedUsers.map<DataRow>((userData) {
            final userId = userData['id'];
            final isBanned = widget.userBanStatus[userId] ?? false;

            return DataRow(
              cells: <DataCell>[
                DataCell(CircleAvatar(
                  backgroundImage: NetworkImage(userData['imageRes']),
                  radius: 20,
                )),
                DataCell(Text('${userData['nom']} ${userData['prenom']}')),
                DataCell(Text(userData['userName'])),
                DataCell(Text(userData['email'])),
                DataCell(Text(userData['role'])),
                DataCell(buildActions(userData, userId, isBanned)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void sortData(int columnIndex, Comparable<dynamic> Function(Map<String, dynamic> user) getField) {
    setState(() {
      sortColumnIndex = columnIndex;

      if (isAscending) {
        widget.displayedUsers.sort((a, b) => getField(a).compareTo(getField(b)));
      } else {
        widget.displayedUsers.sort((a, b) => getField(b).compareTo(getField(a)));
      }
      isAscending = !isAscending;
    });
  }

  Widget buildActions(Map<String, dynamic> userData, String userId, bool isBanned) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => widget.showBanConfirmationDialog(
              userData['userName'], userId, isBanned),
          icon: Icon(isBanned ? Icons.undo : Icons.block, size: 14),
          label: Text(isBanned ? 'Unban' : 'Ban', style: TextStyle(fontSize: 12)),
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
            PopupMenuItem<String>(value: '10080', child: Text('Ban for 1 week')),
          ],
          icon: Icon(Icons.more_vert),
        ),
      ],
    );
  }
}