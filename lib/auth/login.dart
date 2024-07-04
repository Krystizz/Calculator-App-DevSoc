import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../calculator/homepage.dart';
import '../globals.dart' as globals;

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
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

  void signUserIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      globals.showErrorMessage(
          'Please fill in your authentication details!', context);
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        globals.showErrorMessage(
            'Authentication Error (${e.code}: ${e.message})', context);
      }
    }
  }

  void signUserUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      globals.showErrorMessage(
          'Please fill in your authentication details!', context);
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        globals.showErrorMessage(
            'Authentication Error (${e.code}: ${e.message})', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    SizedBox spacing(double y) {
      return SizedBox(height: screenHeight * y);
    }

    SizedBox loginButton(double x, double y, ButtonStyle style,
        void Function() func, String txt) {
      return SizedBox(
        width: screenWidth * x,
        height: screenHeight * y,
        child: ElevatedButton(
          style: style,
          onPressed: func,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                txt,
                style: const TextStyle(fontSize: 25),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
            ],
          ),
        ),
      );
    }

    Padding loginText(TextEditingController ctr, bool obscure, String hint) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: TextField(
            controller: ctr,
            obscureText: obscure,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            style: TextStyle(color: globals.textColor, fontSize: 18),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: globals.textBoxColor,
                filled: true,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade500)),
          ));
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: globals.appBarColor,
          title: const Text('Sign In'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(globals.themeIcon),
              onPressed: () {
                setState(() {
                  globals.darkTheme();
                });
              },
            ),
          ],
        ),
        body: Container(
          color: globals.backgroundColor,
          width: screenWidth,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: screenHeight * 0.12,
                        color: globals.textColor,
                      ),
                      spacing(0.04),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          color: globals.textColor,
                          fontSize: 25,
                        ),
                      ),
                      spacing(0.02),
                      Text(
                        'Sign in or sign up with your details!',
                        style: TextStyle(
                          color: globals.textColor,
                          fontSize: 18,
                        ),
                      ),
                      spacing(0.05),
                      loginText(emailController, false, 'Email'),
                      spacing(0.02),
                      loginText(passwordController, true, 'Password'),
                      spacing(0.05),
                      loginButton(
                          0.6, 0.08, globals.style1, signUserIn, 'Sign In'),
                      spacing(0.02),
                      loginButton(
                          0.6, 0.08, globals.style1, signUserUp, 'Sign Up'),
                    ]),
              ),
            ),
          ),
        ));
  }
}
