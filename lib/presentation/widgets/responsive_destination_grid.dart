import 'package:flutter/material.dart';

import '../../data/models/destination.dart';
import 'destination_card.dart';

class ResponsiveDestinationGrid extends StatelessWidget {
  const ResponsiveDestinationGrid({
    required this.destinations,
    required this.onDestinationTap,
    super.key,
  });

  final List<Destination> destinations;
  final ValueChanged<Destination> onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 720
                ? 3
                : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: destinations.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth >= 720 ? 0.78 : 0.68,
          ),
          itemBuilder: (context, index) {
            final destination = destinations[index];
            return DestinationCard(
              destination: destination,
              onTap: () => onDestinationTap(destination),
            );
          },
        );
      },
    );
  }
}