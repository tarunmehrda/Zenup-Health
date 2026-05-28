/// File: mock_appointments.dart
/// Purpose: Holds mock appointments lists for schedule display.
library mock_services;

class MockAppointment {
  final String id;
  final String providerName;
  final String specialty;
  final String date;
  final String time;
  final String type; // e.g. "Video Consultation" or "In-Person Visit"
  final String status; // e.g. "Upcoming", "Completed", "Cancelled"

  const MockAppointment({
    required this.id,
    required this.providerName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });
}

const List<MockAppointment> mockAppointmentsList = [
  MockAppointment(
    id: 'apt-001',
    providerName: 'Dr. Sarah Jenkins',
    specialty: 'Cardiologist',
    date: 'June 04, 2026',
    time: '10:30 AM',
    type: 'Video Consultation',
    status: 'Upcoming',
  ),
  MockAppointment(
    id: 'apt-002',
    providerName: 'Dr. Marcus Vance',
    specialty: 'Mental Health Counselor',
    date: 'May 20, 2026',
    time: '03:00 PM',
    type: 'In-Person Visit',
    status: 'Completed',
  ),
];
