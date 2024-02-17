import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
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
      home: const AuthPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  // final user = FirebaseAuth.instance.currentUser!;

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

  var style1 = ElevatedButton.styleFrom(backgroundColor: Colors.red.shade500, foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
  var style2 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade500, foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),);
  var style3 = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange.shade300, foregroundColor: Colors.white,
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
      oper = '';
      num1 = 0.0;
      num2 = 0.0;
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
        _setprecision();
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
      temp = double.parse(ans) * (-1.0);
      ans = temp.toString();
      _setprecision();
      justcalc == false;
    });
  }

  void _percentage(){
    setState(() {
      temp = double.parse(ans) / 100.0;
      ans = temp.toString();
      _setprecision();
      justcalc == true;
    });
  }

  void _constants(k){
    setState(() {
      if (justcalc == true) {
        _clear();
      }
      if (k == 'π') {
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
      temp = double.parse(ans);
      ans = (temp * temp).toString();
      _setprecision();
      justcalc == true;
    });
  }

  void _cube() {
    setState(() {
      temp = double.parse(ans);
      ans = (temp * temp * temp).toString();
      _setprecision();
      justcalc == true;
    });
  }

  void _setprecision(){
    setState(() {
      temp = double.parse(ans);
      if ((temp - (temp.round()).toDouble()).abs() < 1e-12) {
        ans = (temp.round()).toString();
      }
      temp = double.parse(prev);
      if (prev.isNotEmpty && (temp - (temp.round()).toDouble()).abs() < 1e-12) {
          prev = ((double.parse(prev)).round()).toString();
      }
      ans = ans.toString();
      prev = prev.toString();
    });
  }

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
          backgroundColor: Colors.red.shade500, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style2 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
        style3 = ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),);
      }
    });
  }

  void _signout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SizedBox uiButton(double x, double y, ButtonStyle style, void Function() func, String txt) {
      return SizedBox(width: screenWidth*x, height: screenHeight*y, child:
      ElevatedButton(style: style, onPressed: func, child:
      FittedBox(fit: BoxFit.scaleDown, child: Text(txt, style: const TextStyle(fontSize: 40),),),),);
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
            },),
            IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                _signout();
              });
            },)
            ],
      ),

      body:
    Container(color: backgroundColor, child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: textboxColor), onPressed: null,
            child: Text(prev, style: Theme.of(context).textTheme.headlineSmall,),),),
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: textboxColor), onPressed: null,
            child: Text(ans, style: Theme.of(context).textTheme.headlineSmall,),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style1, _clear, 'C'),
                  uiButton(0.18, 0.085, style2, _square, 'x²'),
                  uiButton(0.18, 0.085, style2, _cube, 'x³'),
                  uiButton(0.18, 0.085, style1, _backspace, '⌫'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style2, _percentage, '%'),
                  uiButton(0.18, 0.085, style2, (){_constants('e');}, 'e'),
                  uiButton(0.18, 0.085, style2, (){_constants('π');}, 'π'),
                  uiButton(0.18, 0.085, style2, (){_operclicked('+');}, '+'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style3, (){_numClicked('7');}, '7'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('8');}, '8'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('9');}, '9'),
                  uiButton(0.18, 0.085, style2, (){_operclicked('-');}, '-'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style3, (){_numClicked('4');}, '4'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('5');}, '5'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('6');}, '6'),
                  uiButton(0.18, 0.085, style2, (){_operclicked('x');}, 'x'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style3, (){_numClicked('1');}, '1'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('2');}, '2'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('3');}, '3'),
                  uiButton(0.18, 0.085, style2, (){_operclicked('÷');}, '÷'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, style2, _changesign, '±'),
                  uiButton(0.18, 0.085, style3, (){_numClicked('0');}, '0'),
                  uiButton(0.18, 0.085, style2, (){_numClicked('.');}, '.'),
                  uiButton(0.18, 0.085, style1, _calculate, '='),
                ],
              ),
            ],),
        ],
      ),
    ),
    );
  }
}