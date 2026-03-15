import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/trigger_model.dart';
import '../data/trigger_service.dart';

final triggerServiceProvider = Provider((ref) => TriggerService());

final triggersProvider =
    AsyncNotifierProvider<TriggersNotifier, List<TriggerModel>>(
        TriggersNotifier.new);

class TriggersNotifier extends AsyncNotifier<List<TriggerModel>> {
  @override
  Future<List<TriggerModel>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];
    return ref.read(triggerServiceProvider).getTriggers(user.id);
  }

  Future<void> create({
    required int assetId,
    required AlarmCondition condition,
    required double targetPrice,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final trigger = await ref.read(triggerServiceProvider).createTrigger(
          userId: user.id,
          assetId: assetId,
          condition: condition,
          targetPrice: targetPrice,
        );

    final current = state.value ?? [];
    state = AsyncData([trigger, ...current]);
  }

  Future<void> toggle(int triggerId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final updated =
        await ref.read(triggerServiceProvider).toggleTrigger(user.id, triggerId);

    final current = state.value ?? [];
    state = AsyncData(
      current.map((t) => t.id == triggerId ? updated : t).toList(),
    );
  }

  Future<void> remove(int triggerId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    await ref.read(triggerServiceProvider).deleteTrigger(user.id, triggerId);

    final current = state.value ?? [];
    state = AsyncData(current.where((t) => t.id != triggerId).toList());
  }
}
