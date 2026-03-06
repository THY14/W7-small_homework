import 'user_history_repository.dart';

class UserHistoryRepositoryMock implements UserHistoryRepository {
  final List<String> _history = [];

  @override
  List<String> fetchHistory() => List.unmodifiable(_history);

  @override
  void addSongId(String id) {
    _history.remove(id); 
    _history.insert(0, id);
  }
}