/// File: appointments_notifier.dart
/// Purpose: Manages state updates on the appointments list screen.
library features;

import 'package:flutter/material.dart';
import '../data/appointments_repository.dart';
import '../../../mock_services/mock_data/mock_appointments.dart';

class AppointmentsNotifier extends ChangeNotifier {
  final AppointmentsRepository _repository = AppointmentsRepository();
  bool _isLoading = false;
  List<MockAppointment> _appointments = [];

  bool get isLoading => _isLoading;
  List<MockAppointment> get appointments => _appointments;

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _repository.getAppointmentsList();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancel(String id) async {
    await _repository.cancelSession(id);
    await loadAppointments();
  }
}
