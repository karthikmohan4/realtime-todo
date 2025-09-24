import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/view_model/todo_view_model.dart';

class SharedTodoPage extends StatefulWidget {
  const SharedTodoPage({super.key});

  @override
  State<SharedTodoPage> createState() => _SharedTodoPageState();
}

class _SharedTodoPageState extends State<SharedTodoPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();
    final tasks = viewModel.sharedTasks;

    return Scaffold(
      body:
          tasks.isEmpty
              ? const Center(child: Text("No tasks shared with you"))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final titleController = TextEditingController(
                    text: task.title,
                  );

                  return ListTile(
                    trailing: Icon(Icons.task, size: 18.sp),
                    tileColor: kLightGrey,
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          titleController.text = val;

                          viewModel.updateTask(
                            task.id,
                            task,
                            titleController.text,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
