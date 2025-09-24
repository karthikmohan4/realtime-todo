// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/view/shared_todo_page.dart';
import 'package:todo/view/todo_page.dart';
import 'package:todo/view_model/auth_view_model.dart';
import 'package:todo/view_model/todo_view_model.dart' show TodoViewModel;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late AuthViewModel _authVM;
  late TodoViewModel _todoVM;

   @override
  void initState() {
    super.initState();
    _authVM = context.read<AuthViewModel>();
    _todoVM = context.read<TodoViewModel>();

    // Load tasks for current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
 if (_authVM.user!.uid.isNotEmpty) {
      _todoVM.loadMyTasks(_authVM.user!.uid);
      _todoVM.loadSharedTasks(_authVM.user!.uid);
  }
    });
  }

    
  @override
  Widget build(BuildContext context) {
  final AuthViewModel authVM = context.watch<AuthViewModel>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("Todos",style: TextStyle(color: kWhite),),backgroundColor: kPrimaryColor,  actions: [
              IconButton(
                icon: const Icon(Icons.logout,color: kWhite,),
                onPressed: () {
                  authVM.logout();
                  Router.neglect(context, ()=>context.go('/login'))
                  ;
      
                },
              )
            ],
            bottom:  const TabBar(
              tabs: [
                Tab(child: Text("My Todo",style: TextStyle(color: kWhite))),
                Tab(child: Text("Shared Todo",style: TextStyle(color: kWhite))),
              ],
            ),
          
            ),
             floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final titleCtrl = TextEditingController();
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (_authVM.user!.uid.isNotEmpty && titleCtrl.text.isNotEmpty) {
                      await _todoVM.addTask(titleCtrl.text.trim(), _authVM.user!.uid);
                    }
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ), 
          );
        },
      ),
            body: const TabBarView(children: [
              TodoPage(),
              SharedTodoPage()
            ]), 
      ),
    );
  }
  }