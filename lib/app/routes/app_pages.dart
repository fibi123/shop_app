import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/home/home_page.dart';

class AppPages {
  AppPages._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashPage(), settings);
      case AppRoutes.login:
        return _buildRoute(const LoginPage(), settings);
      case AppRoutes.home:
        return _buildRoute(const HomePage(), settings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route for: ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
