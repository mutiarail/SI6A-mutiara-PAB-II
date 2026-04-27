import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String title;
  String description;
  String? imageBase64;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageBase64,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Membuat Note dari document Firestore
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageBase64: data['imageBase64'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Konversi Note ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageBase64': imageBase64,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
