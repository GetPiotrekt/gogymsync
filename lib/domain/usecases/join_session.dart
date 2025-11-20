import '../repositories/session_repository.dart';

class JoinSessionUseCase {
  final SessionRepository repository;

  JoinSessionUseCase(this.repository);

  // Use Case wykonuje logikę biznesową, używając Repo
  Future<void> call(String code, String userName) async {
    // Tutaj może odbywać się walidacja domeny
    if (code.length != 6) {
      throw Exception("Invalid session code length.");
    }

    // Wywołanie repozytorium do wykonania operacji
    await repository.joinSession(code, userName);
  }
}