// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:mynotes/extensions/list/filter.dart';
// import 'package:mynotes/services/crud/crud_constants.dart';
// import 'package:mynotes/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';

// class NotesService {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;

//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allnotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotesException();
//         }
//       });

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();

//     await getNote(id: note.id);

//     final updateCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updateCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseIsAlreadyOpenException {
//       // Do nothing - this exception is expected when the database is already opened.
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final allNotes = await db.query(noteTable);
//     return allNotes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//       limit: 1,
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDelitions = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDelitions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();

//     // Confirm that the owner exists with the correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUserException();
//     }

//     const text = '';
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     final note = DatabaseNote(
//       isSyncedWithCloud: true,
//       id: noteId,
//       userId: owner.id,
//       text: text,
//     );
//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return (note);
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result = await db.query(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//       limit: 1,
//     );
//     if (result.isEmpty) {
//       throw CouldNotFindUserException();
//     } else {
//       return DatabaseUser.fromRow(result.first);
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(userTable,
//         where: 'email = ?', whereArgs: [email.toLowerCase()]);
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final result =
//         await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [
//       email.toLowerCase(),
//     ]);
//     if (result.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userId = await db.insert(
//       userTable,
//       {emailColumn: email.toLowerCase()},
//     );
//     return DatabaseUser(id: userId, email: email);
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsAlreadyCloseException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) throw DatabaseIsAlreadyOpenException();
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       await db.execute(createUserTable);

//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToFindDocumentsDirectoryException();
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) throw DatabaseIsAlreadyCloseException();
//     await db.close();
//     _db = null;
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, EMAIL = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseNote({
//     required this.isSyncedWithCloud,
//     required this.id,
//     required this.userId,
//     required this.text,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note , ID = $id , userId = $userId , isSyncedWithCloud = $isSyncedWithCloud ';

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
