/// File: datetime_extensions.dart
/// Purpose: Provides utility extension methods on DateTime for easy formatting.
library core;

extension DateTimeExtensions on DateTime {
  // Format to standard date representation (e.g. May 28, 2026)
  String get toFormattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[month - 1]} $day, $year';
  }

  // Format to standard time representation (e.g. 09:30 AM)
  String get toFormattedTime {
    final hourVal = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteVal = minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    return '${hourVal.toString().padLeft(2, '0')}:$minuteVal $period';
  }

  // Check if same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
