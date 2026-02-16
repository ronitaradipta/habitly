import 'package:habitly/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      email: data?['email'] as String? ?? '',
      fullName: data?['fullName'] as String? ?? '',
      mobile: data?['mobile'] as String? ?? '',
      gender: data?['gender'] as String? ?? '',
      loggedInAt:
          (data?['loggedInAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      hasCompletedOnboarding: data?['hasCompletedOnboarding'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email.isNotEmpty) 'email': email,
      'loggedInAt': Timestamp.fromDate(loggedInAt),
      if (fullName.isNotEmpty) 'fullName': fullName,
      if (mobile.isNotEmpty) 'mobile': mobile,
      if (gender.isNotEmpty) 'gender': gender,
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }
}
