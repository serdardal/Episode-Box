import 'package:mongo_dart/mongo_dart.dart';

class EpisodeDto {
  final ObjectId id;
  final String name;
  int? season;
  int episode;
  bool isUpdated = false;
  DateTime updatedDate;

  EpisodeDto(this.id, this.name, this.season, this.episode, this.updatedDate);

  void updated() {
    isUpdated = true;
    updatedDate = DateTime.now();
  }
}
