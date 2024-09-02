import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final int memberCount;
  final VoidCallback onTap;

  const GroupTile({
    required this.groupName,
    required this.memberCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(Icons.group, color: Colors.blue),
        title: Text(
          groupName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Membros: $memberCount',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
