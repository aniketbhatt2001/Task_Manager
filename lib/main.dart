import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/blocs/theme/bloc/theme_bloc.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';

import 'package:flutter_tasks_app/services/app_router.dart';
import 'package:flutter_tasks_app/services/app_theme.dart';
import 'package:path/path.dart';
import 'blocs/task/task_bloc.dart';
import 'screens/tasks_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(),
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      lazy: false,
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppRouter appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: state.switchValue
              ? AppThemes.appThemeData[AppTheme.darkTheme]
              : AppThemes.appThemeData[AppTheme.lightTheme],
          onGenerateRoute: appRouter.onGenerateRoute,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Tasks App',
          home: TabScreen(),
        );
      },
    );
  }
}
