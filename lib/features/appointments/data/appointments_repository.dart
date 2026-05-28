/// File: appointments_repository.dart
/// Purpose: Retrieves a list of active and history appointments.
library features;

import '../../../mock_services/mock_appointment_service.dart';
import '../../../mock_services/mock_data/mock_appointments.dart';

class AppointmentsRepository {
  final MockAppointmentService _appointmentService = MockAppointmentService();

  Future<List<MockAppointment>> getAppointmentsList() async {
    return await _appointmentService.getAppointments();
  }

  Future<void> cancelSession(String id) async {
    await _appointmentService.cancelAppointment(id);
  }
}
