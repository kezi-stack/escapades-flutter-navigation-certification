import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/destination.dart';
import '../../data/models/profile.dart';
import '../../data/repositories/destination_repository.dart';

final destinationRepositoryProvider = Provider<DestinationRepository>(
  (ref) => DestinationRepository(),
);

final destinationsProvider = FutureProvider<List<Destination>>((ref) {
  return ref.watch(destinationRepositoryProvider).fetchDestinations();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tous');

final categoriesProvider = Provider<List<String>>((ref) {
  final destinations = ref.watch(destinationsProvider).valueOrNull ?? <Destination>[];
  final categories = destinations.map((item) => item.category).toSet().toList()..sort();
  return ['Tous', ...categories];
});

final filteredDestinationsProvider = Provider<List<Destination>>((ref) {
  final destinations = ref.watch(destinationsProvider).valueOrNull ?? <Destination>[];
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  return destinations.where((destination) {
    final matchesQuery = query.isEmpty ||
        destination.name.toLowerCase().contains(query) ||
        destination.country.toLowerCase().contains(query);
    final matchesCategory = category == 'Tous' || destination.category == category;
    return matchesQuery && matchesCategory;
  }).toList();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

final savedTripsProvider = StateProvider<int>((ref) => 3);

final profileProvider = Provider<Profile>(
  (ref) => const Profile(
    name: 'Camille Martin',
    subtitle: 'Voyageuse curieuse',
    initials: 'CM',
    visitedCountries: 8,
  ),
);