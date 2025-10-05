import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/my_theme.dart';

class MyAlertDialog extends StatelessWidget {
  final icon;
  final content;
  final buttonOneText;
  final buttonTwoText;
  final buttonOneColor;
  final buttonTwoColor;
  VoidCallback? deleteNoteBtnFun;

  MyAlertDialog({super.key,
    required this.icon,
    required this.content,
    required this.deleteNoteBtnFun,
    required this.buttonOneText,
    required this.buttonTwoText, required this.buttonOneColor, required this.buttonTwoColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mediamGreyColor,
      title: icon,
      content: Text(content),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonOneColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(11),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                buttonOneText,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonTwoColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(11),
                ),
              ),
              onPressed: deleteNoteBtnFun,
              child: Text(
                buttonTwoText,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
