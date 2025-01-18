import 'user_model.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String jobType;
  final String state;
  final String status;
  final UserDetail assignedTo;
  final UserDetail createdBy;
  final String createdAt;
  final String updatedAt;
  final String priority;
  final List<String> attachments;
  final String voice;

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
    required this.priority, // New field
    required this.attachments, // New field
    required this.voice, // New field
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      jobType: json['jobType'],
      state: json['state'],
      status: json['status'],
      assignedTo: UserDetail.fromJson(json['assignedTo']),
      createdBy: UserDetail.fromJson(json['createdBy']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      priority: json['priority'],
      attachments: List<String>.from(json['attachments']),
      voice: json['voice'],
    );
  }
}