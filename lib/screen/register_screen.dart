import 'package:safe_space/provider/firebase_auth_provider.dart';
import 'package:safe_space/static/firebase_auth_status.dart';
import 'package:safe_space/widgets/text_field_obsecure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
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
              child: Hero(
                tag: 'safe-space',
                child: Image.asset(
                  'assets/images/splash_image.png',
                  height: 300,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 50,
              ),
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
                        "Daftar",
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
                      keyboardType: TextInputType.emailAddress,
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
                    Consumer<FirebaseAuthProvider>(
                      builder: (context, value, child) {
                        if (value.authStatus ==
                            FirebaseAuthStatus.creatingAccount) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          );
                        }
                        return Center(
                          child: SizedBox(
                            width: 211,
                            height: 61,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF78BF91),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: _tapToRegister,
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: _goToLogin,
                        child: const Text.rich(
                          TextSpan(
                            text: "Sudah punya akun? ",
                            style:
                                TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Masuk sekarang",
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
  
  void _tapToRegister() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    if(email.isNotEmpty && password.isNotEmpty){
      final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      await firebaseAuthProvider.createAccount(email, password);
      switch (firebaseAuthProvider.authStatus){
        case FirebaseAuthStatus.accountCreated:
          navigator.pop();
        case _:
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(firebaseAuthProvider.message ?? ""),
          ));
      }
    } else {
      const message = "Email dan kata sandi tidak valid.";

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(message),
      ));
    }
  }

  void _goToLogin(){
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}