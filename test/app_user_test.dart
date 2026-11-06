import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/models/app_user.dart';

void main() {
  group('AppUser', () {
    test('staff role is recognised', () {
      final user = AppUser.fromMap('1', {'name': 'Amina', 'email': 'a@b.com', 'role': 'staff'});
      expect(user.isStaff, isTrue);
    });

    test('a missing role defaults to student', () {
      final user = AppUser.fromMap('1', {'name': 'Amina', 'email': 'a@b.com'});
      expect(user.role, 'student');
      expect(user.isStaff, isFalse);
    });

    test('role is trimmed and lower-cased', () {
      final user = AppUser.fromMap('1', {'role': ' Staff '});
      expect(user.isStaff, isTrue);
    });

    test('missing name and email become empty strings', () {
      final user = AppUser.fromMap('1', {});
      expect(user.name, '');
      expect(user.email, '');
    });
  });
}
