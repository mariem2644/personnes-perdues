import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personnes Perdues',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page pour signaler une personne disparue
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignalerPersonnePage(),
                  ),
                );
              },
              child: const Text('Signaler une personne disparue'),
            ),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page pour rechercher une personne disparue
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RechercherPersonnePage(),
                  ),
                );
              },
              child: const Text('Rechercher une personne disparue'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignalerPersonnePage extends StatelessWidget {
  const SignalerPersonnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler une personne disparue'),
      ),
      body: const Center(
        child: Text('Page pour signaler une personne disparue'),
      ),
    );
  }
}

class RechercherPersonnePage extends StatelessWidget {
  const RechercherPersonnePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher une personne disparue'),
      ),
      body: const Center(
        child: Text('Page pour rechercher une personne disparue'),
      ),
    );
  }
}

