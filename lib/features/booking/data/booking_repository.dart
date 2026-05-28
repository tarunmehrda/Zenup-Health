/// File: booking_repository.dart
/// Purpose: Holds logic for calling the appointment service to schedule sessions.
library features;

import '../../../mock_services/mock_appointment_service.dart';
import '../../../mock_services/mock_data/mock_appointments.dart';

class BookingRepository {
  final MockAppointmentService _appointmentService = MockAppointmentService();

  Future<MockAppointment> bookSession({
    required String providerName,
    required String specialty,
    required String date,
    required String time,
    required String type,
  }) async {
    return await _appointmentService.createAppointment(
      providerName: providerName,
      specialty: specialty,
      date: date,
      time: time,
      type: type,
    );
  }
}
