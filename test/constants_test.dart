import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/utils/constants.dart';

void main() {
  group('statusLabel', () {
    test('known statuses', () {
      expect(statusLabel('submitted'), 'Submitted');
      expect(statusLabel('in_progress'), 'In Progress');
      expect(statusLabel('resolved'), 'Resolved');
    });
    test('unknown status falls back to Submitted', () => expect(statusLabel('???'), 'Submitted'));
  });

  group('categoryFor', () {
    test('finds a known category', () => expect(categoryFor('water').label, 'Water'));
    test('unknown key falls back to facilities',
        () => expect(categoryFor('nope').key, 'facilities'));
  });

  group('timeAgo', () {
    test('null means just now', () => expect(timeAgo(null), 'just now'));
    test('minutes', () {
      expect(timeAgo(DateTime.now().subtract(const Duration(minutes: 5))), '5 min ago');
    });
    test('hours', () {
      expect(timeAgo(DateTime.now().subtract(const Duration(hours: 3))), '3 h ago');
    });
    test('days', () {
      expect(timeAgo(DateTime.now().subtract(const Duration(days: 2))), '2 d ago');
    });
  });

  group('formatDateTime', () {
    test('formats month, day and time', () {
      expect(formatDateTime(DateTime(2026, 11, 4, 9, 5)), 'Nov 4, 09:05');
    });
    test('null means just now', () => expect(formatDateTime(null), 'just now'));
  });
}
