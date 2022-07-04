import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'session.g.dart';

final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

@JsonSerializable(createToJson: false)
class Session {
  final int id;
  final Project project;
  @JsonKey(name: 'startTime', fromJson: _dateFromJson)
  final DateTime startTime;

  Session(this.id, this.project, this.startTime);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  static DateTime _dateFromJson(String date) => formatter.parse(date);
}
