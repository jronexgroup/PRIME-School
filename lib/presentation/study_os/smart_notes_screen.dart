import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/smart_notes_service.dart';
import '../../blocs/study_os/study_os_bloc.dart';

class SmartNotesScreen extends StatefulWidget {
  const SmartNotesScreen({super.key});

  @override
  State<SmartNotesScreen> createState() => _SmartNotesScreenState();
}

class _SmartNotesScreenState extends State<SmartNotesScreen> {
  final _searchCtrl = TextEditingController();
  List<SmartNote> _notes = [];
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadNotes() {
    final notesService = context.read<StudyOsBloc>().smartNotesService;
    setState(() => _notes = notesService.getAllNotes());
  }

  void _showNoteEditor({SmartNote? existing}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _NoteEditor(note: existing, onSaved: _loadNotes),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get smartNotesService from bloc via provider
    final bloc = context.read<StudyOsBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_showSearch ? 'Search' : 'Smart Notes', style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded, size: 20),
            onPressed: () => setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) _searchCtrl.clear();
            }),
          ),
        ],
        bottom: _showSearch
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (_) {
                      final notesService = context.read<StudyOsBloc>().smartNotesService;
                      setState(() => _notes = notesService.searchNotes(_searchCtrl.text));
                    },
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 48, color: AppColors.studyOs.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No notes yet', style: TextStyle(fontSize: 16, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                  const SizedBox(height: 8),
                  Text('Tap + to create your first note', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (_, i) {
                final note = _notes[i];
                final dateStr = '${note.updatedAt.day}/${note.updatedAt.month}';
                return Dismissible(
                  key: Key(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    final notesService = context.read<StudyOsBloc>().smartNotesService;
                    await notesService.deleteNote(note.id);
                    _loadNotes();
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    child: ListTile(
                      title: Text(note.title.isEmpty ? 'Untitled' : note.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                      subtitle: Text(
                        note.content.length > 60 ? '${note.content.substring(0, 60)}...' : note.content,
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(dateStr, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      onTap: () => _showNoteEditor(existing: note),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(),
        backgroundColor: AppColors.studyOs,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

class _NoteEditor extends StatefulWidget {
  final SmartNote? note;
  final VoidCallback onSaved;

  const _NoteEditor({this.note, required this.onSaved});

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final notesService = context.read<StudyOsBloc>().smartNotesService;
    if (widget.note != null) {
      widget.note!.title = _titleCtrl.text;
      widget.note!.content = _contentCtrl.text;
      await notesService.updateNote(widget.note!);
    } else {
      await notesService.createNote(
        title: _titleCtrl.text,
        content: _contentCtrl.text,
      );
    }
    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'New Note', style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: 'Note title...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Write your notes here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
