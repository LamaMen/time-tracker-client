import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme fonts(BuildContext context) {
  return GoogleFonts.robotoTextTheme(
    Theme
        .of(context)
        .textTheme,
  );
}