import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:escapades/data/models/destination.dart';
import 'package:escapades/presentation/providers/app_providers.dart';

void main() {
  const lisbon = Destination(
    id: 'lisbon',
    name: 'Lisbonne',
    country: 'Portugal',
    category: 'City break',
    description: 'Test',
    duration: '4 jours',
    price: 680,
    rating: 4.9,
    imageUrl: '',
    accent: 'F4C6A8',
    highlights: ['Alfama'],
  );
  const kyoto = Destination(
    id: 'kyoto',
    name: 'Kyoto',
    country: 'Japon',
    category: 'Culture',
    description: 'Test',
    duration: '7 jours',
    price: 1890,
    rating: 4.8,
    imageUrl: '',
    accent: 'D7B8A8',
    highlights: ['Gion'],
  );

  test('la recherche filtre par nom et pays', () async {
    final container = ProviderContainer(
      overrides: [
        destinationsProvider.overrideWith((ref) async => [lisbon, kyoto]),
      ],
    );
    addTearDown(container.dispose);
    await container.read(destinationsProvider.future);

    container.read(searchQueryProvider.notifier).state = 'japon';
    expect(container.read(filteredDestinationsProvider), [kyoto]);
  });

  test('la catégorie filtre les destinations disponibles', () async {
    final container = ProviderContainer(
      overrides: [
        destinationsProvider.overrideWith((ref) async => [lisbon, kyoto]),
      ],
    );
    addTearDown(container.dispose);
    await container.read(destinationsProvider.future);

    container.read(selectedCategoryProvider.notifier).state = 'City break';
    expect(container.read(filteredDestinationsProvider), [lisbon]);
  });

  test('le mode clair/sombre peut être inversé', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(themeModeProvider.notifier);

    expect(container.read(themeModeProvider), ThemeMode.light);
    notifier.toggle();
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}