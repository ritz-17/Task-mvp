import 'package:flutter/material.dart';

void ChooseTask(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Task Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: screenHeight * 0.02),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/createShortTask');
              },
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                leading: Icon(
                  Icons.access_alarm,
                  color: Colors.blueAccent,
                  size: screenHeight * 0.035,
                ),
                title: Text(
                  'Short Task',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/createLongTask');
              },
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                leading: Icon(
                  Icons.hourglass_bottom,
                  color: Colors.green,
                  size: screenHeight * 0.035,
                ),
                title: Text(
                  'Long Task',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      );
    },
  );
}
