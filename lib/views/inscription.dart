import 'package:flutter/material.dart';
import 'package:save_cash/views/connexion.dart';
import "package:save_cash/db/db_helper.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Inscription(),
      routes: {
        '/connexion': (context) => Connexion(),
      },
    );
  }
}

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  String nom = '';
  String prenom = '';
  String numero = '';
  String pin = '';
  String taux = '';

  final _formKey = GlobalKey<FormState>();

// Instance de la classe DbHelper pour insérer les données dans SQLite
  final DbHelper dbHelper = DbHelper();

  // Fonction pour soumettre le formulaire et enregistrer les données dans la base de données
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Créer un objet avec les données de l'utilisateur
      Map<String, dynamic> user = {
        'nom': nom,
        'prenom': prenom,
        'numero': numero,
        'pin': pin,
        'taux': taux,
      };

      // Insérer les données dans la base de données
      await dbHelper.insertUser(user);

      // Afficher un message de succès ou de redirection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie!')),
      );

      // Tu peux également naviguer vers une autre page si nécessaire
      Navigator.pushNamed(context, '/connexion');
    }
  }
  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // Traitement de l'inscription
  //     print(
  //         'Nom: $nom, Prénom: $prenom, Numéro: $numero, PIN: $pin, Taux: $taux');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAEFF7F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Nom',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nom = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Prénom',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            prenom = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre prénom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Numéro de téléphone',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            numero = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro de téléphone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Code PIN',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            pin = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre code PIN';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Taux d\'épargne (%)',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            taux = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un taux d\'épargne';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.black,
                    // onPrimary: Color(0xFFAEFF7F),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/connexion');
                  },
                  child: const Text(
                    'Déjà inscrit ? Connectez-vous.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
