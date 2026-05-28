/// File: wellness_repository.dart
/// Purpose: Holds logic for saving daily moods and loading historical health charts data.
library features;

class MoodEntry {
  final String mood;
  final DateTime date;

  const MoodEntry({required this.mood, required this.date});
}

class WellnessRepository {
  final List<MoodEntry> _moods = [
    MoodEntry(mood: 'Calm', date: DateTime.now().subtract(const Duration(days: 3))),
    MoodEntry(mood: 'Energetic', date: DateTime.now().subtract(const Duration(days: 2))),
    MoodEntry(mood: 'Tired', date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  Future<List<MoodEntry>> fetchMoodHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _moods;
  }

  Future<void> saveMood(String mood) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _moods.insert(0, MoodEntry(mood: mood, date: DateTime.now()));
  }
}
