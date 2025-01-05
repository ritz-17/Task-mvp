class TaskResponse {
  final bool success;
  final String message;
  final List<Task> data;

  TaskResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List).map((item) => Task.fromJson(item)).toList(),
    );
  }
}

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
    );
  }
}

class UserDetail {
  final String id;
  final User user;
  final String dateOfBirth;
  final String address;
  final String? status; // Nullable for createdBy's UserDetail
  final String hireDate;

  UserDetail({
    required this.id,
    required this.user,
    required this.dateOfBirth,
    required this.address,
    this.status,
    required this.hireDate,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['_id'],
      user: User.fromJson(json['user']),
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      status: json['status'],
      hireDate: json['hireDate'],
    );
  }
}

class User {
  final String id;
  final List<dynamic> roles;
  final List<dynamic> permissions;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.roles,
    required this.permissions,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      roles: json['roles'],
      permissions: json['permissions'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      isVerified: json['isVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
