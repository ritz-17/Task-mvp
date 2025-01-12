import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

List<String> encodeImagesToBase64(List<File?> images) {
  print(images);
  return images
      .where((image) => image != null) // Filter out null values
      .map((image) => base64Encode(image!.readAsBytesSync()))
      .toList();
}

Widget buildTeamSection(
  BuildContext context, {
  required double screenWidth,
  required String title,
  required int activeCount,
  required int freeCount,
  required int unavailableCount,
  required List<TaskData> tasks,
}) {
  return Padding(
    padding: EdgeInsets.all(screenWidth * 0.04),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Row(
          children: [
            buildStatusChip('Active', activeCount, Colors.blue, screenWidth),
            SizedBox(width: screenWidth * 0.02),
            buildStatusChip('Free', freeCount, Colors.green, screenWidth),
            SizedBox(width: screenWidth * 0.02),
            buildStatusChip(
                'Unavailable', unavailableCount, Colors.red, screenWidth),
          ],
        ),
        SizedBox(height: screenWidth * 0.04),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: screenWidth * 0.03),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return buildTaskCard(context, task, screenWidth);
          },
        ),
      ],
    ),
  );
}

Widget buildStatusChip(
    String label, int count, Color color, double screenWidth) {
  return Chip(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    label: Text(
      '$count $label',
      style: TextStyle(
        fontSize: screenWidth * 0.035,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    ),
    backgroundColor: color.withOpacity(0.1),
  );
}

Widget buildTaskCard(BuildContext context, TaskData task, double screenWidth) {
  return Container(
    padding: EdgeInsets.all(screenWidth * 0.03),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(screenWidth * 0.03),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: screenWidth * 0.02,
          offset: Offset(0, screenWidth * 0.01),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: screenWidth * 0.045,
          backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/2815/2815428.png'),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              Text(
                '${task.personName} • ${task.personRole}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              task.time,
              style:
                  TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
            ),
            SizedBox(height: screenWidth * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenWidth * 0.01,
              ),
              decoration: BoxDecoration(
                color: task.statusColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Text(
                task.status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.03,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class TaskData {
  final String title;
  final String personName;
  final String personRole;
  final String status;
  final Color statusColor;
  final String time;

  TaskData({
    required this.title,
    required this.personName,
    required this.personRole,
    required this.status,
    required this.statusColor,
    required this.time,
  });
}

Future<void> pickImage({
  required BuildContext context,
  required int index,
  required List<File?> selectedImages,
  required List<bool> isUploading,
  required Function updateState,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading:
                Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
            title: Text('Take Photo'),
            onTap: () async {
              Navigator.pop(context); // Close the bottom sheet
              await _processImage(
                source: ImageSource.camera,
                context: context,
                index: index,
                selectedImages: selectedImages,
                isUploading: isUploading,
                updateState: updateState,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.photo, color: Theme.of(context).primaryColor),
            title: Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await _processImage(
                source: ImageSource.gallery,
                context: context,
                index: index,
                selectedImages: selectedImages,
                isUploading: isUploading,
                updateState: updateState,
              );
            },
          ),
        ],
      );
    },
  );
}

Future<void> _processImage({
  required ImageSource source,
  required BuildContext context,
  required int index,
  required List<File?> selectedImages,
  required List<bool> isUploading,
  required Function updateState,
}) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      updateState(() {
        isUploading[index] = true; // Start upload animation
      });

      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));

      image = File(pickedImage.path);

      updateState(() {
        selectedImages[index] = image;
        isUploading[index] = false; // End upload animation
      });
    }
  } catch (e) {
    updateState(() {
      isUploading[index] = false; // End upload animation in case of error
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error picking image: ${e.toString()}")),
    );
  }
}
