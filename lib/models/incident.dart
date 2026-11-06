import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final String category; // facilities, water, electricity, safety, sanitation
  final String location;
  final String status; // submitted, in_progress, resolved
  final String? imageUrl;
  final String reportedBy;
  final String reporterName;
  final DateTime? createdAt;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    this.imageUrl,
    required this.reportedBy,
    required this.reporterName,
    this.createdAt,
  });

  factory Incident.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Incident(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      category: d['category'] ?? 'facilities',
      location: d['location'] ?? '',
      status: d['status'] ?? 'submitted',
      imageUrl: d['imageUrl'],
      reportedBy: d['reportedBy'] ?? '',
      reporterName: d['reporterName'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
