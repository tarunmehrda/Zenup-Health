/// File: booking_notifier.dart
/// Purpose: Manages state machine during the appointment booking process.
library features;

import 'package:flutter/material.dart';
import '../data/booking_repository.dart';

class BookingNotifier extends ChangeNotifier {
  final BookingRepository _repository = BookingRepository();
  bool _isLoading = false;
  String _selectedType = 'Video Consultation';
  String _selectedDate = 'June 04, 2026';
  String _selectedTime = '10:30 AM';

  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;
  String get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;

  void selectType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  void selectSlot(String date, String time) {
    _selectedDate = date;
    _selectedTime = time;
    notifyListeners();
  }

  Future<bool> book({required String providerName, required String specialty}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.bookSession(
        providerName: providerName,
        specialty: specialty,
        date: _selectedDate,
        time: _selectedTime,
        type: _selectedType,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
