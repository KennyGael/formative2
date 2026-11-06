import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// A coloured cover with a big category icon. Shown when a report has no photo.
class CategoryCover extends StatelessWidget {
  final String category;
  final double height;
  final double width;
  final double iconSize;
  final double radius;
  final String? label;

  const CategoryCover({
    super.key,
    required this.category,
    required this.height,
    this.width = double.infinity,
    this.iconSize = 28,
    this.radius = 14,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final icon = categoryFor(category).icon;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: categoryGradient(category),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: [
          Positioned(
            right: -height * 0.12,
            bottom: -height * 0.15,
            child: Icon(icon, size: height * 1.1, color: Colors.white.withValues(alpha: 0.15)),
          ),
          Center(child: Icon(icon, size: iconSize, color: Colors.white)),
          if (label != null)
            Positioned(
              left: 16,
              bottom: 12,
              child: Text(label!,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
        ]),
      ),
    );
  }
}
