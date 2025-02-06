import 'package:flutter/material.dart';
import 'package:movie_app/core/utils/app_route.dart';
import 'package:movie_app/core/utils/theme_provider.dart';
import 'package:provider/provider.dart'; // استيراد Provider
import 'network/service_locator.dart';

void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // تسجيل المزود
      child: MovieApp(appRouter: AppRouter()),
    ),
  );
}

class MovieApp extends StatelessWidget {
  final AppRouter appRouter;
  const MovieApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          themeMode: themeProvider.themeMode, // ربط الثيم مع المزود
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        );
      },
    );
  }
}
