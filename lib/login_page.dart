import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage(title : 'Calculator');
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
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text(msg, style: const TextStyle(color: Colors.white))),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock,size: 60,),
                const SizedBox(height: 50),
            
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  'Sign in or sign up with your details!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                ),
                const SizedBox(height: 10),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                ),
                const SizedBox(height: 50),
            
                GestureDetector(
                  onTap: signUserIn,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8),),
                    child: const Center(child: Text("Sign In",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),
                    ),),),),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: signUserUp,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8),),
                    child: const Center(child: Text("Sign Up",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),
                    ),),),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}