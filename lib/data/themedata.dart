import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

bool darkEnabled = false;
Color textColor = Colors.black;
Color textBoxColor = Colors.grey.shade200;
Color backgroundColor = Colors.white;
Color appBarColor = Colors.deepOrange.shade800;
IconData themeIcon = Icons.dark_mode;

String ans = '';
String lastCalc = '';

ButtonStyle style1 = ElevatedButton.styleFrom(
  backgroundColor: Colors.red.shade500,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);
ButtonStyle style2 = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange.shade500,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);
ButtonStyle style3 = ElevatedButton.styleFrom(
  backgroundColor: Colors.deepOrange.shade300,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);

void showErrorMessage(String msg, BuildContext context) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: textColor,
    duration: const Duration(seconds: 5),
    backgroundColor: backgroundColor,
    content: Text(msg, style: TextStyle(color: textColor)),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void darkTheme() {
  if (!darkEnabled) {
    darkEnabled = true;
    backgroundColor = Colors.black;
    textColor = Colors.white;
    textBoxColor = Colors.grey.shade900;
    appBarColor = Colors.black;
    themeIcon = Icons.light_mode;
    style1 = ElevatedButton.styleFrom(
      backgroundColor: Colors.cyan.shade900,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    style2 = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade600,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    style3 = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade900,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  } else {
    darkEnabled = false;
    backgroundColor = Colors.white;
    textColor = Colors.black;
    textBoxColor = Colors.grey.shade200;
    appBarColor = Colors.deepOrange.shade800;
    themeIcon = Icons.dark_mode;
    style1 = ElevatedButton.styleFrom(
      backgroundColor: Colors.red.shade500,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    style2 = ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrange.shade500,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    style3 = ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrange.shade300,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

String formatNumber(String num) {
  Decimal sign = (double.parse(num) < 0) ? Decimal.parse('-1') : Decimal.parse('1');
  num = Decimal.parse(num).abs().toString();
  if (Decimal.parse(num) > Decimal.parse('1e10')) {
    num = Decimal.parse(num).toStringAsExponential(3);
  } else if (Decimal.parse(num) < Decimal.parse('1e-5')) {
    num = Decimal.parse(num).toStringAsExponential(3);
  } else if (num.contains('.') &&
      Decimal.parse(num) > Decimal.parse('1') &&
      num.substring(num.indexOf('.'), num.length).length > 4) {
    num = num.substring(0, num.indexOf('.') + 4);
  } else if (num.contains('.') &&
      num.substring(num.indexOf('.'), num.length).length > 6) {
    num = Decimal.parse(num).toStringAsFixed(5);
  }
  num = (Decimal.parse(num) * sign).toString();
  return num;
}

SizedBox uiButton(
    double height, ButtonStyle style, void Function() func, String txt) {
  return SizedBox(
    width: height,
    height: height,
    child: ElevatedButton(
      style: style,
      onPressed: func,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          txt,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    ),
  );
}

SizedBox textBox(double width, double height, String text) {
  return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: textBoxColor),
          onPressed: null,
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor, fontSize: 25))));
}
