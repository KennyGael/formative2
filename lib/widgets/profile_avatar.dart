import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Blue circle with the user's first initial and a blue-to-teal ring.
class ProfileAvatar extends StatelessWidget {
  final String name;
  final double radius;
  const ProfileAvatar({super.key, required this.name, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Container(
      padding: EdgeInsets.all(radius * 0.09),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.avatarBlue,
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.95,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
