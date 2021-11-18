import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homg_long/const/AppTheme.dart';

class BarChartToggleButton extends StatefulWidget {
  BarChartToggleButton({Key? key}) : super(key: key);

  @override
  _BarChartToggleButtonState createState() => _BarChartToggleButtonState();
}

class _BarChartToggleButtonState extends State<BarChartToggleButton> {
  List<bool> isSelected = [true, false];
  final double fontSize = 15;
  final FontWeight fontWeight = FontWeight.w600;
  final Color selectedColor = Colors.white;
  final Color unSelectedColor = Color(0xFFE9E9FF);
  final Color selectedFontColor = AppTheme.font_color;
  final Color unSelectedFontColor = Color(0x070417).withOpacity(0.4);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.75,
      height: width * 0.12,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFE9E9FF)),
      child: Row(
        children: [toggleButtonItem("Weekly"), toggleButtonItem("Monthly")],
      ),
    );
  }

  Widget toggleButtonItem(String title) {
    bool selected = buttonSelected(title);
    return Flexible(
        flex: 1,
        child: InkWell(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected ? selectedColor : unSelectedColor),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.ptSans(
                    fontSize: fontSize,
                    color: selected ? selectedFontColor : unSelectedFontColor,
                    fontWeight: fontWeight),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              if (buttonSelected(title) == false) {
                updateButtonSeleted();
              }
            });
          },
        ));
  }

  bool buttonSelected(String title) {
    print("tittle: " + title);
    if (title == "Weekly") {
      return isSelected[0];
    } else {
      return isSelected[1];
    }
  }

  void updateButtonSeleted() {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = isSelected[i] ? false : true;
    }
  }
}
