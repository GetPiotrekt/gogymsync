// lib/data/repositories/session_repository_impl.dart

import 'package:gogymsync/data/datasources/session_remote_datasource.dart';
import 'package:gogymsync/domain/entities/note.dart';
import 'package:gogymsync/domain/entities/session.dart';
import 'package:gogymsync/domain/entities/user.dart';
import 'package:gogymsync/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> joinSession(String code, String userName) async {
    // Tutaj możesz generować userId np. UUID lub pobrać z Firebase Auth
    const userId = 'user_01';
    await remoteDataSource.joinSession(code, userId, userName);
  }

  @override
  Stream<Session> watchSessionStatus(String code) {
    return remoteDataSource.watchSession(code).map(
          (data) => Session.fromMap(
        code,
        data,
      ),
    );
  }

  @override
  Stream<List<User>> watchLobbyUsers(String code) {
    return remoteDataSource.watchLobbyUsers(code).map(
          (list) => list.asMap().entries.map(
            (entry) {
          final id = entry.key.toString(); // lub docId jeśli jest w mapie
          return User.fromMap(id, entry.value);
        },
      ).toList(),
    );
  }

  @override
  Future<void> startSession(String code) async {
    await remoteDataSource.setActive(code);
  }

  // ====================== Notes ======================

  @override
  Stream<List<Note>> watchNotes(String sessionCode) {
    return remoteDataSource.watchNotes(sessionCode).map(
          (list) => list.map(
            (data) => Note.fromMap(data['id'], data),
      ).toList(),
    );
  }

  @override
  Future<void> saveNote(String sessionCode, Note note) async {
    if (note.id.isEmpty) {
      await remoteDataSource.addNote(sessionCode, note.text, note.userName);
    } else {
      await remoteDataSource.updateNote(sessionCode, note.id, note.text);
    }
  }

  @override
  Future<void> removeNote(String sessionCode, String noteId) async {
    await remoteDataSource.deleteNote(sessionCode, noteId);
  }

  @override
  Future<List<Note>> getNotes(String sessionCode) async {
    // Firestore RemoteDataSource ma tylko Stream watchNotes
    // Pobieramy pierwszy snapshot jako Future
    final rawNotes = await remoteDataSource.watchNotes(sessionCode).first;
    return rawNotes.map((data) => Note.fromMap(data['id'], data)).toList();
  }

  @override
  Future<Note> addNote(String sessionCode, String userName, String text) async {
    await remoteDataSource.addNote(sessionCode, text, userName);
    // Firestore generuje ID automatycznie – tymczasowo zwracamy pusty id
    return Note(id: '', userName: userName, text: text);
  }

  @override
  Future<void> updateNote(String sessionCode, String noteId, String newText) async {
    await remoteDataSource.updateNote(sessionCode, noteId, newText);
  }

  @override
  Future<void> deleteNote(String sessionCode, String noteId) async {
    await remoteDataSource.deleteNote(sessionCode, noteId);
  }

  // ====================== End Session ======================

  @override
  Future<void> endSession(String sessionCode) async {
    await remoteDataSource.deleteSessionWithData(sessionCode);
  }

  // ====================== Create Session ======================

  @override
  Future<void> createSession({
    required String sessionCode,
    required String hostName,
    required String date,
    required String hostId,
  }) async {
    await remoteDataSource.createSession(sessionCode, hostName, date, hostId, hostName);
  }
}