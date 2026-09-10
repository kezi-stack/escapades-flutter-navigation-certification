import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  String? _destination;
  DateTime? _departureDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = ref.watch(destinationsProvider).valueOrNull ?? [];
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(22, 26, 22, 8),
            child: Text(
              'Planifier une escapade',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quelques détails et nous préparons une première idée d’itinéraire.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.64),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _FieldLabel(label: 'Votre nom'),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        value == null || value.trim().length < 2 ? 'Indiquez votre nom' : null,
                    decoration: const InputDecoration(hintText: 'Camille Martin'),
                  ),
                  const SizedBox(height: 17),
                  const _FieldLabel(label: 'Votre adresse email'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Indiquez votre email';
                      if (!value.contains('@')) return 'Entrez une adresse valide';
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'bonjour@exemple.com'),
                  ),
                  const SizedBox(height: 17),
                  const _FieldLabel(label: 'Destination souhaitée'),
                  DropdownButtonFormField<String>(
                    value: _destination,
                    items: destinations
                        .map(
                          (destination) => DropdownMenuItem(
                            value: destination.name,
                            child: Text('${destination.name}, ${destination.country}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _destination = value),
                    validator: (value) => value == null ? 'Choisissez une destination' : null,
                    decoration: const InputDecoration(hintText: 'Choisir une destination'),
                  ),
                  const SizedBox(height: 17),
                  const _FieldLabel(label: 'Date de départ'),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(16),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                      child: Text(
                        _departureDate == null
                            ? 'Sélectionner une date'
                            : DateFormat('dd MMMM yyyy', 'fr_FR').format(_departureDate!),
                        style: TextStyle(
                          color: _departureDate == null
                              ? Theme.of(context).hintColor
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  const _FieldLabel(label: 'Une envie particulière ? (facultatif)'),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Rythme doux, bonnes adresses, randonnée...',
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text(
                        'Envoyer ma demande',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _departureDate = date);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez une date de départ.')),
      );
      return;
    }
    ref.read(savedTripsProvider.notifier).state++;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demande envoyée'),
        content: Text(
          'Merci ${_nameController.text.trim()} ! Notre équipe prépare votre escapade à $_destination.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}