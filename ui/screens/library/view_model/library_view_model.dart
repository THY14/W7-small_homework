import 'package:flutter/widgets.dart';

import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/songs/song.dart';
import '../../../states/player_state.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final PlayerState _playerState;

  List<Song> _songs = [];

  LibraryViewModel({
    required SongRepository songRepository,
    required PlayerState playerState,
  })  : _songRepository = songRepository,
        _playerState = playerState;

  // Getters 
  List<Song> get songs => _songs;

  Song? get currentSong => _playerState.currentSong;

  bool isPlaying(Song song) => _playerState.currentSong == song;

  // Init
  void init() {
    _songs = _songRepository.fetchSongs();
    _playerState.addListener(_onPlayerStateChanged);
    notifyListeners();
  }

  void _onPlayerStateChanged() {
    notifyListeners();
  }
  void play(Song song) {
    _playerState.start(song);
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