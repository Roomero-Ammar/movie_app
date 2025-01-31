import 'package:flutter/material.dart';
import 'package:movie_app/core/utils/app_router.dart';

void main() {
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