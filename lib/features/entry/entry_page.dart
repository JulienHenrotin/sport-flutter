// lib/features/entry/entry_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/core/utils/date_utils.dart';
import 'package:workout_tracker/domain/models/exercice.dart';
import 'package:workout_tracker/state/exercise_providers.dart';

class EntryPage extends ConsumerStatefulWidget {
  const EntryPage({super.key});

  @override
  ConsumerState<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<EntryPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with today's values when data is ready.
    Future.microtask(() async {
      final map = await ref.read(todayRepsProvider.future);
      for (final ex in kExercises) {
        _controllers[ex.id] = TextEditingController(text: (map[ex.id] ?? 0).toString());
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Enter repetitions')),
        body: _controllers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...kExercises.map((ex) {
                      final controller = _controllers[ex.id]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: ex.title,
                            prefixIcon: Icon(Icons.fitness_center, color: ex.color),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            final n = int.tryParse(value);
                            if (n == null || n < 0) return 'Invalid number';
                            return null;
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _onSave,
                      icon: const Icon(Icons.save),
                      label: const Text('Save today\'s reps'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(exerciseRepositoryProvider);
    final today = dateOnly(DateTime.now());
    for (final ex in kExercises) {
      final value = int.parse(_controllers[ex.id]!.text);
      await repo.saveReps(exerciseId: ex.id, date: today, reps: value);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully.')),
    );
    // Force refresh of providers that depend on today logs
    ref.invalidate(todayRepsProvider);
    ref.invalidate(lastLogsProvider);
  }
}
