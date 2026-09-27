import 'package:f_compass/src/features/compass/routes/compass_routes.dart';
import 'package:f_compass/src/features/settings/routes/setting_routes.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static String get home => CompassRoutes.compass;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [
      ...CompassRoutes().routes,
      ...SettingRoutes().routes,
    ],
  );
}
