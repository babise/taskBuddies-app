import 'recurrence.dart'; // Importation de la classe Recurrence depuis le fichier recurrence.dart.

// Définition de la classe Task pour modéliser une tâche.
class Task {
  // Les propriétés de la classe Task.
  final DateTime createdAt; // La date de création de la tâche.
  final DateTime updatedAt; // La date de mise à jour de la tâche.
  final int id; // L'identifiant unique de la tâche.
  final String title; // Le titre de la tâche.
  final List<Recurrence> recurrences; // La liste des récurrences de la tâche.

  // Le constructeur de la classe Task.
  // Il initialise toutes les propriétés de la classe avec les valeurs fournies.
  Task({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.title,
    required this.recurrences,
  });

  // Une méthode factory pour créer une instance de Task à partir d'un Map.
  // Ceci est souvent utilisé pour créer des objets à partir de données JSON.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      createdAt: DateTime.parse(json['createdAt']), // Convertit la chaîne de date en DateTime.
      updatedAt: DateTime.parse(json['updatedAt']), // Convertit la chaîne de date en DateTime.
      id: json['id'], // Assigne l'ID.
      title: json['title'], // Assigne le titre.
      // Mappe la liste des récurrences en objets Recurrence.
      recurrences: (json['recurrences'] as List)
          .map((e) => Recurrence.fromJson(e))
          .toList(),
    );
  }
}
