import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'apikey.dart' as apikey;
import 'dart:convert';

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
  double conversionRate = 1;
  List<String> currencies = ['AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD',
    'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV',
    'BRL', 'BSD', 'BTN', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF', 'CHW', 'CLF',
    'CLP', 'CNY', 'COP', 'COU', 'CRC', 'CUC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP',
    'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD',
    'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR',
    'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD', 'KYD',
    'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK',
    'MNT', 'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MXV', 'MYR', 'MZN', 'NAD', 'NGN',
    'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG',
    'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP',
    'SLE', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND',
    'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'UYI', 'UYU', 'UYW',
    'UZS', 'VED', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA', 'XBB', 'XBC',
    'XBD', 'XCD', 'XDR', 'XOF', 'XPD', 'XPF', 'XPT', 'XSU', 'XTS', 'XUA', 'XXX', 'YER',
    'ZAR', 'ZMW', 'ZWL'];
  bool shouldClear = false;

  void showErrorMessage(String msg) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: globals.backgroundColor,
        title: Center(child: Text(msg, style: TextStyle(color: globals.textColor))),
      );
    });
  }

  void getData() async {
    conversionRate = 1;
    convertedAmount = '';
    if (fromCurr.isEmpty || toCurr.isEmpty || fromCurr == toCurr) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const Center(child: CircularProgressIndicator());
            }));
    try {
	    final response = await http.get(
	      Uri.parse('https://v6.exchangerate-api.com/v6/${apikey.apiKey}/pair/$fromCurr/$toCurr'),
        headers: {
		      'Content-Type': 'application/json'
        },
      );
	    if (response.statusCode == 200) {
		    final body = jsonDecode(response.body);
        conversionRate = body['conversion_rate'];
	    }
      else {
        showErrorMessage(response.statusCode.toString());
      }
    }
    catch (err) {
		  showErrorMessage(err.toString());
    }
    finally {
      if (context.mounted) Navigator.pop(context);
    }
  }

  void convertCurrency() {
    setState(() {
      shouldClear = true;
      if (givenAmount.isNotEmpty) {
        double num = double.parse(givenAmount);
        convertedAmount = (num * conversionRate).toString();
        num = double.parse(convertedAmount);
        if ((num - num.round().toDouble()).abs() < 1e-12) {
            convertedAmount = num.round().toString();
        }
        if (convertedAmount == givenAmount) {
          convertedAmount = '';
          showErrorMessage('Select different currencies');
        }
      }
      else {
        shouldClear = false;
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

    SizedBox uiButton(double x, double y, ButtonStyle style,
      void Function() func, String txt) {
        return SizedBox(width: screenWidth*x, height: screenHeight*y, child:
          ElevatedButton(style: style, onPressed: func, child:
            FittedBox(fit: BoxFit.scaleDown, child: Text(txt,
              style: const TextStyle(fontSize: 40),),),),);
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
          SizedBox(width: screenWidth*0.92, height: screenHeight*0.07, child:
            OutlinedButton(style: TextButton.styleFrom(shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: globals.textBoxColor), onPressed: null, child:
                  Text(givenAmount, style: TextStyle(fontSize: 25, color: globals.textColor)),),),
          SizedBox(width: screenWidth*0.92, height: screenHeight*0.07, child:
            OutlinedButton(style: TextButton.styleFrom(shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: globals.textBoxColor), onPressed: null, child:
                  Text(convertedAmount, style: TextStyle(fontSize: 25, color: globals.textColor)),),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton(
                    hint: Text('From', style: TextStyle(color: globals.textColor)),
                    value: (fromCurr.isEmpty)? null : fromCurr,
                    dropdownColor: globals.backgroundColor,
                    style: TextStyle(color: globals.textColor),
                    onChanged: (newValue) {
                      setState(() {
                        fromCurr = newValue.toString();
                        getData();
                      });
                    },
                    items: currencies.map((curr) {
                      return DropdownMenuItem(
                        value: curr,
                        child: Text(curr),
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    hint: Text('To', style: TextStyle(color: globals.textColor)),
                    value: (toCurr.isEmpty)? null : toCurr,
                    dropdownColor: globals.backgroundColor,
                    style: TextStyle(color: globals.textColor),
                    onChanged: (newValue) {
                      setState(() {
                        toCurr = newValue.toString();
                        getData();
                      });
                    },
                    items: currencies.map((curr) {
                      return DropdownMenuItem(
                        value: curr,
                        child: Text(curr),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('7');}, '7'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('8');}, '8'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('9');}, '9'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('4');}, '4'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('5');}, '5'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('6');}, '6'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('1');}, '1'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('2');}, '2'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('3');}, '3'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, globals.style2, (){numpadClicked('.');}, '.'),
                  uiButton(0.18, 0.085, globals.style3, (){numpadClicked('0');}, '0'),
                  uiButton(0.18, 0.085, globals.style2, backspace, '⌫'),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  uiButton(0.18, 0.085, globals.style2, clear, 'C'),
                  SizedBox(width: screenWidth*0.48, height: screenHeight*0.085, child:
                    ElevatedButton(style: globals.style1, onPressed: (){convertCurrency();}, child:
                      const Icon(Icons.currency_exchange_outlined)),),
                ],
              ),
            ],),
            ],),
      ),
    );
  }
}