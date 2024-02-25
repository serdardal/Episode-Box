import 'package:episode_box/src/pages/episode_page/dto/episode_dto.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class EpisodeListItem extends StatelessWidget {
  final EpisodeDto episodeDto;
  final void Function(ObjectId, int?, int) updateItem;
  final bool isTop;

  const EpisodeListItem(this.episodeDto, this.updateItem, this.isTop,
      {super.key});

  void increaseSeason() {
    if (episodeDto.season == null) return;

    updateItem(episodeDto.id, (episodeDto.season as int) + 1, 1);
  }

  void decreaseSeason() {
    if (episodeDto.season == null || episodeDto.season == 1) return;

    updateItem(episodeDto.id, (episodeDto.season as int) - 1, 1);
  }

  void increaseEpisode() {
    updateItem(episodeDto.id, episodeDto.season, episodeDto.episode + 1);
  }

  void decreaseEpisode() {
    if (episodeDto.episode == 1) return;

    updateItem(episodeDto.id, episodeDto.season, episodeDto.episode - 1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        episodeDto.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        children: [
          Visibility(
            visible: episodeDto.season != null,
            child: Row(
              children: [
                OutlinedButton(
                    onPressed: decreaseSeason, child: const Text("-")),
                SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('S: ${episodeDto.season.toString()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                OutlinedButton(
                    onPressed: increaseSeason, child: const Text("+"))
              ],
            ),
          ),
          Row(
            children: [
              OutlinedButton(
                  onPressed: decreaseEpisode, child: const Text("-")),
              SizedBox(
                width: 60,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('E: ${episodeDto.episode.toString()}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              OutlinedButton(onPressed: increaseEpisode, child: const Text("+"))
            ],
          ),
        ],
      ),
      shape: Border(
        top: isTop ? const BorderSide(width: 2) : BorderSide.none,
        bottom: const BorderSide(width: 2),
      ),
    );
  }
}
