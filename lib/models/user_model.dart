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
  factory UserDetail.empty() {
    return UserDetail(id: '', user: User.fromJson({}), dateOfBirth: '', address: '', hireDate: '');
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
