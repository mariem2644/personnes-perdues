import 'package:flutter/material.dart';
import '../database_helper.dart';

class SignalementPage extends StatefulWidget {
  const SignalementPage({super.key});

  @override
  _SignalementPageState createState() => _SignalementPageState();
}

class _SignalementPageState extends State<SignalementPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variable pour afficher un message d'erreur
  String? _errorMessage;

  void _sauvegarderPersonne() async {
    final nom = _nomController.text;
    final age = int.tryParse(_ageController.text);
    final description = _descriptionController.text;

    // Vérification des entrées
    if (nom.isEmpty || age == null || description.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs correctement';
      });
      return;
    }

    // Sauvegarder la personne dans la base de données
    try {
      await DatabaseHelper.instance.ajouterPersonne({
        'nom': nom,
        'age': age,
        'description': description,
        'photo': '', // Ajouter la gestion des photos plus tard
      });

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personne enregistrée !')),
      );

      // Fermer la page après l'enregistrement
      Navigator.pop(context);
    } catch (e) {
      // Afficher un message d'erreur en cas de problème lors de l'ajout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler une personne'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Âge'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sauvegarderPersonne,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
