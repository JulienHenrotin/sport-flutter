// lib/state/app_nav_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 0: Recap, 1: Today, 2: Entry, 3: Stats
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
