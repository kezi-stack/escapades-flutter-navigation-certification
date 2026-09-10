# Note au reviewer

## Ce qui a été implémenté

**Escapades** est une application Flutter de découverte et de planification de voyages.

- Navigation multi-écrans avec **GoRouter** et routes nommées :
  - `home` : liste des destinations ;
  - `destination` : détail d’une destination avec le paramètre `/destination/:id` ;
  - `plan` : formulaire de planification ;
  - `profile` : profil et préférences.
- Données de destinations séparées dans `assets/destinations.json`.
- Chargement asynchrone des données via un repository et `FutureProvider`.
- Recherche par nom ou pays.
- Filtrage par catégories dérivées du catalogue.
- Cartes de destinations avec image distante, état de chargement et état d’erreur.
- Écran détail avec `SliverAppBar`, `Hero`, points forts, prix et bouton d’action.
- Formulaire validé avec :
  - nom ;
  - adresse email ;
  - destination ;
  - date de départ ;
  - notes facultatives.
- Validation supplémentaire de la date avec `SnackBar`.
- Bascule du thème clair/sombre depuis l’écran Profil.
- Mise en page responsive :
  - 2 colonnes sur mobile ;
  - 3 colonnes sur tablette ;
  - 4 colonnes sur grand écran.
- Widgets réutilisables isolés dans `lib/presentation/widgets/`.
- Tests unitaires pour la recherche, le filtre de catégorie et le changement de thème.
- README, architecture documentée et aperçus dans `screenshots/`.

## Points spécifiques à vérifier

1. Lancer l’application depuis la page Explorer et attendre le chargement du catalogue.
2. Tester une recherche comme `Japon`, puis effacer la recherche.
3. Tester au moins deux catégories et vérifier l’état vide si aucun résultat ne correspond.
4. Ouvrir une carte et vérifier que le détail affiche la bonne destination, son prix, sa note et ses points forts.
5. Appuyer sur **Planifier ce voyage** et vérifier la navigation vers le formulaire.
6. Soumettre le formulaire vide pour vérifier les messages de validation.
7. Tester un email invalide, une destination non sélectionnée et une date non sélectionnée.
8. Soumettre un formulaire complet et vérifier la confirmation ainsi que l’incrément du compteur dans le profil.
9. Basculer entre le thème clair et le thème sombre depuis **Mon carnet**.
10. Redimensionner la fenêtre pour vérifier le changement du nombre de colonnes.
11. Vérifier les états de chargement, d’erreur réseau et d’absence de résultats.
12. Exécuter les contrôles Flutter :

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Difficultés et limites rencontrées

- Le SDK Flutter n’était pas installé dans l’environnement de développement utilisé pour préparer le dépôt. La compilation, `flutter analyze` et `flutter test` doivent donc être exécutés dans un environnement Flutter local.
- Les dossiers de plateformes (`android/`, `ios/`, `web/`, etc.) doivent être générés localement avec :

```bash
flutter create .
```

- Les aperçus du dossier `screenshots/` sont des références SVG préparées pour documenter les écrans. Ils peuvent être remplacés par des captures d’exécution réelles après le lancement local.
- La route de détail est conçue pour être ouverte depuis une carte de destination, qui transmet l’objet destination via `extra` en plus de l’identifiant d’URL.
- Les données du catalogue et du profil sont locales/mock : aucune API distante ni persistance serveur n’est nécessaire pour le parcours de certification.

## Structure utile pour la revue

```text
lib/core/router/                 Navigation GoRouter
lib/core/theme/                  Thèmes clair et sombre
lib/data/models/                 Modèles Destination et Profile
lib/data/repositories/           Chargement du JSON
lib/presentation/providers/      État Riverpod
lib/presentation/screens/        Écrans de l’application
lib/presentation/widgets/        Composants réutilisables
assets/destinations.json         Catalogue local
test/providers_test.dart         Tests unitaires
```