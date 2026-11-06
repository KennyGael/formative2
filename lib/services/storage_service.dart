import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadIncidentImage(String incidentId, File file) async {
    final ref = _storage.ref('incident_images/$incidentId.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
