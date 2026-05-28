/// File: app_router.dart
/// Purpose: Defines RouteFactory and page transitions mapping route names to screens.
library app_router;

import 'package:flutter/material.dart';
import '../../mock_services/mock_data/mock_providers.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/profile_setup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/discovery/presentation/provider_profile_screen.dart';
import '../../features/booking/presentation/booking_flow_screen.dart';
import '../../features/booking/presentation/service_selection_screen.dart';
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/messaging/presentation/messaging_screen.dart';
import '../../features/wellness/presentation/wellness_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  // ── Smooth fade + upward slide transition (premium feel) ──
  static PageRouteBuilder<T> _fadeSlideRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 380),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Incoming: fade in + slide up 18px
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        final slideIn =
            Tween<Offset>(
              begin: const Offset(0.0, 0.045),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        // Outgoing: subtle fade out
        final fadeOut = Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
        );

        return FadeTransition(
          opacity: fadeOut,
          child: FadeTransition(
            opacity: fadeIn,
            child: SlideTransition(position: slideIn, child: child),
          ),
        );
      },
    );
  }

  // ── Horizontal slide transition (for drill-down flows) ──
  static PageRouteBuilder<T> _slideRoute<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn =
            Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final slideOut =
            Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.25, 0.0),
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeInCubic,
              ),
            );

        final fadeOut = Tween<double>(begin: 1.0, end: 0.85).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
        );

        return SlideTransition(
          position: slideOut,
          child: FadeTransition(
            opacity: fadeOut,
            child: SlideTransition(position: slideIn, child: child),
          ),
        );
      },
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fadeSlideRoute(
          page: const SplashScreen(),
          settings: settings,
          duration: const Duration(milliseconds: 300),
        );
      case AppRoutes.onboarding:
        return _fadeSlideRoute(
          page: const OnboardingScreen(),
          settings: settings,
        );
      case AppRoutes.authLogin:
        return _fadeSlideRoute(page: const LoginScreen(), settings: settings);
      case AppRoutes.serviceSelection:
        return _fadeSlideRoute(
          page: const ServiceSelectionScreen(),
          settings: settings,
        );
      case AppRoutes.authSignup:
        return _slideRoute(page: const SignupScreen(), settings: settings);
      case AppRoutes.profileSetup:
        return _slideRoute(
          page: const ProfileSetupScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return _fadeSlideRoute(page: const HomeScreen(), settings: settings);
      case AppRoutes.discovery:
        return _slideRoute(page: const DiscoveryScreen(), settings: settings);
      case AppRoutes.providerProfile:
        final providerId = settings.arguments as String;
        return _slideRoute(
          page: ProviderProfileScreen(providerId: providerId),
          settings: settings,
        );
      case AppRoutes.bookingFlow:
        final provider = settings.arguments as MockProvider?;
        return _slideRoute(
          page: BookingFlowScreen(provider: provider),
          settings: settings,
        );
      case AppRoutes.appointments:
        return _slideRoute(
          page: const AppointmentsScreen(),
          settings: settings,
        );
      case AppRoutes.messaging:
        return _slideRoute(page: const MessagingScreen(), settings: settings);
      case AppRoutes.wellness:
        return _slideRoute(page: const WellnessScreen(), settings: settings);
      case AppRoutes.settings:
        return _slideRoute(page: const SettingsScreen(), settings: settings);
      default:
        return _fadeSlideRoute(
          page: Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
