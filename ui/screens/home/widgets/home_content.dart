import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/songs/song.dart';
import '../../../states/settings_state.dart';
import '../../../theme/theme.dart';
import '../view_model/home_view_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final settingsState = context.watch<AppSettingsState>();

    return Container(
      color: settingsState.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text("Home", style: AppTextStyles.heading),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Your recent songs",
                      style: AppTextStyles.label.copyWith(color: Colors.grey)),
                ),
                ..._buildSongTiles(vm, vm.recentSongs),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("You might also like",
                      style: AppTextStyles.label.copyWith(color: Colors.grey)),
                ),
                ..._buildSongTiles(vm, vm.recommendedSongs),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSongTiles(HomeViewModel vm, List<Song> songs) {
    return songs.map((song) {
      final playing = vm.isPlaying(song);
      return ListTile(
        title: Text(song.title),
        onTap: () => vm.play(song),
        trailing: playing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Playing", style: TextStyle(color: Colors.pink)),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: vm.stop,
                    child: const Text("STOP"),
                  ),
                ],
              )
            : null,
      );
    }).toList();
  }
}