// lib/features/today/today_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/domain/models/exercice.dart';
import 'package:workout_tracker/state/exercise_providers.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(todayRepsProvider);

    return SafeArea(
      child: todayAsync.when(
        data: (map) {
          return ListView.builder(
            itemCount: kExercises.length,
            itemBuilder: (context, index) {
              final ex = kExercises[index];
              final reps = map[ex.id] ?? 0;
              return ListTile(
                leading: CircleAvatar(backgroundColor: ex.color),
                title: Text(ex.title),
                subtitle: Text('Today: $reps reps'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
