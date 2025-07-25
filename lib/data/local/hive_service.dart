import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker/domain/models/exercise_log.dart';

class HiveService {
  // Singleton
  static final HiveService instance = HiveService._internal();
  HiveService._internal();

  late Box<ExerciseLog> logsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseLogAdapter());
    logsBox = await Hive.openBox<ExerciseLog>('exercise_logs');
  }
}
