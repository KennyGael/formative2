import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/incident.dart';
import '../models/status_change.dart';
import 'storage_service.dart';

class IncidentService {
  final _db = FirebaseFirestore.instance;
  final _storage = StorageService();

  Future<void> createIncident({
    required AppUser user,
    required String title,
    required String description,
    required String category,
    required String location,
    File? image,
  }) async {
    // Reserve the ID first so the image can be named after it
    final ref = _db.collection('incidents').doc();
    String? imageUrl;
    if (image != null) {
      imageUrl = await _storage.uploadIncidentImage(ref.id, image);
    }
    await ref.set({
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'status': 'submitted',
      'imageUrl': imageUrl,
      'reportedBy': user.uid,
      'reporterName': user.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Incident>> watchIncidents() => _db
      .collection('incidents')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Incident.fromDoc).toList());

  // Staff only (enforced by Firestore security rules, not just the UI).
  // A batch makes the status change and its history entry succeed or fail together.
  Future<void> updateStatus({
    required String incidentId,
    required String status,
    required AppUser staff,
  }) async {
    final ref = _db.collection('incidents').doc(incidentId);
    final batch = _db.batch();
    batch.update(ref, {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.set(ref.collection('statusHistory').doc(), {
      'status': status,
      'changedBy': staff.uid,
      'changedByName': staff.name,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  Stream<List<StatusChange>> watchHistory(String incidentId) => _db
      .collection('incidents')
      .doc(incidentId)
      .collection('statusHistory')
      .orderBy('timestamp')
      .snapshots()
      .map((s) => s.docs.map(StatusChange.fromDoc).toList());
}
