/// File: home_screen.dart
/// Purpose: The main dashboard and tab shell for Zenup Health, displaying vitals, schedules, and menus.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_avatar.dart';
import '../../../shared/widgets/z_card.dart';
import '../../discovery/presentation/discovery_screen.dart';
import '../../messaging/presentation/messaging_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'widgets/upcoming_appointment_widget.dart';
import 'widgets/quick_actions_widget.dart';
import 'widgets/featured_providers_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  Widget _buildDashboard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Profile & Greeting Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning,',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Zen Master',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _onTabChange(3), // Navigate to Profile tab
                child: const ZAvatar(
                  name: 'Zen Master',
                  radius: 22,
                  showBorder: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Wellness Score Card
          ZCard(
            useGradient: true,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: CircularProgressIndicator(
                        value: 0.78,
                        strokeWidth: 7,
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                        color: AppColors.accent,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '78%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Zen',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wellness Status',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'You\'re doing excellent today! 3/4 health tasks completed successfully.',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Quick actions
          QuickActionsWidget(
            onActionSelected: (action) {
              if (action == 'book') {
                Navigator.of(context).pushNamed(AppRoutes.bookingFlow);
              } else if (action == 'chat') {
                _onTabChange(2); // Switch to Chat tab
              } else if (action == 'wellness') {
                Navigator.of(context).pushNamed(AppRoutes.wellness);
              } else if (action == 'discovery') {
                _onTabChange(1); // Switch to Discovery tab
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Upcoming Appointment Widget
          UpcomingAppointmentWidget(
            doctorName: 'Dr. Sarah Jenkins',
            specialty: 'Cardiologist',
            date: 'June 04, 2026',
            time: '10:30 AM',
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.appointments);
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Featured Doctors
          FeaturedProvidersWidget(
            onProviderSelected: (provider) {
              Navigator.of(context).pushNamed(
                AppRoutes.providerProfile,
                arguments: provider.id,
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget body;
    switch (_currentTabIndex) {
      case 1:
        body = const DiscoveryScreen();
        break;
      case 2:
        body = const MessagingScreen();
        break;
      case 3:
        body = const ProfileScreen();
        break;
      case 0:
      default:
        body = _buildDashboard();
        break;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundEnd : AppColors.lightBackgroundEnd,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: body,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : AppColors.lightBorder,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: isDark ? AppColors.backgroundEnd : AppColors.lightBackgroundEnd,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark ? AppColors.textHint : AppColors.lightTextHint,
          currentIndex: _currentTabIndex,
          onTap: _onTabChange,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.space_dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Discovery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
