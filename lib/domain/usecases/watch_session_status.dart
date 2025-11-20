import '../entities/session.dart';
import '../repositories/session_repository.dart';

class WatchSessionStatusUseCase {
  final SessionRepository repository;
  WatchSessionStatusUseCase(this.repository);

  Stream<Session> call(String code) {
    return repository.watchSessionStatus(code);
  }
}