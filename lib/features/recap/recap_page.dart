// lib/features/recap/recap_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/domain/models/exercice.dart';
import 'package:workout_tracker/domain/models/exercise_log.dart';
import 'package:workout_tracker/state/exercise_providers.dart';

class RecapPage extends ConsumerWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastLogsAsync = ref.watch(lastLogsProvider);

    return SafeArea(
      child: lastLogsAsync.when(
        data: (map) {
          return ListView.builder(
            itemCount: kExercises.length,
            itemBuilder: (context, index) {
              final ex = kExercises[index];
              final ExerciseLog? log = map[ex.id];
              final subtitle = log == null ? 'No data yet' : 'Last: ${log.reps} reps on ${_formatDate(log.date)}';
              return ListTile(
                leading: CircleAvatar(backgroundColor: ex.color),
                title: Text(ex.title),
                subtitle: Text(subtitle),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
