import 'package:flutter/material.dart';
import 'package:movie_app/constants/strings.dart';
import 'package:movie_app/ui/home_screen.dart';


class AppRouter {




  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );

     
    }
  }
}