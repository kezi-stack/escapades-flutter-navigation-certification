import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/destination.dart';
import '../../presentation/screens/detail_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/plan_screen.dart';
import '../../presentation/screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/plan',
          name: 'plan',
          builder: (context, state) => const PlanScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/destination/:id',
      name: 'destination',
      builder: (context, state) {
        final destinationId = state.pathParameters['id'];
        final destination = state.extra as Destination?;
        if (destination == null || destination.id != destinationId) {
          return const Scaffold(
            body: Center(child: Text('Destination introuvable')),
          );
        }
        return DetailScreen(destination: destination);
      },
    ),
  ],
);

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = location == '/plan' ? 1 : location == '/profile' ? 2 : 0;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.goNamed('home');
            case 1:
              context.goNamed('plan');
            case 2:
              context.goNamed('profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_calendar_outlined),
            selectedIcon: Icon(Icons.edit_calendar),
            label: 'Planifier',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}