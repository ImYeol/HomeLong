import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartSubTitle extends StatelessWidget {
  final String title;
  final Color fontColor;
  final double fontSize;
  const ChartSubTitle(
      {Key? key,
      required this.title,
      required this.fontColor,
      required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.95 * 0.2,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            buildTitle(title, fontSize, fontColor),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title, double size, Color color) {
    return Text(title,
        style: GoogleFonts.firaSans(
            color: color, fontSize: size, fontWeight: FontWeight.bold));
  }
}
