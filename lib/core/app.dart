// lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/core/theme.dart';
import 'package:workout_tracker/features/entry/entry_page.dart';
import 'package:workout_tracker/features/recap/recap_page.dart';
import 'package:workout_tracker/features/stats/stats_page.dart';
import 'package:workout_tracker/features/today/today_page.dart';
import 'package:workout_tracker/state/app_nav_provider.dart';

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return MaterialApp(
      title: 'Workout Tracker',
      theme: buildTheme(),
      home: Scaffold(
        body: IndexedStack(
          index: index,
          children: const [
            RecapPage(),
            TodayPage(),
            EntryPage(),
            StatsPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.list), label: 'Récap'),
            NavigationDestination(icon: Icon(Icons.today), label: 'Aujourd\'hui'),
            NavigationDestination(icon: Icon(Icons.edit), label: 'Entrer'),
            NavigationDestination(icon: Icon(Icons.show_chart), label: 'Stats'),
          ],
        ),
      ),
    );
  }
}
