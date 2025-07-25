// lib/domain/models/exercise.dart
import 'package:flutter/material.dart';

class Exercise {
  final int id; // Stable ID for reference in logs
  final String title;
  final Color color;
  final String description;

  const Exercise({required this.id, required this.title, required this.color, required this.description});
}

/// Hard-coded list for v1
/// You can add/remove exercises here. IDs must stay unique and stable.
const List<Exercise> kExercises = [
  Exercise(id: 1, title: 'Push-ups', color: Colors.red, description: 'Classic push-ups focusing on chest and triceps.'),
  Exercise(id: 2, title: 'Squats', color: Colors.blue, description: 'Bodyweight squats to strengthen legs.'),
  Exercise(id: 3, title: 'Pull-ups', color: Colors.green, description: 'Pull-ups to work the back and biceps.'),
];
