import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../models/incident.dart';
import '../models/status_change.dart';
import '../services/incident_service.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentService _service = IncidentService();
  StreamSubscription<List<Incident>>? _sub;

  List<Incident> all = [];
  bool loadingList = true;
  bool submitting = false;
  String? error;

  String query = '';
  String? statusFilter;
  String? categoryFilter;

  void listen() {
    _sub?.cancel();
    _sub = _service.watchIncidents().listen((list) {
      all = list;
      loadingList = false;
      notifyListeners();
    }, onError: (e) {
      error = 'Could not load reports: $e';
      loadingList = false;
      notifyListeners();
    });
  }

  // No notifyListeners here: it is called when the shell is disposed
  void stopListening() {
    _sub?.cancel();
    _sub = null;
    all = [];
    loadingList = true;
    query = '';
    statusFilter = null;
    categoryFilter = null;
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setStatusFilter(String? s) {
    statusFilter = s;
    notifyListeners();
  }

  void setCategoryFilter(String? c) {
    categoryFilter = c;
    notifyListeners();
  }

  List<Incident> get filtered {
    final q = query.trim().toLowerCase();
    return all.where((i) {
      if (statusFilter != null && i.status != statusFilter) return false;
      if (categoryFilter != null && i.category != categoryFilter) return false;
      if (q.isEmpty) return true;
      return i.title.toLowerCase().contains(q) ||
          i.description.toLowerCase().contains(q) ||
          i.location.toLowerCase().contains(q);
    }).toList();
  }

  List<Incident> mine(String uid) => all.where((i) => i.reportedBy == uid).toList();

  Future<bool> submit({
    required AppUser user,
    required String title,
    required String description,
    required String category,
    required String location,
    File? image,
  }) async {
    submitting = true;
    error = null;
    notifyListeners();
    try {
      await _service.createIncident(
        user: user,
        title: title,
        description: description,
        category: category,
        location: location,
        image: image,
      );
      return true;
    } catch (e) {
      error = 'Could not submit the report: $e';
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  Stream<List<StatusChange>> historyFor(String incidentId) =>
      _service.watchHistory(incidentId);

  // UI-level guard. The real protection is the Firestore security rules.
  Future<bool> updateStatus({
    required AppUser staff,
    required String incidentId,
    required String status,
  }) async {
    if (!staff.isStaff) {
      error = 'Only staff can update statuses';
      notifyListeners();
      return false;
    }
    try {
      await _service.updateStatus(incidentId: incidentId, status: status, staff: staff);
      return true;
    } catch (e) {
      error = 'Could not update the status: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
