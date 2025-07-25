// lib/features/stats/stats_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workout_tracker/domain/models/exercice.dart';
import 'package:workout_tracker/domain/models/exercise_log.dart';
import 'package:workout_tracker/state/exercise_providers.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  Exercise _selectedExercise = kExercises.first;
  List<ExerciseLog> _logs = [];
  bool _loading = true;
  DateTimeRange _range = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 14)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _loading = true);
    final repo = ref.read(exerciseRepositoryProvider);
    final logs = await repo.getLogsForExerciseInRange(
      exerciseId: _selectedExercise.id,
      from: _range.start,
      to: _range.end,
    );
    setState(() {
      _logs = logs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: _pickDateRange,
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButton<Exercise>(
                      value: _selectedExercise,
                      onChanged: (ex) {
                        if (ex == null) return;
                        setState(() => _selectedExercise = ex);
                        _fetchLogs();
                      },
                      items: kExercises.map((ex) {
                        return DropdownMenuItem(
                          value: ex,
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: ex.color, radius: 8),
                              const SizedBox(width: 8),
                              Text(ex.title),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(child: _buildChart()),
                ],
              ),
      ),
    );
  }

  Widget _buildChart() {
    if (_logs.isEmpty) {
      return const Center(child: Text('No data for selected range'));
    }

    // Prepare spots
    final spots = _logs.map((log) {
      final x = log.date.millisecondsSinceEpoch.toDouble();
      final y = log.reps.toDouble();
      return FlSpot(x, y);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minY: 0,
          lineTouchData: const LineTouchData(enabled: true),
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Text('${dt.month}/${dt.day}');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: _selectedExercise.color.withOpacity(0.2),
              ),
              spots: spots,
              color: _selectedExercise.color,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (picked != null) {
      setState(() => _range = picked);
      _fetchLogs();
    }
  }
}
