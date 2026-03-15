import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/note_model.dart';
import '../data/note_service.dart';

final noteServiceProvider = Provider((ref) => NoteService());

final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<NoteModel>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<NoteModel>> {
  @override
  Future<List<NoteModel>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];
    return ref.read(noteServiceProvider).getNotes(user.id);
  }

  Future<void> create({
    required String title,
    required String body,
    int? assetId,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final note = await ref.read(noteServiceProvider).createNote(
          userId: user.id,
          title: title,
          body: body,
          assetId: assetId,
        );

    final current = state.value ?? [];
    state = AsyncData([note, ...current]);
  }

  Future<void> remove(int noteId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await ref.read(noteServiceProvider).deleteNote(user.id, noteId);

    final current = state.value ?? [];
    state = AsyncData(current.where((n) => n.id != noteId).toList());
  }
}
