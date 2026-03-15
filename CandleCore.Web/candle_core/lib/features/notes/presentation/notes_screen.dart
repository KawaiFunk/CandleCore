import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/common/empty_state.dart';
import '../providers/notes_provider.dart';
import 'widgets/add_note_sheet.dart';
import 'widgets/note_card.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  void _showAddNoteSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddNoteSheet(
        onSave: (title, body, assetId) async {
          await ref.read(notesProvider.notifier).create(
                title: title,
                body: body,
                assetId: assetId,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteSheet(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: notesAsync.when(
        data: (notes) => notes.isEmpty
            ? const EmptyState(
                icon: Icons.sticky_note_2_outlined,
                title: 'No notes yet',
                subtitle: 'Tap the + button to add your first trading note.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: notes.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onDelete: () =>
                        ref.read(notesProvider.notifier).remove(note.id),
                  );
                },
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
        error: (_, __) => const EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load notes',
          subtitle: 'Pull down to refresh.',
        ),
      ),
    );
  }
}
