part of 'task_bloc.dart';

class TaskState extends Equatable {
  final List<Task> pendingList;
  final List<Task> completed;

  final List<Task> removedList;
  const TaskState({
    this.pendingList = const [],
    this.completed = const [],
    required this.removedList,
  });

  @override
  List<Object> get props => [pendingList, removedList];
}

class TaskLoading extends TaskState {
  TaskLoading() : super(removedList: []);
}
