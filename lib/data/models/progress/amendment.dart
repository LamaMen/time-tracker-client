import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/core/utils/date_utils.dart';

part 'amendment.g.dart';

@JsonSerializable(createFactory: false)
class Amendment {
  final int id;
  @JsonKey(toJson: _dateToString)
  final DateTime date;
  final int hours;
  final int minutes;
  @JsonKey(name: 'positive')
  final bool isPositive;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'project_id')
  final int projectId;

  Amendment(
    this.id,
    this.date,
    this.projectId,
    this.hours,
    this.minutes,
    this.isPositive,
    this.userId,
  );

  Map<String, dynamic> toJson() => _$AmendmentToJson(this);

  static String _dateToString(DateTime date) {
    return dateFormatter.format(date);
  }
}
