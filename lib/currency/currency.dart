import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/data.dart' as data;
import '../data/globals.dart' as globals;

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  String convertedAmount = '';
  String givenAmount = '';
  String fromCurr = '';
  String toCurr = '';
  Decimal conversionRate = Decimal.parse('1');
  bool shouldClear = false;

  void getData() async {
    conversionRate = Decimal.parse('1');
    convertedAmount = '';
    if (fromCurr.isEmpty || toCurr.isEmpty || fromCurr == toCurr) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const Center(child: CircularProgressIndicator());
            }));
    try {
	    final response = await http.get(
	      Uri.parse('https://v6.exchangerate-api.com/v6/${data.apiKey}/pair/$fromCurr/$toCurr'),
        headers: {
		      'Content-Type': 'application/json'
        },
      );
	    if (response.statusCode == 200) {
		    final body = jsonDecode(response.body);
        conversionRate = Decimal.parse(body['conversion_rate'].toString());
	    }
      else if (mounted) {
        globals.showErrorMessage('Failed to retrieve data (${response.statusCode})', context);
      }
    }
    catch (err) {
		  if (mounted) globals.showErrorMessage(err.toString(), context);
    }
    finally {
      if (mounted) Navigator.pop(context);
    }
  }

  void convertCurrency() {
    setState(() {
      shouldClear = true;
      if (givenAmount.isEmpty) {
        globals.showErrorMessage('Please enter an amount!', context);
      }
      else if (fromCurr.isEmpty || toCurr.isEmpty) {
        globals.showErrorMessage('Please select currencies!', context);
      }
      else {
        Decimal num = Decimal.parse(givenAmount);
        convertedAmount = (num * conversionRate).toString();
        num = Decimal.parse(convertedAmount);
        if (convertedAmount == givenAmount) {
          convertedAmount = '';
          globals.showErrorMessage('Same currencies selected!', context);
        }
        else {
          convertedAmount = globals.formatNumber(convertedAmount);
          givenAmount = globals.formatNumber(givenAmount);
        }
      }
    });
  }

  void numpadClicked(numC){
    setState(() {
      if (shouldClear == true) {
        clear();
      }
      if (numC=='.'){
        if (!givenAmount.contains('.')){
          givenAmount = givenAmount + numC;
        }
      }
      else {
        givenAmount = givenAmount + numC;
      }
    });
  }

  void backspace(){
    setState(() {
      if (shouldClear == true) {
        clear();
      }
      givenAmount = givenAmount.substring(0, givenAmount.length - 1);
    });
  }

  void clear() {
    setState(() {
      givenAmount = '';
      convertedAmount = '';
      shouldClear = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double btnHeight = screenHeight*0.085;

    SizedBox spacing(double y) {
      return SizedBox(height: screenHeight*y);
    }

    DropdownButton currDropdown(String hint, String value) {
      return DropdownButton(
        hint: Text(hint, style: TextStyle(color: globals.textColor)),
        value: (value.isEmpty)? null : value,
        dropdownColor: globals.backgroundColor,
        style: TextStyle(color: globals.textColor),
        onChanged: (newValue) {
                      setState(() {
                        if (hint == 'From') {
                          fromCurr = newValue.toString();
                        }
                        else if (hint == 'To') {
                          toCurr = newValue.toString();
                        }
                        getData();
                      });
                    },
        items: data.currencies.map((curr) {
          return DropdownMenuItem(value: curr, child: Text(curr),);}).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: globals.appBarColor,
        title: const Text('Currency Converter'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.refresh_outlined), onPressed: () {getData();}),
        ],
      ),
      body: Container(color: globals.backgroundColor, child:
    Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          globals.textBox(screenWidth*0.95, btnHeight, givenAmount),
          globals.textBox(screenWidth*0.95, btnHeight, convertedAmount),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  currDropdown('From', fromCurr),
                  currDropdown('To', toCurr),
                ],
              ),
              spacing(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('7');}, '7'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('8');}, '8'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('9');}, '9'),
                ],
              ),
              spacing(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('4');}, '4'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('5');}, '5'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('6');}, '6'),
                ],
              ),
              spacing(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('1');}, '1'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('2');}, '2'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('3');}, '3'),
                ],
              ),
              spacing(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  globals.uiButton(btnHeight, globals.style2, (){numpadClicked('.');}, '.'),
                  globals.uiButton(btnHeight, globals.style3, (){numpadClicked('0');}, '0'),
                  globals.uiButton(btnHeight, globals.style2, backspace, '⌫'),
                ],
              ),
              spacing(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  globals.uiButton(btnHeight, globals.style2, clear, 'C'),
                  SizedBox(width: screenWidth*0.48, height: btnHeight, child:
                    ElevatedButton(style: globals.style1, onPressed: (){convertCurrency();},
                      child: const Icon(Icons.currency_exchange_outlined)),),
                ],
              ),
            ],),
            ],),
      ),
    );
  }
}