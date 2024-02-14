import 'package:episode_box/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

import 'dto/episode_dto.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView(
      {super.key,
      this.episodeItems = const [
        EpisodeDto('SpongeBob', null, 10),
        EpisodeDto('X-Files', 5, 2)
      ]});

  static const routeName = '/episodes';
  final List<EpisodeDto> episodeItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Episodes'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                },
                icon: const Icon(Icons.settings))
          ],
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: ListView.builder(
            restorationId: 'episodeList',
            itemCount: episodeItems.length,
            itemBuilder: (BuildContext context, int index) {
              final item = episodeItems[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                    '${item.season != null ? 'S: ${item.season.toString()}\n' : ''}E: ${item.episode}'),
                shape: Border(
                  top:
                      index == 0 ? const BorderSide(width: 2) : BorderSide.none,
                  bottom: const BorderSide(width: 2),
                ),
              );
            }));
  }
}
