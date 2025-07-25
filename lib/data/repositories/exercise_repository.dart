import 'package:workout_tracker/core/utils/date_utils.dart';
import 'package:workout_tracker/data/local/hive_service.dart';
import 'package:workout_tracker/domain/models/exercise_log.dart';

class ExerciseRepository {
  final HiveService _service;

  ExerciseRepository(this._service);

  Future<void> saveReps({required int exerciseId, required DateTime date, required int reps}) async {
    final d = dateOnly(date);
    final key = _service.logsBox.keys.firstWhere(
      (k) {
        final log = _service.logsBox.get(k);
        return log != null && log.exerciseId == exerciseId && dateOnly(log.date) == d;
      },
      orElse: () => null,
    );

    if (key != null) {
      final log = _service.logsBox.get(key)!;
      log.reps = reps;
      await _service.logsBox.put(key, log);
    } else {
      await _service.logsBox.add(ExerciseLog(exerciseId: exerciseId, date: d, reps: reps));
    }
  }

  Future<int> getRepsForDate({required int exerciseId, required DateTime date}) async {
    final d = dateOnly(date);
    final log = _service.logsBox.values.firstWhere(
      (l) => l.exerciseId == exerciseId && dateOnly(l.date) == d,
      orElse: () => null as ExerciseLog,
    );
    return log.reps ?? 0;
  }

  Future<Map<int, ExerciseLog?>> getLastLogsForExercises(List<int> exerciseIds) async {
    final map = <int, ExerciseLog?>{};
    for (final id in exerciseIds) {
      final logs = _service.logsBox.values.where((l) => l.exerciseId == id).toList()..sort((a, b) => b.date.compareTo(a.date));
      map[id] = logs.isEmpty ? null : logs.first;
    }
    return map;
  }

  Future<List<ExerciseLog>> getLogsForExerciseInRange({
    required int exerciseId,
    required DateTime from,
    required DateTime to,
  }) async {
    final f = dateOnly(from);
    final t = dateOnly(to);
    final logs = _service.logsBox.values.where((l) {
      final d = dateOnly(l.date);
      return l.exerciseId == exerciseId && !d.isBefore(f) && !d.isAfter(t);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return logs;
  }

  Future<Map<int, int>> getTodayReps(List<int> exerciseIds) async {
    final today = dateOnly(DateTime.now());
    final map = {for (final id in exerciseIds) id: 0};
    for (final log in _service.logsBox.values) {
      if (dateOnly(log.date) == today) {
        map[log.exerciseId] = log.reps;
      }
    }
    return map;
  }
}
