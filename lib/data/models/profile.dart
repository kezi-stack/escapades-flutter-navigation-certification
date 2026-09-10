class Profile {
  const Profile({
    required this.name,
    required this.subtitle,
    required this.initials,
    required this.visitedCountries,
  });

  final String name;
  final String subtitle;
  final String initials;
  final int visitedCountries;
}