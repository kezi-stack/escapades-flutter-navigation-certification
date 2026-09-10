import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/destination.dart';

class DestinationRepository {
  Future<List<Destination>> fetchDestinations() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final raw = await rootBundle.loadString('assets/destinations.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Destination.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}