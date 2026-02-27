import 'dart:convert';

class Note {
  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    this.title = '',
    this.content = '',
    required this.createdAt,
    required this.updatedAt,
  });

  /// Tạo Note từ JSON Map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Chuyển Note sang JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Encode danh sách Note thành chuỗi JSON
  static String encodeList(List<Note> notes) {
    final jsonList = notes.map((note) => note.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Decode chuỗi JSON thành danh sách Note
  static List<Note> decodeList(String jsonString) {
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Note.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
