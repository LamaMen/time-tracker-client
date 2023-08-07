part of 'bloc.dart';

abstract class AddAmendmentState {
  bool get isReady;
}

class LoadItemsState implements AddAmendmentState {
  const LoadItemsState();

  @override
  bool get isReady => false;
}

class LoadFailedState implements AddAmendmentState {
  final Failure failure;

  const LoadFailedState(this.failure);

  @override
  bool get isReady => false;
}

class SelectItemsState implements AddAmendmentState {
  final List<Project> projects;

  final DateTime? date;
  final int hours;
  final int minutes;
  final bool isPositive;
  final Project? project;

  const SelectItemsState(this.date, this.hours, this.minutes, this.isPositive,
      this.project, this.projects);

  factory SelectItemsState.initial(List<Project> projects) {
    return SelectItemsState(null, 0, 0, true, null, projects);
  }

  SelectItemsState copyWith({
    DateTime? date,
    int? hours,
    int? minutes,
    bool? isPositive,
    User? user,
    Project? project,
  }) {
    return SelectItemsState(
      date ?? this.date,
      hours ?? this.hours,
      minutes ?? this.minutes,
      isPositive ?? this.isPositive,
      project ?? this.project,
      projects,
    );
  }

  @override
  bool get isReady => date != null && project != null;

  Amendment get amendment {
    return Amendment(
      -1,
      date!,
      project!.id,
      hours,
      minutes,
      isPositive,
      '',
    );
  }
}
