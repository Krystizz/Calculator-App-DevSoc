library calculator.globals;
import 'package:flutter/material.dart';

bool darkEnabled = false;
Color textColor = Colors.black;
Color textBoxColor = Colors.grey.shade200;
Color backgroundColor = Colors.white;
Color appBarColor = Colors.deepOrange.shade800;
IconData themeIcon = Icons.dark_mode;

String ans = '';
String lastCalc = '';

ButtonStyle style1 = ElevatedButton.styleFrom(backgroundColor: Colors.red.shade500,
    foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius:
    BorderRadius.circular(20)),);
ButtonStyle style2 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade500,
    foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius:
    BorderRadius.circular(20)),);
ButtonStyle style3 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade300,
    foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius:
    BorderRadius.circular(20)),);