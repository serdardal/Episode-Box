import 'package:episode_box/src/data/data_provider.dart';
import 'package:episode_box/src/pages/add_new_page/add_new_view.dart';
import 'package:episode_box/src/pages/episode_page/episode_list_item.dart';
import 'package:episode_box/src/pages/settings_page/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'dto/episode_dto.dart';

class EpisodeListView extends StatefulWidget {
  const EpisodeListView({
    super.key,
  });

  static const routeName = '/episodes';

  @override
  State<StatefulWidget> createState() => _EpisodeListView();
}

class _EpisodeListView extends State<EpisodeListView> {
  List<EpisodeDto> episodes = [];

  Future getAllEpisodes() async {
    context.loaderOverlay.show();
    var data = await DataProvider.getAllData();

    setState(() {
      episodes = data;
    });

    if (!context.mounted) return;
    context.loaderOverlay.hide();
  }

  void updateItem(mongo.ObjectId id, int? season, int episode) {
    var updatedItems = episodes.where((element) => element.id == id);

    if (updatedItems.isEmpty) return;

    var updatedItem = updatedItems.first;

    updatedItem.season = season;
    updatedItem.episode = episode;
    updatedItem.updated();

    setState(() {
      episodes = [...episodes];
    });
  }

  Future saveUpdatedItems() async {
    var updatedItems = episodes.where((element) => element.isUpdated).toList();
    if (updatedItems.isEmpty) return;

    context.loaderOverlay.show();

    await DataProvider.updateItems(updatedItems);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Changes saved successfully."),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    ));

    getAllEpisodes();
  }

  @override
  void initState() {
    super.initState();
    getAllEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    var hasUpdatedItems = episodes.any((element) => element.isUpdated);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Episodes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  saveUpdatedItems();
                },
                icon: Icon(
                  Icons.save,
                  color: hasUpdatedItems ? Colors.yellow : null,
                )),
            IconButton(
                onPressed: () {
                  getAllEpisodes();
                },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                },
                icon: const Icon(Icons.settings))
          ],
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        body: ListView.builder(
            restorationId: 'episodeList',
            itemCount: episodes.length,
            itemBuilder: (BuildContext context, int index) {
              final item = episodes[index];

              return EpisodeListItem(item, updateItem, index == 0);
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // AddNewView returns true if new item added.
              var refreshRequired = await Navigator.pushNamed<bool?>(
                  context, AddNewView.routeName);

              // refetch list when new item added.
              if (refreshRequired != null && refreshRequired) {
                getAllEpisodes();
              }
            },
            child: const Icon(Icons.add)));
  }
}
