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

  void _backspace(){
    setState(() {
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
    });
  }

  void _calculate() {
    setState(() {
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
    });
  }

  void _numClicked(numC){
    setState(() {
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
      if (ans.isNotEmpty) {
        prev = ans;
        if (oper != '') {
          _calculate();
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
    });
  }

  void _percentage(){
    setState(() {
      temp = double.parse(ans) * 100.0;
      ans = temp.toString();
      _checkifint();
    });
  }

  void _constants(k){
    setState(() {
      if (k == 'pi') {
        ans = '3.14159';
      }
      else if (k == 'e') {
        ans = '2.71828';
      }
    });
  }

  void _square() {
    setState(() {
      temp = double.parse(ans) * double.parse(ans);
      ans = temp.toString();
      _checkifint();
    });
  }

  void _cube() {
    setState(() {
      temp = double.parse(ans) * double.parse(ans) * double.parse(ans);
      ans = temp.toString();
      _checkifint();
    });
  }

  void _checkifint(){
    if ((double.parse(ans)-((double.parse(ans)).round()).toDouble())==0.0) {
      ans = ((double.parse(ans)).round()).toString();
    }
    if (prev.isNotEmpty) {
      if ((double.parse(prev)-((double.parse(prev)).round()).toDouble())==0.0) {
        prev = ((double.parse(prev)).round()).toString();
      }
    }
  }

  void _nullfunction() {}

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar( foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange.shade800,
        title: Text(widget.title),centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () {_nullfunction();},),],
      ),

      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: _nullfunction,
            child: Text(prev, style: Theme.of(context).textTheme.headlineSmall,),),),
          SizedBox(width: screenWidth*0.975, height: screenHeight*0.07, child: OutlinedButton(style: TextButton.styleFrom
            (shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: _nullfunction,
            child: Text(ans, style: Theme.of(context).textTheme.headlineSmall,),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: _clear , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('C', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: _square , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('x²', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: _cube , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('x³', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),  onPressed: _calculate , child: const FittedBox(fit: BoxFit.scaleDown, child: FittedBox(fit: BoxFit.scaleDown, child: Text('=', style: TextStyle(fontSize: 40),),),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: _percentage , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('%', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_constants('e');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('e', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_constants('pi');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('π', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),  onPressed: (){_operclicked('+');} , child: const FittedBox(fit: BoxFit.scaleDown, child: FittedBox(fit: BoxFit.scaleDown, child: Text('+', style: TextStyle(fontSize: 40),),),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('7');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('7', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('8');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('8', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('9');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('9', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),  onPressed: (){_operclicked('-');} , child: const FittedBox(fit: BoxFit.scaleDown, child: FittedBox(fit: BoxFit.scaleDown, child: Text('-', style: TextStyle(fontSize: 40),),),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('4');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('4', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('5');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('5', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('6');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('6', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),  onPressed: (){_operclicked('x');} , child: const FittedBox(fit: BoxFit.scaleDown, child: FittedBox(fit: BoxFit.scaleDown, child: Text('x', style: TextStyle(fontSize: 40),),),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('1');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('1', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('2');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('2', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('3');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('3', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),  onPressed: (){_operclicked('÷');} , child: const FittedBox(fit: BoxFit.scaleDown, child: FittedBox(fit: BoxFit.scaleDown, child: Text('÷', style: TextStyle(fontSize: 40),),),),),),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: _changesign , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('±', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade50,
                    foregroundColor: Colors.deepOrange.shade900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ), onPressed: (){_numClicked('0');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('0', style: TextStyle(fontSize: 40),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                    ElevatedButton(style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ), onPressed: (){_numClicked('.');} , child: const FittedBox(fit: BoxFit.scaleDown, child: Text('.', style: TextStyle(fontSize: 30),),),),),
                  SizedBox(width: screenWidth*0.18, height: screenHeight*0.085, child:
                    ElevatedButton(style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),  onPressed: _backspace , child: const FittedBox(fit: BoxFit.scaleDown, child: Icon(Icons.backspace_outlined),),),),
                ],
              ),
            ],),
        ],
      ),
    );
  }
}