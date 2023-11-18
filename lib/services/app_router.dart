import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';
import 'package:flutter_tasks_app/screens/tasks_screen.dart';

import '../screens/recycle_bin.dart';

class AppRouter {
  const AppRouter();
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RecycleBin.name:
        return MaterialPageRoute(
          builder: (context) => const RecycleBin(),
        );
      case TabScreen.name:
        return MaterialPageRoute(
          builder: (context) => const TabScreen(),
        );
      default:
        return null;
    }
  }
}
