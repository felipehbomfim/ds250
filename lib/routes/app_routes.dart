import 'package:ds250/presentation/task_list_screen/task_list_screen.dart';
import 'package:ds250/presentation/task_screen/task_creen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  
  static const String homeScreen = '/home_screen';

  static const String taskScreen = '/task_screen';

  static const String taskListScreen = '/task_list_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    homeScreen: (context) => HomeScreen(),
    taskListScreen: (context) {
      final Map<String, dynamic> taskParams = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return TaskListScreen(data: taskParams['data']);
    },
    taskScreen: (context) {
      final Map<String, dynamic> taskParams = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return TaskScreen(task: taskParams);
    },
  };

}
