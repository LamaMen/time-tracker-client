import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker_client/data/models/progress/project_duration.dart';

part 'progress.g.dart';

@JsonSerializable(createToJson: false)
class Progress {
  @JsonKey(name: 'project_id')
  final int projectId;
  final ProjectDuration duration;

  Progress(this.projectId, this.duration);

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
}

@JsonSerializable(createToJson: false)
class DailyProgress extends Progress {
  final bool inWork;

  DailyProgress(super.projectId, super.duration, this.inWork);

  factory DailyProgress.fromJson(Map<String, dynamic> json) =>
      _$DailyProgressFromJson(json);
}