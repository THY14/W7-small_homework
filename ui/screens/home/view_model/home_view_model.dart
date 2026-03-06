import 'package:flutter/widgets.dart';

import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../data/repositories/user_history/user_history_repository.dart';
import '../../../../model/songs/song.dart';
import '../../../states/player_state.dart';

class HomeViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final UserHistoryRepository _userHistoryRepository;
  final PlayerState _playerState;

  List<Song> _recentSongs = [];
  List<Song> _recommendedSongs = [];

  HomeViewModel({
    required SongRepository songRepository,
    required UserHistoryRepository userHistoryRepository,
    required PlayerState playerState,
  })  : _songRepository = songRepository,
        _userHistoryRepository = userHistoryRepository,
        _playerState = playerState;

  List<Song> get recentSongs => _recentSongs;
  List<Song> get recommendedSongs => _recommendedSongs;

  bool isPlaying(Song song) => _playerState.currentSong == song;

  void init() {
    _buildLists();
    _playerState.addListener(_onPlayerStateChanged);
    notifyListeners();
  }

  void _buildLists() {
    final allSongs = _songRepository.fetchSongs();
    final historyIds = _userHistoryRepository.fetchHistory();
    final historySet = historyIds.toSet();
    _recentSongs = historyIds
        .map((id) => _songRepository.fetchSongById(id))
        .whereType<Song>()
        .toList();

    _recommendedSongs = allSongs.where((s) => !historySet.contains(s.id)).toList();
  }

  void _onPlayerStateChanged() {
    notifyListeners();
  }


  void play(Song song) {
    _userHistoryRepository.addSongId(song.id);
    _playerState.start(song);
    _buildLists();
    notifyListeners();
  }

  void stop() {
    _playerState.stop();
  }

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}