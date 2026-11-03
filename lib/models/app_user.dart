class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' or 'staff'

  AppUser({required this.uid, required this.name, required this.email, required this.role});

  bool get isStaff => role == 'staff';

  factory AppUser.fromMap(String uid, Map<String, dynamic> d) => AppUser(
        uid: uid,
        name: d['name'] ?? '',
        email: d['email'] ?? '',
        role: d['role'] ?? 'student',
      );
}
