import 'package:flutter/material.dart';
import 'package:safe_space/firebase_options.dart';
import 'package:safe_space/provider/firebase_auth_provider.dart';
import 'package:safe_space/provider/shared_preference_provider.dart';
import 'package:safe_space/screen/chat_screen.dart';
import 'package:safe_space/screen/login_screen.dart';
import 'package:safe_space/screen/register_screen.dart';
import 'package:safe_space/screen/splash_screen.dart';
import 'package:safe_space/screen/welcome_screen.dart';
import 'package:safe_space/services/firebase_auth_service.dart';
import 'package:safe_space/services/firebase_firestore_service.dart';
import 'package:safe_space/services/shared_preferences_service.dart';
import 'package:safe_space/static/screen_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => SharedPreferencesService(pref),
      ),
      ChangeNotifierProvider(
        create: (context) => SharedPreferenceProvider(
          context.read<SharedPreferencesService>(),
        ),
      ),
      Provider(
        create: (context) => Firebaseauthservice(
          firebaseAuth,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => FirebaseAuthProvider(
          context.read<Firebaseauthservice>(),
        ),
      ),
      Provider(
        create: (context) => FirebaseFirestoreService(
          firebaseFirestore,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeSpace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5976AC)),
        useMaterial3: true,
      ),
      initialRoute: ScreenRoute.splash.name,
      routes: {
        ScreenRoute.welcome.name: (context) => const WelcomeScreen(),
        ScreenRoute.splash.name: (context) => const SplashScreen(),
        ScreenRoute.login.name: (context) => const LoginScreen(),
        ScreenRoute.register.name: (context) => const RegisterScreen(),
        ScreenRoute.chat.name: (context) => const ChatScreen(),
      },
    );
  }
}