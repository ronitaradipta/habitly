class User {
  final String email;
  final String fullName;
  final String mobile;
  final String gender;
  final DateTime loggedInAt;
  final bool hasCompletedOnboarding;

  const User({
    required this.email,
    required this.loggedInAt,
    this.fullName = '',
    this.mobile = '',
    this.gender = '',
    this.hasCompletedOnboarding = false,
  });

  User copyWith({
    String? email,
    String? fullName,
    String? mobile,
    String? gender,
    DateTime? loggedInAt,
    bool? hasCompletedOnboarding,
  }) {
    return User(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      loggedInAt: loggedInAt ?? this.loggedInAt,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
