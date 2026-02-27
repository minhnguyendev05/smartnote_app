import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteStorage {
  static const String _storageKey = 'smart_note_data';

  /// Đọc tất cả ghi chú từ SharedPreferences
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return Note.decodeList(jsonString);
  }

  /// Lưu toàn bộ danh sách ghi chú vào SharedPreferences
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = Note.encodeList(notes);
    await prefs.setString(_storageKey, jsonString);
  }

  /// Thêm hoặc cập nhật một ghi chú
  static Future<void> saveNote(Note note) async {
    final notes = await loadNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      notes[index] = note;
    } else {
      notes.add(note);
    }
    await saveNotes(notes);
  }

  /// Xóa một ghi chú theo id
  static Future<void> deleteNote(String id) async {
    final notes = await loadNotes();
    notes.removeWhere((n) => n.id == id);
    await saveNotes(notes);
  }
}
