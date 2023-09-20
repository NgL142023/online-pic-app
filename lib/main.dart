import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/screens/auth/login_screen.dart';
import 'package:ig_clone_app4/screens/auth/sign_up_screen.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCMphfdHCVjpRe2qek6SIFewVNdU9-CkWw",
            authDomain: "igclone4-9b84a.firebaseapp.com",
            projectId: "igclone4-9b84a",
            storageBucket: "igclone4-9b84a.appspot.com",
            messagingSenderId: "826738761479",
            appId: "1:826738761479:web:df9907b61510160dd6efa2"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldKey,
        /*theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(color: Colors.black)),*/
        theme: ThemeData.light(),
        routerConfig: _router,
      ),
    );
  }
}

GoRouter _router = GoRouter(initialLocation: "/login", routes: [
  GoRoute(
    name: "login",
    path: "/login",
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: "/sign_up",
    name: "sign_up",
    builder: (context, state) => const SignUpScreen(),
  )
]);
