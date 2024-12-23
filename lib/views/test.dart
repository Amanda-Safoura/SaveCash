void main() {
  String message =
      "Transfert effectue pour  2100 FCFA  a CAROLE YEMALIN SANDRA AISSOUN (2290162033230) le 2024-12-18 20:40:52. Frais: 50 FCFA. Nouveau solde: 12450 FCFA, Reference: HENRY. ID de la transaction: 8766003037..";

  // Diviser le message par les espaces
  List<String> words = message.split(' ');

  // Récupérer la 5ᵉ valeur
  String montant = words[4];

  print('Montant transféré: $montant');
}
