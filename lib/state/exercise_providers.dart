import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/data/local/hive_service.dart';
import 'package:workout_tracker/data/repositories/exercise_repository.dart';
import 'package:workout_tracker/domain/models/exercice.dart';
import 'package:workout_tracker/domain/models/exercise_log.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService.instance);

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final service = ref.watch(hiveServiceProvider);
  return ExerciseRepository(service);
});

final todayRepsProvider = FutureProvider<Map<int, int>>((ref) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  final ids = kExercises.map((e) => e.id).toList();
  return repo.getTodayReps(ids);
});

final lastLogsProvider = FutureProvider<Map<int, ExerciseLog?>>((ref) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  final ids = kExercises.map((e) => e.id).toList();
  return repo.getLastLogsForExercises(ids);
});

final entryTempStateProvider = StateProvider<Map<int, String>>((ref) => {});
