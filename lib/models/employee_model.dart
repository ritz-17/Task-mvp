class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isVerified;
  final String dateOfBirth;
  final String address;
  final String status;
  final String hireDate;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isVerified,
    required this.dateOfBirth,
    required this.address,
    required this.status,
    required this.hireDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      email: json['user']['email'],
      phone: json['user']['phone'],
      isVerified: json['user']['isVerified'],
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      status: json['status'],
      hireDate: json['hireDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'isVerified': isVerified,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'status': status,
      'hireDate': hireDate,
    };
  }
}
