import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts a normal email', () => expect(Validators.email('k@alu.com'), isNull));
    test('rejects missing @', () => expect(Validators.email('kalu.com'), isNotNull));
    test('rejects empty', () => expect(Validators.email(''), isNotNull));
    test('ignores surrounding spaces', () => expect(Validators.email(' k@alu.com '), isNull));
  });

  group('Validators.password', () {
    test('rejects short passwords', () => expect(Validators.password('12345'), isNotNull));
    test('accepts 6+ characters', () => expect(Validators.password('123456'), isNull));
  });

  group('Validators.name', () {
    test('rejects empty', () => expect(Validators.name('  '), isNotNull));
    test('accepts a name', () => expect(Validators.name('Kenny'), isNull));
  });

  group('Validators.confirm', () {
    test('rejects a mismatch', () => expect(Validators.confirm('abc123', 'abc124'), isNotNull));
    test('accepts a match', () => expect(Validators.confirm('abc123', 'abc123'), isNull));
    test('rejects empty', () => expect(Validators.confirm('', 'abc123'), isNotNull));
  });
}
