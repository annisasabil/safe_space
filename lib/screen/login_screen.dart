import 'package:safe_space/provider/firebase_auth_provider.dart';
import 'package:safe_space/provider/shared_preference_provider.dart';
import 'package:safe_space/static/firebase_auth_status.dart';
import 'package:safe_space/static/screen_route.dart';
import 'package:safe_space/widgets/text_field_obsecure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Image.asset(
              'assets/images/splash_image.png',
              height: 300,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: const BoxDecoration(
              color: Color(0xFF5976AC),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ), 
                    const SizedBox(height: 32),
                    const Text(
                      "Email",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Masukkan alamat email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kata Sandi",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFieldObsecure(
                      controller: _passwordController,
                      hintText: "Masukkan kata sandi",
                    ),
                    const SizedBox(height: 32),
                    Center(
                    child: SizedBox(
                      width: 211,
                      height: 61,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF78BF91),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _tapToLogin,
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: _goToRegister,
                        child: const Text.rich(
                          TextSpan(
                            text: "Belum punya akun? ",
                            style: TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Yuk daftar sekarang",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();

    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);
    final isLogin = context.read<SharedPreferenceProvider>().isLogin;

    Future.microtask(() async{
      if(isLogin){
        await firebaseAuthProvider.updateProfil();
        navigator.pushReplacementNamed(
          ScreenRoute.chat.name,
        );
      }
    });
  }

  void _tapToLogin() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    if(email.isNotEmpty && password.isNotEmpty){
      final sharedPrefereneceProvider = context.read<SharedPreferenceProvider>();
      final firebaseAutProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      await firebaseAutProvider.signInUser(email, password);
      switch (firebaseAutProvider.authStatus){
        case FirebaseAuthStatus.authenticated:
          await sharedPrefereneceProvider.login();
          navigator.pushReplacementNamed(
            ScreenRoute.chat.name,
          );
        case _:
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(firebaseAutProvider.message ?? ""),
          ));
      }
    } else {
      const message = "Email dan kata sandi tidak valid.";

      final scaffoldMessengger = ScaffoldMessenger.of(context);
      scaffoldMessengger.showSnackBar(const SnackBar(
        content: Text(message),
      ));
    }
  }

  void _goToRegister() async{
    Navigator.pushNamed(
      context,
      ScreenRoute.register.name,
    );
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}