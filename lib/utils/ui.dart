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
        decoration: TextDecoration.none
        // letterSpacing: 1.0,
        ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

normalTextBox(String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
      fontSize: AppTheme.textSize,
      color: AppTheme.textColor,
      fontWeight: FontWeight.bold,
      // letterSpacing: 1.0,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

normalInvalidTextBox(String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
      fontSize: AppTheme.textSize,
      color: Colors.black12,
      fontWeight: FontWeight.bold,
      // letterSpacing: 1.0,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

smallTextBox(String text) {
  return Text(
    text,
    style: GoogleFonts.ptSans(
      fontSize: AppTheme.smallTextSize,
      color: AppTheme.smallTextColor,
      fontWeight: FontWeight.normal,
      // letterSpacing: 1.0,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}
