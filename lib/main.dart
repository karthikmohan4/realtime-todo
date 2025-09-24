import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/app_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/view_model/auth_view_model.dart';
import 'package:todo/view_model/todo_view_model.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TodoViewModel()),
      ],
      child: const MyApp(),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer( 
  builder: (context, orientation, screenType) {
    return MaterialApp.router(
      title: 'Realtime Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
 ); }
}
