/// File: appointments_screen.dart
/// Purpose: Lists active and historical appointment schedules.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/z_loader.dart';
import '../../../shared/widgets/z_empty_state.dart';
import '../domain/appointments_notifier.dart';
import 'widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _appointmentsNotifier = AppointmentsNotifier();

  @override
  void initState() {
    super.initState();
    _appointmentsNotifier.loadAppointments();
  }

  @override
  void dispose() {
    _appointmentsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        title: const Text('Appointments Schedule'),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _appointmentsNotifier,
          builder: (context, child) {
            if (_appointmentsNotifier.isLoading) {
              return const ZLoader();
            }

            if (_appointmentsNotifier.appointments.isEmpty) {
              return const ZEmptyState(
                title: 'No appointments scheduled',
                description: 'Book your first virtual telehealth consultation.',
                icon: Icons.calendar_today_rounded,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _appointmentsNotifier.appointments.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final apt = _appointmentsNotifier.appointments[index];
                return AppointmentCard(
                  providerName: apt.providerName,
                  specialty: apt.specialty,
                  date: apt.date,
                  time: apt.time,
                  type: apt.type,
                  status: apt.status,
                  onCancel: () {
                    _appointmentsNotifier.cancel(apt.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
