import 'package:flutter/material.dart';
import 'package:todo/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/services/todo_service.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoService _todoService = TodoService();

  List<Task> _myTasks = [];
  List<Task> _sharedTasks = [];
  bool _isLoading = false;

  List<Task> get myTasks => _myTasks;
  List<Task> get sharedTasks => _sharedTasks;
  bool get isLoading => _isLoading;
   Stream<List<Task>> get myTasksStream => _todoService.myTasksStream();
  Stream<List<Task>> get sharedTasksStream => _todoService.sharedTasksStream();

  TodoViewModel() {
    _listenToSharedTasks() ;
    _listenToOwnerTasks();
  }
  void _listenToSharedTasks() {
    _todoService.myTasksStream().listen((tasksList) {
      _myTasks = tasksList; // update local list
      notifyListeners(); // rebuild UI
    });
  }

  void _listenToOwnerTasks() {
    _todoService.sharedTasksStream().listen((tasksList) {
      _sharedTasks = tasksList; // update local list
      notifyListeners(); // rebuild UI
    });
  }

  Future<void> loadMyTasks(String userId) async {
    _isLoading = true;
    notifyListeners();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('tasks')
            .where('ownerId', isEqualTo: userId)
            .get();

    _myTasks = snapshot.docs.map((doc) => Task.fromDoc(doc)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSharedTasks(String userId) async {
    _isLoading = true;
    notifyListeners();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('tasks')
            .where('editors', arrayContains: userId)
            .get();

    _sharedTasks = snapshot.docs.map((doc) => Task.fromDoc(doc)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String ownerId) async {
    await _todoService.addTask(title, ownerId);
    await loadMyTasks(ownerId);
  }

  Future<void> updateTask(String taskId, Task task, String   data) async {
    if (data.trim().isEmpty || data == task.title) return;

    final updatedTask = {
      'title': data,
      'ownerId': task.ownerId,
      'editors': task.editors,
      'createdAt': task.createdAt,
    };

    _todoService.updateTask(taskId, updatedTask);
    _listenToOwnerTasks();
  }
}
