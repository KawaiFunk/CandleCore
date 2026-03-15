import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/common/empty_state.dart';
import '../providers/triggers_provider.dart';
import 'widgets/add_trigger_sheet.dart';
import 'widgets/trigger_card.dart';

class TriggersScreen extends ConsumerWidget {
  const TriggersScreen({super.key});

  void _showAddTriggerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTriggerSheet(
        onSave: (assetId, condition, targetPrice) async {
          await ref.read(triggersProvider.notifier).create(
                assetId: assetId,
                condition: condition,
                targetPrice: targetPrice,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final triggersAsync = ref.watch(triggersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Alerts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTriggerSheet(context, ref),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: triggersAsync.when(
        data: (triggers) => triggers.isEmpty
            ? const EmptyState(
                icon: Icons.notifications_none_outlined,
                title: 'No price alerts',
                subtitle: 'Tap the + button to set a price alert.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: triggers.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final trigger = triggers[index];
                  return TriggerCard(
                    trigger: trigger,
                    onToggle: () =>
                        ref.read(triggersProvider.notifier).toggle(trigger.id),
                    onDelete: () =>
                        ref.read(triggersProvider.notifier).remove(trigger.id),
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
          title: 'Failed to load alerts',
          subtitle: 'Pull down to refresh.',
        ),
      ),
    );
  }
}
