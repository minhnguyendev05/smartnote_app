import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../services/note_storage.dart';
import 'note_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Đọc dữ liệu từ thiết bị
  Future<void> _loadNotes() async {
    final notes = await NoteStorage.loadNotes();
    // Sắp xếp theo thời gian cập nhật mới nhất
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    setState(() {
      _allNotes = notes;
      _filterNotes();
      _isLoading = false;
    });
  }

  /// Lọc ghi chú theo từ khóa tìm kiếm (real-time)
  void _filterNotes() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = List.from(_allNotes);
      } else {
        _filteredNotes = _allNotes
            .where((note) =>
                note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  /// Chuyển đến màn hình tạo ghi chú mới
  Future<void> _createNewNote() async {
    final now = DateTime.now();
    final newNote = Note(
      id: const Uuid().v4(),
      title: '',
      content: '',
      createdAt: now,
      updatedAt: now,
    );
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(note: newNote, isNew: true),
      ),
    );
    // Khi quay lại, tự động load lại danh sách
    _loadNotes();
  }

  /// Chuyển đến màn hình sửa ghi chú
  Future<void> _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(note: note, isNew: false),
      ),
    );
    _loadNotes();
  }

  /// Xóa ghi chú với hộp thoại xác nhận
  Future<bool> _confirmDelete(Note note) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content:
            const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (result == true) {
      await NoteStorage.deleteNote(note.id);
      _loadNotes();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Note - Nguyễn Anh Minh - 2351160537',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          _buildSearchBar(),
          // Danh sách ghi chú hoặc trạng thái trống
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotes.isEmpty
                    ? _buildEmptyState()
                    : _buildNoteGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewNote,
        tooltip: 'Thêm ghi chú',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  /// Thanh tìm kiếm M3 style
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xFFECEFEB),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm ghi chú...',
            hintStyle: const TextStyle(
              color: Color(0xFF7A9088),
              fontSize: 15,
            ),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF5C7A6E)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF5C7A6E)),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  /// Trạng thái trống khi không có ghi chú
  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 100,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'Bạn chưa có ghi chú nào,\nhãy tạo mới nhé!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Lưới 2 cột dạng Masonry / Staggered Grid
  Widget _buildNoteGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.only(top: 4, bottom: 80),
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          return _buildNoteCard(note);
        },
      ),
    );
  }

  /// Thẻ ghi chú với Dismissible (vuốt để xóa) — Material Design 3
  Widget _buildNoteCard(Note note) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
          size: 26,
        ),
      ),
      confirmDismiss: (direction) => _confirmDelete(note),
      child: GestureDetector(
        onTap: () => _editNote(note),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tiêu đề
                  if (note.title.isNotEmpty)
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  if (note.title.isNotEmpty && note.content.isNotEmpty)
                    const SizedBox(height: 8),
                  // Nội dung tóm tắt
                  if (note.content.isNotEmpty)
                    Text(
                      note.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Thời gian
                  Text(
                    dateFormat.format(note.updatedAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
