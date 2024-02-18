import 'main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'globals.dart' as globals;

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage(title : 'Calculator');
          }
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showErrorMessage(String msg) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: globals.backgroundColor,
        title: Center(child: Text(msg, style: TextStyle(color: globals.textColor))),
      );
    });
  }

  void signUserIn() async {
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator());
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (mounted) {Navigator.pop(context);}
    }
    on FirebaseAuthException catch (e) {
      if (mounted) {Navigator.pop(context);}
      showErrorMessage(e.code);
    }
  }

  void signUserUp() async {
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator());
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (mounted) {Navigator.pop(context);}
    }
    on FirebaseAuthException catch (e) {
      if (mounted) {Navigator.pop(context);}
      showErrorMessage(e.code);
    }
  }

  void darkTheme() {
    setState(() {
      if (!globals.darkEnabled) {
        globals.darkEnabled = true;
        globals.backgroundColor = Colors.black;
        globals.textColor = Colors.white;
        globals.textBoxColor = Colors.white70;
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
        globals.textBoxColor = Colors.white;
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        foregroundColor: Colors.white, backgroundColor: globals.appBarColor,
        title: const Text('Calculator'), centerTitle: true,
        leading: IconButton(icon: Icon(globals.themeIcon),
          onPressed: () {
              setState(() {darkTheme();});
            },),
      ),
      body:
      Container(color: globals.backgroundColor, child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight*0.08),
                Icon(Icons.lock, size: screenHeight*0.12, color: globals.textColor,),
                SizedBox(height: screenHeight*0.05),
                Text(
                  'Welcome!',
                  style: TextStyle(color: globals.textColor, fontSize: 28,),
                  ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Sign in or sign up with your details!',
                  style: TextStyle(
                    color: globals.textColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: screenHeight*0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                  child: TextField(
                          controller: emailController,
                          obscureText: false,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[600])),
                        ),
                ),
                SizedBox(height: screenHeight*0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                  child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey[600])),
                        ),
                ),
                SizedBox(height: screenHeight*0.05),
                uiButton(0.6, 0.08, globals.style1, signUserIn, 'Sign In'),
                SizedBox(height: screenHeight*0.02),
                uiButton(0.6, 0.08, globals.style1, signUserUp, 'Sign Up'),
                SizedBox(height: screenHeight*0.08),
                ]),
            ),
          ),
        ),
      )
    );
  }
}