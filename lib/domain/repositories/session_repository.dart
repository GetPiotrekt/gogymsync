import 'package:gogymsync/domain/entities/note.dart';
import 'package:gogymsync/domain/entities/session.dart';
import 'package:gogymsync/domain/entities/user.dart';

abstract class SessionRepository {
  Future<void> joinSession(String code, String userName);

  Stream<Session> watchSessionStatus(String code);
  Stream<List<User>> watchLobbyUsers(String code);
  Future<void> startSession(String code);

  // Nowe metody dla Notatek
  Stream<List<Note>> watchNotes(String sessionCode);
  Future<List<Note>> getNotes(String sessionCode);
  Future<Note> addNote(String sessionCode, String userName, String text);
  Future<void> updateNote(String sessionCode, String noteId, String newText);
  Future<void> deleteNote(String sessionCode, String noteId);
  Future<void> saveNote(String sessionCode, Note note);
  Future<void> removeNote(String sessionCode, String noteId);
  Future<void> endSession(String sessionCode);
  Future<void> createSession({
    required String sessionCode,
    required String hostName,
    required String date,
    required String hostId,
  });
}