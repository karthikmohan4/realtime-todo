import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String ownerId;
  final List<String> editors;
  final DateTime? createdAt;

  Task({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.editors,
    this.createdAt,
  });

  factory Task.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      ownerId: data['ownerId'] ?? '',
      editors: List<String>.from(data['editors'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

   
}