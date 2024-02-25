import 'package:mongo_dart/mongo_dart.dart';

class EpisodeDto {
  final ObjectId id;
  final String name;
  int? season;
  int episode;
  bool isUpdated = false;

  EpisodeDto(this.id, this.name, this.season, this.episode);

  void updated() {
    isUpdated = true;
  }
}
