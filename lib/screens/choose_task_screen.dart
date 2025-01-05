import 'package:flutter/material.dart';

void ChooseTask(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Task Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.access_alarm),
              title: Text('Short Task'),
              onTap: () {
                Navigator.pushNamed(context, '/createShortTask');
                // Handle Short Task action
              },
            ),
            ListTile(
              leading: Icon(Icons.hourglass_bottom),
              title: Text('Long Task'),
              onTap: () {
                Navigator.pushNamed(context, '/createTask');
                // Handle Long Task action
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}