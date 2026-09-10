import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/destination.dart';
import '../widgets/remote_image.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.destination, super.key});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 390,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: _CircleButton(
              icon: Icons.arrow_back,
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(14, 92, 14, 12),
                child: Hero(
                  tag: 'destination-${destination.id}',
                  child: RemoteImage(url: destination.imageUrl, borderRadius: 26),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.forest,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    destination.name,
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    destination.country,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFD69135)),
                      const SizedBox(width: 4),
                      Text(
                        '${destination.rating} · ${destination.duration}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    destination.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.72),
                      height: 1.55,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'À ne pas manquer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: destination.highlights
                        .map(
                          (highlight) => Chip(
                            label: Text(highlight),
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined, color: AppTheme.forest),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            'À partir de ${currency.format(destination.price)} par personne',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () => context.goNamed('plan'),
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: const Text(
                        'Planifier ce voyage',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8),
      child: Material(
        color: Colors.white.withOpacity(0.92),
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: AppTheme.ink),
          tooltip: 'Retour',
        ),
      ),
    );
  }
}