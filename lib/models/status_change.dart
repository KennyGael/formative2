import 'package:cloud_firestore/cloud_firestore.dart';

class StatusChange {
  final String status;
  final String changedByName;
  final DateTime? timestamp;

  StatusChange({required this.status, required this.changedByName, this.timestamp});

  factory StatusChange.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return StatusChange(
      status: d['status'] ?? 'submitted',
      changedByName: d['changedByName'] ?? '',
      timestamp: (d['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}
