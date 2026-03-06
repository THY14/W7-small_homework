abstract class UserHistoryRepository {
  List<String> fetchHistory();
  void addSongId(String id);
}