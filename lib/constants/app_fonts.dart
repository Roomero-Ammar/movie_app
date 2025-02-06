import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {

  static TextTheme textTheme = TextTheme(
    headlineLarge: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40,
      ),
    ),
    headlineSmall: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
    labelLarge: GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    labelMedium: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        // color: const Color(
        //   0xff1D1D21,
        // ),
      ),
    ),
    labelSmall: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    titleSmall: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
 
    displaySmall: GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
      ),
    ),

  );
}
