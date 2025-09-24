import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo/view_model/todo_view_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
   final todoVM = context.watch<TodoViewModel>();

    final tasks = todoVM.myTasks;

    if (tasks.isEmpty) return const Center(child: Text('No tasks found'));

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final task = tasks[i];
        return ListTile(
          title: Text(task.title),
         subtitle: Text("Shared users: ${task.editors.length} "),
          trailing: IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
               final link = 'https://www.todo.com/task/${task.id}';
               SharePlus.instance.share(ShareParams(text: 'Open this task: $link'));
            },
          ),
          onTap: () {
            showDialog(
            context: context,
            builder: (ctx) => 
            AlertDialog(
              title: Text("Edit Task"),
              content: TextField(
                controller: TextEditingController(text: task.title),
                onChanged: (val) {
                  todoVM.updateTask(task.id, task, val);
                },
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                
              ],
            )
            );
          },
        );
      },
    );
  }
  }
