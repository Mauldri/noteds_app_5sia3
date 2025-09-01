import 'package:noteds_app_5sia3/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:noteds_app_5sia3/models/user_model.dart';

class DatabaseHelper {
// Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Configuration variables
  static Database? _database;
  final String databaseName = "note_app.db";
  final int databaseVersion = 1;
  

// Create user table
  final String createUserTable = '''
CREATE TABLE users (
userId INTEGER PRIMARY KEY AUTOINCREMENT,
userName TEXT UNIQUE NOT NULL,
userPassword TEXT NOT NULL
)''';

// create note table
  final String createNoteTable = '''
CREATE TABLE notes (
noteId INTEGER PRIMARY KEY AUTOINCREMENT,
noteTitle TEXT NOT NULL,
noteContent TEXT NOT NULL,
createdAt TEXT DEFAULT CURRENT_TIMESTAMP
)
''';

// Initialize the database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: (db, version) async {
        await db.execute(createUserTable);
        await db.execute(createNoteTable);
      },
    );
  }

// Getter database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Login method
  Future<bool> login(UserModel user) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'userName = ? AND userPassword = ?',
      whereArgs: [user.userName, user.userPassword],
    );
    return result.isNotEmpty;
  }

// Fungsi Create Account
  Future<int> createAccount(UserModel user) async {
    final Database db = await database;
    return db.insert('users', user.toMap());
  }

  // Create note method
  Future<int> createNote(NoteModel note) async {
    final Database db = await database;
    return db.insert('notes', note.toMap());
  }



}
