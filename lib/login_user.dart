import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });
    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then(
      (value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/homeScreen');
      },
    ).onError(
      (error, stackTrace) {
        AlertDialog(
          title: const Text('Error'),
          content: Container(
            child: Text(error.toString()),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Login Screen")),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "John@gmail.com",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "********",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () {
                          loginUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/signupScreen');
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
