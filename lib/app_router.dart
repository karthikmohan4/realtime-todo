import 'package:go_router/go_router.dart';
import 'package:todo/view/home_page.dart';
import 'package:todo/view/login_page.dart';
import 'package:todo/view/register_page.dart';
import 'package:todo/view/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/task/:id',builder: (context,state)=>SplashPage())
    ],
  );
}
