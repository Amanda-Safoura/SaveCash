import 'package:flutter/material.dart';
import 'package:save_cash/views/home.dart';
import 'package:save_cash/views/inscription.dart';
import 'package:save_cash/db/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Connexion(),
      routes: {
        '/inscription': (context) => const Inscription(),
      },
    );
  }
}

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  String numero = '';
  final _formKey = GlobalKey<FormState>();

  final DbHelper dbHelper =
      DbHelper(); // Instance du helper pour la base de données
  final TextEditingController numeroController =
      TextEditingController(); // Contrôleur pour le champ de saisie

  // Fonction pour vérifier si le numéro existe dans la base de données
  void checkUser() async {
    final numero =
        numeroController.text.trim(); // Récupère le numéro sans espace

    if (numero.isEmpty || numero.isEmpty) {
      // Afficher un message de succès ou de redirection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(numero)),
      );
      // Affiche une alerte si le champ est vide
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Veuillez entrer un numéro de téléphone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Recherche de l'utilisateur dans la base de données
    final user = await dbHelper.getUserByNumero(numero);
    if (user != null) {
      // Si l'utilisateur est trouvé, redirige vers la page UserDetails
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(user: user),
        ),
      );
    } else {
      // Si l'utilisateur n'est pas trouvé, affiche une alerte
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Utilisateur non trouvé."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Traitement de l'envoi
      print('Numéro envoyé: $numero');
    }
  }

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
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Connectez-vous',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: numeroController,
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
                        print(numeroController.text);
                        numero = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro de téléphone valide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.black,
                    textStyle: const TextStyle(color: Color(0xFFAEFF7F)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: checkUser,
                  child: const Text(
                    'Envoi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/inscription');
                  },
                  child: const Text(
                    'Êtes-vous inscrit ?',
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
