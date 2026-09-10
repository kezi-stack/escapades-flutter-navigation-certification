import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/destination.dart';
import '../providers/app_providers.dart';
import '../widgets/responsive_destination_grid.dart';
import '../widgets/section_title.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsState = ref.watch(destinationsProvider);
    final destinations = ref.watch(filteredDestinationsProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final query = ref.watch(searchQueryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.refresh(destinationsProvider.future);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _Header(query: query, ref: ref)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
              child: _CategoryFilter(
                categories: categories,
                selected: selectedCategory,
                onSelected: (category) =>
                    ref.read(selectedCategoryProvider.notifier).state = category,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 27, 22, 16),
              child: SectionTitle(
                title: 'Partir autrement',
                subtitle: '${destinations.length} idées pour votre prochain départ',
                actionLabel: query.isEmpty && selectedCategory == 'Tous' ? null : 'Réinitialiser',
                onAction: () {
                  ref.read(searchQueryProvider.notifier).state = '';
                  ref.read(selectedCategoryProvider.notifier).state = 'Tous';
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 35),
              child: destinationsState.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => _ErrorMessage(
                  onRetry: () => ref.invalidate(destinationsProvider),
                ),
                data: (_) => destinations.isEmpty
                    ? const _EmptyResults()
                    : ResponsiveDestinationGrid(
                        destinations: destinations,
                        onDestinationTap: (destination) => context.pushNamed(
                          'destination',
                          pathParameters: {'id': destination.id},
                          extra: destination,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.query, required this.ref});

  final String query;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppTheme.forest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.explore, color: Colors.white),
              ),
              const SizedBox(width: 11),
              const Text(
                'ESCAPADES',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2.2),
              ),
            ],
          ),
          const SizedBox(height: 27),
          const Text(
            'Le monde est\nplus grand que votre routine.',
            style: TextStyle(fontSize: 32, height: 1.07, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            'Des itinéraires sensibles pour voyager avec intention.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.62),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Rechercher une destination...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                      icon: const Icon(Icons.close),
                      tooltip: 'Effacer',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selected == category,
                  onSelected: (_) => onSelected(category),
                  selectedColor: AppTheme.forest,
                  backgroundColor: Theme.of(context).cardColor,
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selected == category
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 42),
          const SizedBox(height: 12),
          const Text('Les destinations sont momentanément indisponibles.'),
          TextButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 50),
      child: Center(child: Text('Aucune destination ne correspond à votre recherche.')),
    );
  }
}