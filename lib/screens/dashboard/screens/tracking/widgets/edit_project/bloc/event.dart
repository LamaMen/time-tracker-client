part of 'bloc.dart';

abstract class EditProjectEvent {}

class ChangeArchiveEvent implements EditProjectEvent {
  final bool? isArchive;

  const ChangeArchiveEvent(this.isArchive);
}

class ChangeNameEvent implements EditProjectEvent {
  final String? name;

  const ChangeNameEvent(this.name);
}
