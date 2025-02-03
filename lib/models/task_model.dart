import 'user_model.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String jobType;
  final String state;
  final String status;
  final List<UserDetail> assignedTo;
  final UserDetail createdBy;
  final String createdAt;
  final String updatedAt;
  final String priority;
  final List<String>? attachments;
  final String? voice;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.jobType,
    required this.state,
    required this.status,
    required this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.attachments,
    this.voice,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id']?.toString() ?? '', // Ensure it's a String
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      jobType: json['jobType'] ?? 'Unknown',
      state: json['state'] ?? 'Pending',
      status: json['status'] ?? 'Incomplete',
      assignedTo: (json['assignedTo'] as List<dynamic>?)
          ?.map((user) => user != null ? UserDetail.fromJson(user) : UserDetail.empty())
          .toList() ??
          [], // Provide an empty list if null
      createdBy: json['createdBy'] != null && json['createdBy'] is Map<String, dynamic>
          ? UserDetail.fromJson(json['createdBy'])
          : UserDetail.empty(), // Use a default UserDetail if `createdBy` is null
      createdAt: json['createdAt']?.toString() ?? '', // Ensure it's a String
      updatedAt: json['updatedAt']?.toString() ?? '', // Ensure it's a String
      priority: json['priority'] ?? 'Medium',
      attachments: json['attachments'] != null
          ? (json['attachments'] as List<dynamic>).map((e) => e.toString()).toList()
          : [], // Ensure it's an empty list if null
      voice: json['voice']?.toString(), // Convert voice to String, allow null
    );
  }

}
