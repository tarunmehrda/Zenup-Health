/// File: booking_flow_screen.dart
/// Purpose: Displays selections to finalize doctor bookings.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/z_button.dart';
import '../../../mock_services/mock_data/mock_providers.dart';
import '../domain/booking_notifier.dart';
import 'widgets/session_type_selector.dart';
import 'widgets/date_slot_picker.dart';
import 'widgets/session_summary_card.dart';

class BookingFlowScreen extends StatefulWidget {
  final MockProvider? provider;

  const BookingFlowScreen({super.key, this.provider});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}


class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final _bookingNotifier = BookingNotifier();
  late MockProvider _provider;

  @override
  void initState() {
    super.initState();
    // Default fallback doctor if none was supplied
    _provider = widget.provider ?? mockProvidersList.first;
  }

  @override
  void dispose() {
    _bookingNotifier.dispose();
    super.dispose();
  }

  void _onBook() async {
    final success = await _bookingNotifier.book(
      providerName: _provider.name,
      specialty: _provider.specialty,
    );
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: AppColors.accent,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to book appointment. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Schedule Consult'),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _bookingNotifier,
          builder: (context, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Choose Consultation Mode',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SessionTypeSelector(
                          selectedType: _bookingNotifier.selectedType,
                          onTypeChanged: _bookingNotifier.selectType,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        DateSlotPicker(
                          availableTimes: _provider.availableSlots,
                          selectedDate: _bookingNotifier.selectedDate,
                          selectedTime: _bookingNotifier.selectedTime,
                          onSlotChanged: _bookingNotifier.selectSlot,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SessionSummaryCard(
                          providerName: _provider.name,
                          specialty: _provider.specialty,
                          date: _bookingNotifier.selectedDate,
                          time: _bookingNotifier.selectedTime,
                          type: _bookingNotifier.selectedType,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ZButton(
                      label: 'Confirm Booking',
                      isLoading: _bookingNotifier.isLoading,
                      onPressed: _onBook,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
