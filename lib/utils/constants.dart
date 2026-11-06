import 'package:flutter/material.dart';

class IncidentCategory {
  final String key;
  final String label;
  final IconData icon;
  const IncidentCategory(this.key, this.label, this.icon);
}

const incidentCategories = [
  IncidentCategory('facilities', 'Facilities', Icons.apartment),
  IncidentCategory('water', 'Water', Icons.water_drop_outlined),
  IncidentCategory('electricity', 'Electricity', Icons.bolt),
  IncidentCategory('safety', 'Safety', Icons.shield_outlined),
  IncidentCategory('sanitation', 'Sanitation', Icons.delete_outline),
];

IncidentCategory categoryFor(String key) =>
    incidentCategories.firstWhere((c) => c.key == key, orElse: () => incidentCategories.first);

const statuses = ['submitted', 'in_progress', 'resolved'];

String statusLabel(String s) => switch (s) {
      'in_progress' => 'In Progress',
      'resolved' => 'Resolved',
      _ => 'Submitted',
    };

Color statusColor(String s) => switch (s) {
      'in_progress' => const Color(0xFF1E88E5),
      'resolved' => const Color(0xFF2E9E5B),
      _ => const Color(0xFFD99100),
    };

String timeAgo(DateTime? t) {
  if (t == null) return 'just now';
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'just now';
  if (d.inHours < 1) return '${d.inMinutes} min ago';
  if (d.inDays < 1) return '${d.inHours} h ago';
  return '${d.inDays} d ago';
}

String formatDateTime(DateTime? t) {
  if (t == null) return 'just now';
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '${months[t.month - 1]} ${t.day}, $h:$m';
}

/// App palette: emerald green + warm coral on a soft mint-white background.
class AppColors {
  static const primary = Color(0xFF0B8F63); // emerald
  static const accent = Color(0xFF3DDC97); // bright mint (gradient end)
  static const coral = Color(0xFFFF7A59); // buttons / highlights
  static const background = Color(0xFFF5FBF8); // soft mint-white
  static const avatarBlue = Color(0xFF1E88E5); // kept blue for the "K" avatar
}

/// Two-colour gradient for each category (covers, tiles and selectors).
List<Color> categoryGradient(String key) => switch (key) {
      'water' => const [Color(0xFF4FC3F7), Color(0xFF0288D1)], // sky blue
      'electricity' => const [Color(0xFFFFCA28), Color(0xFFFB8C00)], // amber
      'safety' => const [Color(0xFFFF8A65), Color(0xFFE64A19)], // coral red
      'sanitation' => const [Color(0xFFB388FF), Color(0xFF7C4DFF)], // violet
      _ => const [Color(0xFF7986CB), Color(0xFF3949AB)], // indigo (facilities)
    };
