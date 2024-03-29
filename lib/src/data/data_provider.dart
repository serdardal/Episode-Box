import 'package:episode_box/src/data/episode_record.dart';
import 'package:episode_box/src/pages/episode_page/dto/episode_dto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DataProvider {
  static Db? _dbInstance;

  static Future<Db> _connect() async {
    _dbInstance ??= await Db.create(dotenv.env['MONGO_CNNCSTR'] as String);
    return _dbInstance as Db;
  }

  static Future<List<EpisodeDto>> getAllData() async {
    var db = await _connect();
    await db.open();

    var coll = db.collection('Episode');

    var episodeRecords = await coll
        .find(SelectorBuilder()
            .sortBy(EpisodeField.updatedDate, descending: true))
        .toList();

    await db.close();

    return episodeRecords.map(_mapEpisodeRecordToEpisodeDto).toList();
  }

  static EpisodeDto _mapEpisodeRecordToEpisodeDto(Map<String, dynamic> e) =>
      EpisodeDto(
          e[EpisodeField.id],
          e[EpisodeField.name],
          e[EpisodeField.season],
          e[EpisodeField.episode],
          e[EpisodeField.updatedDate]);

  static Map<String, dynamic> _mapEpisodeDtoToEpisodeRecord(EpisodeDto e) => {
        EpisodeField.id: e.id,
        EpisodeField.name: e.name,
        EpisodeField.season: e.season,
        EpisodeField.episode: e.episode,
        EpisodeField.updatedDate: e.updatedDate
      };

  static Future updateItems(List<EpisodeDto> updatedItems) async {
    var db = await _connect();
    await db.open();

    var coll = db.collection('Episode');

    for (var element in updatedItems) {
      await coll.update(where.eq(EpisodeField.id, element.id),
          _mapEpisodeDtoToEpisodeRecord(element));
    }

    await db.close();
  }

  static Future addItem(EpisodeDto newItem) async {
    var db = await _connect();
    await db.open();

    var coll = db.collection('Episode');
    await coll.insert(_mapEpisodeDtoToEpisodeRecord(newItem));

    await db.close();
  }

  static Future deleteItem(ObjectId id) async {
    var db = await _connect();
    await db.open();

    var coll = db.collection('Episode');
    await coll.deleteOne(where.eq(EpisodeField.id, id));

    await db.close();
  }
}
