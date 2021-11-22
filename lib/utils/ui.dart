import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';

headerTextBox(String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
      fontSize: AppTheme.headerSize,
      color: AppTheme.headerColor,
      fontWeight: FontWeight.bold,
      // letterSpacing: 1.0,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}
