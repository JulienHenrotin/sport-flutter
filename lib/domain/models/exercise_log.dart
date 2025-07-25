import 'package:hive/hive.dart';

part 'exercise_log.g.dart';

@HiveType(typeId: 0)
class ExerciseLog {
  @HiveField(0)
  int exerciseId;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int reps;

  ExerciseLog({
    required this.exerciseId,
    required this.date,
    required this.reps,
  });
}
