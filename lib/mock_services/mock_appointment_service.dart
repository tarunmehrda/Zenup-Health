/// File: mock_appointment_service.dart
/// Purpose: Simulates remote scheduling of patient consultations.
library mock_services;

import 'dart:async';
import 'mock_data/mock_appointments.dart';

class MockAppointmentService {
  final List<MockAppointment> _appointments = [...mockAppointmentsList];

  Future<List<MockAppointment>> getAppointments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _appointments;
  }

  Future<MockAppointment> createAppointment({
    required String providerName,
    required String specialty,
    required String date,
    required String time,
    required String type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newApt = MockAppointment(
      id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
      providerName: providerName,
      specialty: specialty,
      date: date,
      time: time,
      type: type,
      status: 'Upcoming',
    );

    _appointments.insert(0, newApt);
    return newApt;
  }

  Future<void> cancelAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _appointments.indexWhere((element) => element.id == id);
    if (index != -1) {
      final old = _appointments[index];
      _appointments[index] = MockAppointment(
        id: old.id,
        providerName: old.providerName,
        specialty: old.specialty,
        date: old.date,
        time: old.time,
        type: old.type,
        status: 'Cancelled',
      );
    }
  }
}
