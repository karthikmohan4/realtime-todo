import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/model/todo.dart';

class TodoService {

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

Future<void> addEditor(String taskId, String userId) async {
    final taskRef = _db.collection('tasks').doc(taskId);
    await taskRef.update({
      'editors': FieldValue.arrayUnion([userId])
    });
}

 Future<void> addTask(String title, String ownerId) async {
    await _db.collection('tasks').add({
      'title': title,
      'ownerId': ownerId,
      'editors': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
Stream<List<Task>> myTasksStream() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('tasks')
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromDoc(doc)).toList());
  }

   Stream<List<Task>> sharedTasksStream() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('tasks')
        .where('editors', arrayContains: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromDoc(doc)).toList());
  }

  Stream<DocumentSnapshot> taskStream(String taskId) {
    return _db.collection('tasks').doc(taskId).snapshots();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _db.collection('tasks').doc(taskId).update(data);
  }
}
