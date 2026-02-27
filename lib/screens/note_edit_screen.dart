import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_storage.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NoteEditScreen({
    super.key,
    required this.note,
    required this.isNew,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _originalTitle;
  late String _originalContent;

  @override
  void initState() {
    super.initState();
    _originalTitle = widget.note.title;
    _originalContent = widget.note.content;
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Auto-save: Tự động lưu khi người dùng thoát màn hình
  Future<void> _autoSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Nếu là ghi chú mới và cả 2 trường đều trống thì không lưu
    if (widget.isNew && title.isEmpty && content.isEmpty) {
      return;
    }

    // Chỉ lưu nếu nội dung thực sự thay đổi so với lúc mở
    final hasChanged = title != _originalTitle || content != _originalContent;
    if (!hasChanged && !widget.isNew) {
      return;
    }

    widget.note.title = title;
    widget.note.content = content;
    widget.note.updatedAt = DateTime.now();

    await NoteStorage.saveNote(widget.note);
  }

  /// Xử lý sự kiện Back: lưu rồi mới pop
  Future<void> _saveAndPop() async {
    await _autoSave();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Chặn pop tự động để ta tự xử lý auto-save trước
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // đã pop rồi thì bỏ qua
        await _saveAndPop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _saveAndPop,
          ),
          title: const Text('Soạn ghi chú'),
          elevation: 0,
          surfaceTintColor:
              Theme.of(context).colorScheme.surfaceTint,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Ô nhập tiêu đề — ẩn viền, style tối giản
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Tiêu đề',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: 8),
              // Ô nhập nội dung — đa dòng, tự động giãn
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập nội dung ghi chú...',
                    hintStyle: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
