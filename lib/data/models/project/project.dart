import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final String name;

  Project(this.id, this.name);

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

@JsonSerializable(createToJson: false)
class InWorkProject extends Project {
  InWorkProject(super.id, super.name);

  factory InWorkProject.fromJson(Map<String, dynamic> json) =>
      _$InWorkProjectFromJson(json);
}