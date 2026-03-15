import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteModel {
  final String id;
  final String text;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.text,
    required this.createdAt,
  });
}

final notesProvider =
    NotifierProvider<NotesNotifier, List<NoteModel>>(NotesNotifier.new);

class NotesNotifier extends Notifier<List<NoteModel>> {
  @override
  List<NoteModel> build() => [];

  void add(String text) {
    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );
    state = [note, ...state];
  }

  void remove(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}
