part of 'task_bloc.dart';

class TaskState extends Equatable {
  final List<Task> pendingList;
  final List<Task> completed;
  final List<Task> favList;

  final List<Task> removedList;
  const TaskState(
      {this.pendingList = const [],
      this.completed = const [],
      required this.removedList,
      required this.favList});

  @override
  List<Object> get props => [pendingList, removedList,favList,completed];
}

class TaskLoading extends TaskState {
  TaskLoading() : super(removedList: [], favList: []);
}
