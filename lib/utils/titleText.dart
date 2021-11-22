import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';

class TitleText extends StatelessWidget {
  final String title;
  double fontSize = AppTheme.subtitle_font_size_middle;
  Color fontColor = AppTheme.font_color;
  FontWeight fontWeight = FontWeight.bold;
  bool withDivider = true;
  TextAlign align = TextAlign.start;

  TitleText(
      {Key? key,
      required this.title,
      double? fontSize,
      Color? fontColor,
      FontWeight? fontWeight,
      bool? withDivider,
      TextAlign? align})
      : this.fontSize = fontSize ?? AppTheme.subtitle_font_size_middle,
        this.fontColor = fontColor ?? AppTheme.font_color,
        this.fontWeight = fontWeight ?? FontWeight.bold,
        this.withDivider = withDivider ?? true,
        this.align = align ?? TextAlign.start;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: GoogleFonts.ptSans(
              fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
        ),
        if (withDivider)
          Divider(
            color: fontColor.withOpacity(0.1),
            thickness: 1,
          )
      ],
    );
  }
}
