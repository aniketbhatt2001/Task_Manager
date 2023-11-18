part of 'task_bloc.dart';

class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class FetchTasksEvent extends TaskEvent {

}


class DeletePermanentlyTaskEvent extends TaskEvent {
  final Task task;

  const DeletePermanentlyTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class RestoreTaskEvent extends TaskEvent {
  final Task task;

  const RestoreTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}
