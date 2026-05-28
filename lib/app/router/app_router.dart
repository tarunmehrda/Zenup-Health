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
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/messaging/presentation/messaging_screen.dart';
import '../../features/wellness/presentation/wellness_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.authLogin:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.serviceSelection:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.authSignup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.discovery:
        return MaterialPageRoute(builder: (_) => const DiscoveryScreen());
      case AppRoutes.providerProfile:
        final providerId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProviderProfileScreen(providerId: providerId),
        );
      case AppRoutes.bookingFlow:
        final provider = settings.arguments as MockProvider?;
        return MaterialPageRoute(
          builder: (_) => BookingFlowScreen(provider: provider),
        );
      case AppRoutes.appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
      case AppRoutes.messaging:
        return MaterialPageRoute(builder: (_) => const MessagingScreen());
      case AppRoutes.wellness:
        return MaterialPageRoute(builder: (_) => const WellnessScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
