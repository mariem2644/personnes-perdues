import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('personnes_perdues.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const tablePersonnes = '''
    CREATE TABLE personnes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nom TEXT NOT NULL,
      age INTEGER NOT NULL,
      description TEXT,
      derniere_localisation TEXT,
      date_signalement TEXT
    )
    ''';

    await db.execute(tablePersonnes);
  }

  Future<void> ajouterPersonne(Map<String, dynamic> personne) async {
    final db = await instance.database;
    await db.insert('personnes', personne);
  }

  Future<List<Map<String, dynamic>>> getPersonnes() async {
    final db = await instance.database;
    return await db.query('personnes');
  }

  Future<void> mettreAJourPersonne(int id, Map<String, dynamic> nouvellePersonne) async {
    final db = await instance.database;
    await db.update(
      'personnes',
      nouvellePersonne,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> supprimerPersonne(int id) async {
    final db = await instance.database;
    await db.delete(
      'personnes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

class ListePersonnes extends StatefulWidget {
  const ListePersonnes({super.key});

  @override
  _ListePersonnesState createState() => _ListePersonnesState();
}

class _ListePersonnesState extends State<ListePersonnes> {
  List<Map<String, dynamic>> _personnes = [];

  @override
  void initState() {
    super.initState();
    _chargerPersonnes();
  }

  Future<void> _chargerPersonnes() async {
    final data = await DatabaseHelper.instance.getPersonnes();
    setState(() {
      _personnes = data;
    });
  }

  Future<void> _ajouterPersonne() async {
    await DatabaseHelper.instance.ajouterPersonne({
      'nom': 'Ali',
      'age': 10,
      'description': 'Cheveux courts, yeux marrons',
      'derniere_localisation': 'Paris',
      'date_signalement': DateTime.now().toString(),
    });
    _chargerPersonnes(); // Recharger la liste après ajout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnes Perdues'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _ajouterPersonne,
          ),
        ],
      ),
      body: _personnes.isEmpty
          ? Center(child: Text('Aucune personne perdue trouvée'))
          : ListView.builder(
              itemCount: _personnes.length,
              itemBuilder: (context, index) {
                final personne = _personnes[index];
                return ListTile(
                  title: Text(personne['nom']),
                  subtitle: Text('Âge : ${personne['age']} ans\n${personne['description']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance.supprimerPersonne(personne['id']);
                      _chargerPersonnes();
                    },
                  ),
                );
              },
            ),
    );
  }
}
