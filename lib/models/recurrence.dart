// Ce fichier contient la définition de la classe Recurrence.

// Définition de la classe Recurrence pour modéliser une récurrence.
class Recurrence {
  // Les propriétés de la classe Recurrence.
  final int id; // L'identifiant unique de la récurrence.
  final DateTime? startDate; // La date de début de la récurrence.
  final DateTime? endDate; // La date de fin de la récurrence.
  final int? dayOfWeek; // Le jour de la semaine de la récurrence (0-6, où 0 est lundi).
  final int? dayOfMonth; // Le jour du mois de la récurrence.
  final int? recurrenceInterval; // L'intervalle de récurrence.

  // Le constructeur de la classe Recurrence.
  // Il initialise toutes les propriétés de la classe avec les valeurs fournies.
  Recurrence({
    required this.id,
    this.startDate,
    this.endDate,
    this.dayOfWeek,
    this.dayOfMonth,
    this.recurrenceInterval,
  });

  // Une méthode factory pour créer une instance de Recurrence à partir d'un Map.
  // Ceci est souvent utilisé pour créer des objets à partir de données JSON.
  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
      id: json['id'], // Assigne l'ID.
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date']) // Convertit la chaîne de date en DateTime si elle n'est pas nulle.
          : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null, // Convertit la chaîne de date en DateTime si elle n'est pas nulle.
      dayOfWeek: json['day_of_week'], // Assigne le jour de la semaine.
      dayOfMonth: json['day_of_month'], // Assigne le jour du mois.
      recurrenceInterval: json['recurrence_interval'], // Assigne l'intervalle de récurrence.
    );
  }
}
