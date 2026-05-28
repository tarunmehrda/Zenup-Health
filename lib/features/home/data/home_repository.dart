/// File: home_repository.dart
/// Purpose: Retrieves statistics, user vitals, and home data for the dashboard.
library features;

class HomeRepository {
  Future<Map<String, dynamic>> fetchVitals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'steps': '8,432',
      'stepsProgress': 0.84,
      'sleep': '7h 45m',
      'sleepProgress': 0.96,
      'heartRate': '72',
      'heartRateProgress': 0.72,
      'hydration': '1.8 / 2.5',
      'hydrationProgress': 0.72,
    };
  }
}
