import 'package:habitly/domain/entities/user.dart';

class UserModel {
  final String email;
  final String fullName;
  final String mobile;
  final String gender;
  final DateTime loggedInAt;
  final bool hasCompletedOnboarding;

  const UserModel({
    required this.email,
    required this.loggedInAt,
    this.fullName = '',
    this.mobile = '',
    this.gender = '',
    this.hasCompletedOnboarding = false,
  });

  User toEntity() => User(
    email: email,
    fullName: fullName,
    mobile: mobile,
    gender: gender,
    loggedInAt: loggedInAt,
    hasCompletedOnboarding: hasCompletedOnboarding,
  );

  factory UserModel.fromEntity(User user) => UserModel(
    email: user.email,
    fullName: user.fullName,
    mobile: user.mobile,
    gender: user.gender,
    loggedInAt: user.loggedInAt,
    hasCompletedOnboarding: user.hasCompletedOnboarding,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'fullName': fullName,
    'mobile': mobile,
    'gender': gender,
    'loggedInAt': loggedInAt.toIso8601String(),
    'hasCompletedOnboarding': hasCompletedOnboarding,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'] as String,
    fullName: json['fullName'] as String? ?? '',
    mobile: json['mobile'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    loggedInAt: DateTime.parse(json['loggedInAt'] as String),
    hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
  );
}
