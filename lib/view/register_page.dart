// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/view_model/auth_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
 final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(15.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Center(
            child: SizedBox(
              height: 10.h,
              
              child: Text("Realtime Todo",style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w400,color: kPrimaryColor),),
            
            ),
          ),
            TextField(
              controller: emailCtrl,
              
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed: () async {
                final err = await authVM.create(emailCtrl.text, passCtrl.text);
                if (err == null) {
                 context.go('/home');
                }
              },
              child: const Text("Register",style: TextStyle(color: kWhite)),
            ),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Already have an account? login",style: TextStyle(color: kPrimaryColor)),
            ),
          ],
        ),
      ),
    );
  }
  
}