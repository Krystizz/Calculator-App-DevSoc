import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'history.dart';
import 'currency.dart';
import 'globals.dart' as globals;
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  final String? userID = FirebaseAuth.instance.currentUser!.email;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String prevNum = '';
  String newNum = '';
  String oper = '';
  Decimal num1 = Decimal.parse('0.0');
  Decimal num2 = Decimal.parse('0.0');
  Decimal temp = Decimal.parse('0.0');
  
  bool shouldClear = false;

  void save(String lastCalc) async {
    await FirebaseFirestore.instance.collection(widget.userID!).add({
      'calc': lastCalc,
      'time': DateTime.now(),
    });
  }

  void showErrorMessage(String msg) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: globals.backgroundColor,
        title: Center(child: Text(msg, style: TextStyle(color: globals.textColor))),
      );
    });
  }

  void backspace(){
    setState(() {
      if (shouldClear == true) {
        clear();
      }
      if (globals.ans.isNotEmpty) {
        globals.ans = globals.ans.substring(0, globals.ans.length - 1);
      }
    });
  }

  void clear() {
    setState(() {
      globals.ans = '';
      prevNum = '';
      newNum = '';
      oper = '';
      globals.lastCalc = '';
      num1 = Decimal.parse('0.0');
      num2 = Decimal.parse('0.0');
      shouldClear = false;
    });
  }

  void calculate() {
    setState(() {
      shouldClear = true;
      if (globals.ans.isNotEmpty) {
        num2 = Decimal.parse(globals.ans);
        if (oper == '+') {
          globals.ans = (num1 + num2).toString();
          prevNum = num1.toString();
          newNum = num2.toString();
        }
        else if (oper == '-') {
          globals.ans = (num1 - num2).toString();
          prevNum = num1.toString();
          newNum = num2.toString();
        }
        else if (oper == 'x') {
          globals.ans = (num1 * num2).toString();
          prevNum = num1.toString();
          newNum = num2.toString();
        }
        else if (oper == '^') {
          try {
            temp = Decimal.parse((math.pow(num1.toDouble(), num2.toDouble())).toString());
            globals.ans = temp.toString();
            prevNum = num1.toString();
            newNum = num2.toString();
          }
          catch (e) {
            showErrorMessage('Math Error (Invalid Input)');
            clear();
            return;
          }
        }
        else if (oper == '÷') {
          if (num2 == Decimal.parse('0.0')) {
            showErrorMessage('Math Error (Cannot divide by zero)');
            clear();
            return;
          }
          else {
            globals.ans = (num1 / num2).toDouble().toString();
            prevNum = num1.toString();
            newNum = num2.toString();
          }
        }
        if (globals.ans.contains('.') && Decimal.parse(globals.ans) > Decimal.parse('1') &&
          globals.ans.substring(globals.ans.indexOf('.'), globals.ans.length).length > 4)
        {
          globals.ans = globals.ans.substring(0, globals.ans.indexOf('.') + 4);
        }
        if (Decimal.parse(globals.ans) > Decimal.parse('1e10'))
        {
          globals.ans = Decimal.parse(globals.ans).toStringAsExponential(3);
        }
        if (Decimal.parse(prevNum) > Decimal.parse('1e10'))
        {
          prevNum = Decimal.parse(prevNum).toStringAsExponential(3);
        }
        globals.lastCalc = '$prevNum $oper $newNum = ${globals.ans}';
        num1 = Decimal.parse('0.0');
        num2 = Decimal.parse('0.0');
        oper = '';
      }
      else {
        shouldClear = false;
      }
    });
  }

  void numClicked(numC){
    setState(() {
      if (shouldClear) {
        clear();
      }
      if (numC=='.'){
        if (!globals.ans.contains('.')){
          globals.ans = globals.ans + numC;
        }
      }
      else {
        globals.ans = globals.ans + numC;
      }
    });
  }

  void operClicked(String ope){
    setState(() {
      shouldClear = false;
      if (globals.ans.isNotEmpty) {
        prevNum = globals.ans;
        if (oper != '') {
          calculate();
          shouldClear = false;
          prevNum = globals.ans;
          num1 = Decimal.parse(globals.ans);
          globals.ans = '';
          oper = ope;
        }
        else{
          num1 = Decimal.parse(globals.ans);
          globals.ans = '';
          oper = ope;
        }
      }
      else if (globals.ans.isEmpty) {
        oper = ope;
      }
      globals.lastCalc = prevNum;
    });
  }

  void changeSign(){
    setState(() {
      if (globals.ans.isEmpty) {
        return;
      }
      temp = Decimal.parse(globals.ans) * Decimal.parse('-1.0');
      globals.ans = temp.toString();
      shouldClear = false;
    });
  }

  void constants(k){
    setState(() {
      if (shouldClear) {
        clear();
      }
      if (k == 'π') {
        globals.ans = '3.14159';
        shouldClear = false;
      }
      else if (k == 'e') {
        globals.ans = '2.71828';
        shouldClear = false;
      }
    });
  }

  void scientific(String s) {
    setState(() {
      if (globals.ans.isEmpty) {
        return;
      }
      try {
        if (s == 'sin') {
          temp = Decimal.parse((math.sin(double.parse(globals.ans))).toString());
        }
        else if (s == 'cos') {
          temp = Decimal.parse((math.cos(double.parse(globals.ans))).toString());
        }
        else if (s == 'tan') {
          temp = Decimal.parse((math.tan(double.parse(globals.ans))).toString());
        }
        else if (s == 'arcsin') {
          temp = Decimal.parse((math.asin(double.parse(globals.ans))).toString());
        }
        else if (s == 'arccos') {
          temp = Decimal.parse((math.acos(double.parse(globals.ans))).toString());
        }
        else if (s == 'arctan') {
          temp = Decimal.parse((math.atan(double.parse(globals.ans))).toString());
        }
        else if (s == 'ln') {
          temp = Decimal.parse((math.log(double.parse(globals.ans))).toString());
        }
        else if (s == 'sqrt') {
          temp = Decimal.parse((math.pow(double.parse(globals.ans), 0.5)).toString());
        }
        prevNum = globals.ans;
        globals.ans = temp.toStringAsFixed(5);
        if (globals.ans.contains('.') && Decimal.parse(globals.ans) > Decimal.parse('1') &&
          globals.ans.substring(globals.ans.indexOf('.'), globals.ans.length).length > 4)
        {
          globals.ans = globals.ans.substring(0, globals.ans.indexOf('.') + 4);
        }
        if (Decimal.parse(globals.ans) > Decimal.parse('1e10'))
        {
          globals.ans = Decimal.parse(globals.ans).toStringAsExponential(3);
        }
        if (Decimal.parse(prevNum) > Decimal.parse('1e10'))
        {
          prevNum = Decimal.parse(prevNum).toStringAsExponential(3);
        }
        globals.lastCalc = '$s($prevNum) = ${globals.ans}';
        save(globals.lastCalc);
      }
      catch (e) {
        showErrorMessage('Math Error (Invalid Input)');
      }
      shouldClear = true;
    });
  }

  void darkTheme() {
    setState(() {
      if (!globals.darkEnabled) {
        globals.darkEnabled = true;
        globals.backgroundColor = Colors.black;
        globals.textColor = Colors.white;
        globals.textBoxColor = Colors.grey.shade900;
        globals.appBarColor = Colors.black;
        globals.themeIcon = Icons.light_mode;
        globals.style1 = ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan.shade900, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
        globals.style2 = ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade600, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
        globals.style3 = ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade900, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
      }
      else {
        globals.darkEnabled = false;
        globals.backgroundColor = Colors.white;
        globals.textColor = Colors.black;
        globals.textBoxColor = Colors.grey.shade200;
        globals.appBarColor = Colors.deepOrange.shade800;
        globals.themeIcon = Icons.dark_mode;
        globals.style1 = ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade500, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
        globals.style2 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade500, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
        globals.style3 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade300, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
      }
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    SizedBox uiButton(double x, double y, ButtonStyle style,
      void Function() func, String txt) {
        return SizedBox(width: screenWidth*x, height: screenHeight*y, child:
          ElevatedButton(style: style, onPressed: func, child:
            FittedBox(fit: BoxFit.scaleDown, child: Text(txt,
              style: const TextStyle(fontSize: 40),),),),);
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white, backgroundColor: globals.appBarColor,
        title: const Text('Calculator'), centerTitle: true,
        actions: <Widget>[
            IconButton(icon: const Icon(Icons.history), onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder:
              (context) => HistoryPage())).then((value) {setState(() {});});
              }),
            ],
      ),
      drawer: Drawer(
        backgroundColor: globals.backgroundColor,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(child: Text('Options', style:
                TextStyle(fontSize: 25, color: globals.textColor),),),
            ),
            ListTile(
              title: Text('Calculator', style: TextStyle(color: globals.textColor)),
              leading: Icon(Icons.calculate_outlined, color: globals.textColor),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('History', style: TextStyle(color: globals.textColor)),
              leading: Icon(Icons.history, color: globals.textColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder:
                (context) => HistoryPage())).then((value) {setState(() {});});
              },
            ),
            ListTile(
              title: Text('Currency', style: TextStyle(color: globals.textColor)),
              leading: Icon(Icons.currency_exchange_outlined, color: globals.textColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder:
                (context) => const CurrencyPage())).then((value) {setState(() {});});
              },
            ),
            ListTile(
              title: Text('Sign Out', style: TextStyle(color: globals.textColor)),
              leading: Icon(Icons.logout, color: globals.textColor),
              onTap: () {
                setState(() {
                  clear();
                  signUserOut();
                });
              },
            ),
            ListTile(
              title: Text((!globals.darkEnabled)? 'Dark Theme' : 'Light Theme',
                style: TextStyle(color: globals.textColor)),
              leading: Icon(globals.themeIcon, color: globals.textColor),
              onTap: () {
                setState(() {darkTheme();});
              },
            ),
          ],
        ),
      ),

      body:
    Container(color: globals.backgroundColor, child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: screenWidth*0.92, height: screenHeight*0.07, child:
            OutlinedButton(style: TextButton.styleFrom(shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: globals.textBoxColor), onPressed: null, child:
                  Text(globals.lastCalc.split(' = ')[0], style:
                    TextStyle(fontSize: 25, color: globals.textColor)),),),
          SizedBox(width: screenWidth*0.92, height: screenHeight*0.07, child:
            OutlinedButton(style: TextButton.styleFrom(shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: globals.textBoxColor), onPressed: null, child:
                  Text(globals.ans, style: TextStyle(fontSize: 25, color: globals.textColor)),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style1, clear, 'C'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('sin');}, 'sin'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('cos');}, 'cos'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('tan');}, 'tan'),
                  uiButton(0.17, 0.08, globals.style1, backspace, '⌫'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style2, (){operClicked('^');}, '^'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('arcsin');}, 'sin\ninv'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('arccos');}, 'cos\ninv'),
                  uiButton(0.17, 0.08, globals.style2, (){scientific('arctan');}, 'tan\ninv'),
                  uiButton(0.17, 0.08, globals.style2, (){operClicked('+');}, '+'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style2, (){scientific('sqrt');}, '√'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('7');}, '7'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('8');}, '8'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('9');}, '9'),
                  uiButton(0.17, 0.08, globals.style2, (){operClicked('-');}, '-'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style2, (){scientific('ln');}, 'ln'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('4');}, '4'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('5');}, '5'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('6');}, '6'),
                  uiButton(0.17, 0.08, globals.style2, (){operClicked('x');}, 'x'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style2, (){constants('e');}, 'e'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('1');}, '1'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('2');}, '2'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('3');}, '3'),
                  uiButton(0.17, 0.08, globals.style2, (){operClicked('÷');}, '÷'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.17, 0.08, globals.style2, (){constants('π');}, 'π'),
                  uiButton(0.17, 0.08, globals.style2, changeSign, '±'),
                  uiButton(0.17, 0.08, globals.style3, (){numClicked('0');}, '0'),
                  uiButton(0.17, 0.08, globals.style2, (){numClicked('.');}, '.'),
                  uiButton(0.17, 0.08, globals.style1, (){
                    calculate();
                    if (prevNum.isNotEmpty) {
                      save(globals.lastCalc);
                    }
                  }, '='),
                ],
              ),
            ],),
        ],
      ),
    ),
    );
  }
}