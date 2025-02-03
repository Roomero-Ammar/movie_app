import 'package:flutter/material.dart';
import 'package:movie_app/core/utils/app_route.dart';

import 'network/service_locator.dart';

void main() {
  setupLocator();
  runApp(MovieApp(appRouter: AppRouter()));
}

class MovieApp extends StatelessWidget {
  final AppRouter appRouter;
  const MovieApp({Key? key, required this.appRouter}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}