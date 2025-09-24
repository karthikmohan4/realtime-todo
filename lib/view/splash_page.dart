// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/deep_link_service.dart';
import 'package:todo/view_model/auth_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
void initState() {
  super.initState();
  _checkAuth();
}

Future<void> _checkAuth()async{
  await Future.delayed(Duration(seconds: 2));
   await DeepLinkService().init(context);
  final authData = context.read<AuthViewModel>();
  if(authData.isLogged){
    context.go('/home');
  }else {
    context.go('/login');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}