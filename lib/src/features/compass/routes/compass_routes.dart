import 'package:f_compass/src/common/dependency_injectors/dependency_injector.dart';
import 'package:f_compass/src/features/compass/view_models/compass_view_model.dart';
import 'package:f_compass/src/features/compass/views/compass_view.dart';
import 'package:go_router/go_router.dart';

class CompassRoutes {
  static String get compass => '/';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: compass,
      builder: (context, state) {
        return CompassView(compassViewModel: locator<CompassViewModel>());
      },
    ),
  ];
}
