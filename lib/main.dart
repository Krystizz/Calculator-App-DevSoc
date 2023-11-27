import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String ans = '';
  String prev = '';
  String oper = '';
  double num1 = 0.0;
  double num2 = 0.0;
  double temp = 0.0;
  bool justcalc = false;

  bool darkTheme = false;
  Color textboxColor = Colors.white;
  Color backgroundColor = Colors.white;
  Color appbarColor = Colors.deepOrange.shade800;
  IconData themeIcon = Icons.dark_mode;

  var style1 = ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
  var style2 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade300, foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
  var style3 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade50, foregroundColor: Colors.deepOrange.shade900,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);

  void _backspace(){
    setState(() {
      if (justcalc == true) {
        _clear();
      }
      ans = ans.substring(0, ans.length - 1);
    });
  }

  void _clear() {
    setState(() {
      ans = '';
      prev = '';
      num1 = 0.0;
      num2 = 0.0;
      oper = '';
      justcalc = false;
    });
  }

  void _calculate() {
    setState(() {
      justcalc = true;
      if (ans.isNotEmpty) {
        num2 = double.parse(ans);
        if (oper == '+') {
          ans = (num1 + num2).toString();
          prev = num1.toString();
          num1 = 0.0;
          num2 = 0.0;
          oper = '';
        }
        else if (oper == '-') {
          ans = (num1 - num2).toString();
          prev = num1.toString();
          num1 = 0.0;
          num2 = 0.0;
          oper = '';
        }
        else if (oper == 'x') {
          ans = (num1 * num2).toString();
          prev = num1.toString();
          num1 = 0.0;
          num2 = 0.0;
          oper = '';
        }
        else if (oper == '÷') {
          if (num2 == 0) {
            _clear();
          }
          else {
            ans = (num1 / num2).toString();
            prev = num1.toString();
            num1 = 0.0;
            num2 = 0.0;
            oper = '';
          }
        }
        _checkifint();
      }
      else {
        justcalc = false;
      }
    });
  }

  void _numClicked(numC){
    setState(() {
      if (justcalc == true) {
        _clear();
      }
      if (numC=='.'){
        if (!ans.contains('.')){
          ans = ans + numC;
        }
      }
      else {
        ans = ans + numC;
      }
    });
  }

  void _operclicked(String ope){
    setState(() {
      justcalc = false;
      if (ans.isNotEmpty) {
        prev = ans;
        if (oper != '') {
          _calculate();
          justcalc = false;
          prev = ans;
          num1 = double.parse(ans);
          ans = '';
          oper = ope;
        }
        else{
          num1 = double.parse(ans);
          ans = '';
          oper = ope;
        }
      }
      else if (ans.isEmpty) {
        oper = ope;
      }
    });
  }

  void _changesign(){
    setState(() {
      temp = double.parse(ans) * (-1);
      ans = temp.toString();
      _checkifint();
      justcalc == false;
    });
  }

  void _percentage(){
    setState(() {
      temp = double.parse(ans) / 100.0;
      justcalc == true;
      ans = temp.toString();
      _checkifint();
    });
  }

  void _constants(k){
    setState(() {
      if (justcalc == true) {
        _clear();
      }
      if (k == 'pi') {
        ans = '3.14159';
        justcalc == false;
      }
      else if (k == 'e') {
        ans = '2.71828';
        justcalc == false;
      }
    });
  }

  void _square() {
    setState(() {
      temp = double.parse(ans) * double.parse(ans);
      ans = temp.toString();
      _checkifint();
      justcalc == true;
    });
  }

  void _cube() {
    setState(() {
      temp = double.parse(ans) * double.parse(ans) * double.parse(ans);
      ans = temp.toString();
      _checkifint();
      justcalc == true;
    });
  }

  void _checkifint(){
    setState(() {
      if ((double.parse(ans) - ((double.parse(ans)).round()).toDouble()).abs() <= 0.0001) {
        ans = ((double.parse(ans)).round()).toString();
      }
      if (prev.isNotEmpty) {
        if ((double.parse(prev) - ((double.parse(prev)).round()).toDouble()).abs() <= 0.0001) {
          prev = ((double.parse(prev)).round()).toString();
        }
      }
    });
  }

  void _nullfunction() {}

  void _darkTheme() {
    setState(() {
      if (!darkTheme) {
        backgroundColor = Colors.black;
        darkTheme = true;
        textboxColor = Colors.white70;
        appbarColor = Colors.black;
        themeIcon = Icons.light_mode;

        style1 = ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan.shade900, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style2 = ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style3 = ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade900,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
      }
      else {
        backgroundColor = Colors.white;
        darkTheme = false;
        textboxColor = Colors.white;
        appbarColor = Colors.deepOrange.shade800;
        themeIcon = Icons.dark_mode;

        style1 = ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style2 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style3 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade50,
          foregroundColor: Colors.deepOrange.shade900,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    FittedBox textstyle(String txt) {
      return FittedBox(fit: BoxFit.scaleDown, child: Text(txt, style: const TextStyle(fontSize: 40),),);
    }

    return Scaffold(
      appBar: AppBar( foregroundColor: Colors.white,
        backgroundColor: appbarColor,
        title: Text(widget.title),centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(themeIcon),
            onPressed: () {
              setState(() {
                _darkTheme();
              });
            },),],
      ),

      body:
    AnimatedContainer(duration: const Duration(milliseconds: 200), color: backgroundColor, child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: textboxColor), onPressed: _nullfunction,
            child: Text(prev, style: Theme.of(context).textTheme.headlineSmall,),),),
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: textboxColor), onPressed: _nullfunction,
            child: Text(ans, style: Theme.of(context).textTheme.headlineSmall,),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style1, onPressed: _clear , child: textstyle('C'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: _square , child: textstyle('x²'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: _cube , child: textstyle('x³'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style1,  onPressed: _backspace , child:
                    const FittedBox(fit: BoxFit.scaleDown, child: Icon(Icons.backspace),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: _percentage , child: textstyle('%'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: (){_constants('e');} , child: textstyle('e'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: (){_constants('pi');} , child: textstyle('π'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2,  onPressed: (){_operclicked('+');} , child: textstyle('+'),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('7');} , child: textstyle('7'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('8');} , child: textstyle('8'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('9');} , child: textstyle('9'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2,  onPressed: (){_operclicked('-');} , child: textstyle('-'),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('4');} , child: textstyle('4'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('5');} , child: textstyle('5'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('6');} , child: textstyle('6'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2,  onPressed: (){_operclicked('x');} , child: textstyle('x'),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('1');} , child: textstyle('1'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('2');} , child: textstyle('2'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('3');} , child: textstyle('3'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2,  onPressed: (){_operclicked('÷');} , child: textstyle('÷'),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: _changesign , child: textstyle('±'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style3, onPressed: (){_numClicked('0');} , child: textstyle('0'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style2, onPressed: (){_numClicked('.');} , child: textstyle('.'),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: style1,  onPressed: _calculate ,child: textstyle('='),),),
                ],
              ),
            ],),
        ],
      ),
    ),
    );
  }
}