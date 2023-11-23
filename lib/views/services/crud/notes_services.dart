import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:expense_tracker/views/services/crud/crud_exeptions.dart';
class NotesService {
  Database? _db;
  List<DatabaseNote> _notes = [];

  static final NotesService _shared = NotesService.sharedInstance();
  NotesService.sharedInstance();
  factory NotesService() => _shared;

  final _notesStreamController = StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<void> _ensureDbIsOpen() async {
    try{
      await open();
    }on DatabaseAlreadyOpened{
      //do nothing
    }
  }

  Future<void> _cachNotes() async{
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try{
      final user = await getUser(email: email);
      return user;
    }on CouldNotFindUser{
      final createdUser = await createUser(email: email);
      return createdUser;
    }catch (e) {
      rethrow;
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable,limit: 1,where: 'id = ?',whereArgs: [id]);
    
    if(notes.isEmpty){
      throw DidNotFindNote();
    }else{
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((notes) =>note.id == id );
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<DatabaseNote> updateNote({required DatabaseNote note , required String text }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await getNote(id:note.id);

   final updateCount = await db.update(noteTable,{
      textColumn:text,
      isSyncedWithCloudColumn:0
    });

    if(updateCount == 0){
      throw CouldNotUpdateNote();
    }else{
      final updatedNote = await getNote(id:note.id);
      _notes.removeWhere((note) =>note.id == updatedNote.id );
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }

  }

  Future<Iterable<DatabaseNote>> getAllNotes() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    final allNotes = notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
    // _notes = allNotes.toList();
    // _notesStreamController.add(_notes);
    return allNotes;
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner,}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getUser(email: owner.email);
    
    const text = '';
    final noteId = await db.insert(noteTable, {
      userIdColumn:owner.id,
      text:text,
      isSyncedWithCloudColumn:1,
    });

    final note = DatabaseNote(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int noteId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(noteTable,where: 'id = ?',whereArgs: [noteId]);
    if (deleteCount != 1) {
      throw CouldNotDeleteNote();
    }else{
      _notes.removeWhere((notes) => notes.id == noteId);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions =  await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    // final db = _db;
    // if (db == null) {
    //   throw DatabaseIsNotOpen();
    // } else {
    //   await db.close();
    //   _db = null;
    // }
   await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpened();
    }
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cachNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deleteCount != 1) {
      throw CouldNotDeleteUSer();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db
        .query(userTable, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {
      emailColumn: [email.toLowerCase()]
    });
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db
        .query(userTable, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if(results.isEmpty){
      throw CouldNotFindUser();
    }
    return DatabaseUser.fromRow(results.first);
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person ID = $id, email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note ID = $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const userIdColumn = "user_id";
const textColumn = "text";
const idColumn = "id";
const emailColumn = "email";

const createNoteTable = ''' 
        CREATE TABLE IF NOT EXIST "note" (
	      "id"	INTEGER NOT NULL,
	      "user_id"	INTEGER,
	      "text"	TEXT,
	      "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	      PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';

const createUserTable = ''' 
      CREATE TABLE IF NOT EXIST "user" (
	    "id"	INTEGER NOT NULL,
	    "email"	TEXT NOT NULL UNIQUE,
	    PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
