part of 'bloc.dart';

class EditProjectState {
  final Project project;

  const EditProjectState(this.project);

  EditProjectState copyWith({
    String? name,
    bool? isArchive,
  }) {
    final p = Project(
      project.id,
      name ?? project.name,
      isArchive ?? project.isArchive,
    );
    return EditProjectState(p);
  }
}
