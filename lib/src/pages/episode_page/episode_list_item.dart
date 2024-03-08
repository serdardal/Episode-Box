import 'package:episode_box/src/pages/episode_page/dto/episode_dto.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class EpisodeListItem extends StatelessWidget {
  final EpisodeDto episodeDto;
  final void Function(ObjectId, int?, int) updateItem;
  final void Function(ObjectId) deleteItem;
  final bool isTop;

  const EpisodeListItem(
      this.episodeDto, this.updateItem, this.deleteItem, this.isTop,
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

  Function() onDeletePressed(BuildContext context) {
    return () => {_showDeleteConfirmDialog(context)};
  }

  _showDeleteConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        deleteItem(episodeDto.id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete item"),
      content: const Text("Are you sure to delete this item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text(
          episodeDto.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        IconButton(
          onPressed: onDeletePressed(context),
          icon: Icon(Icons.delete_forever_outlined, color: Colors.red[900]),
        )
      ]),
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
