import 'package:equatable/equatable.dart';

/// Represents a User's profile information.
/// Uses Equatable for easy object comparison.
class UserProfile extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl; // Nullable field
  final String countryCode;
  final bool isProfilePublic;

  const UserProfile({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.countryCode,
    required this.isProfilePublic,
  });

  @override
  // Props list used by Equatable to determine equality.
  List<Object?> get props => [
    userId,
    displayName,
    avatarUrl,
    countryCode,
    isProfilePublic,
  ];
}
