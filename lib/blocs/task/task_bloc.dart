import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tasks_app/models/task_model.dart';
import 'package:flutter_tasks_app/services/db_service.dart';
import 'package:flutter_tasks_app/services/removed_task_db.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState(removedList: [])) {
    on<AddTaskEvent>((event, emit) {
      // TODO: implement event handler

      _addTask(event, emit);
    });
    on<FetchTasksEvent>((event, emit) => fetchTasks(event, emit));
    on<UpdateTaskEvent>((event, emit) => _updateTask(event, emit));
    on<DeleteTaskEvent>((event, emit) => _deleteTask(event, emit));
    on<DeletePermanentlyTaskEvent>(
        (event, emit) => _deletePermanently(event, emit));
    on<RestoreTaskEvent>((event, emit) => _restoreTask(event, emit));
  }

  void _addTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final _state = state;
    DBService.insertTask(event.task);
    emit(TaskState(
        completed: List.from(
          _state.completed,
        ),
        pendingList: List.from(_state.pendingList)..add(event.task),
        removedList: state.removedList));
  }

  void _restoreTask(RestoreTaskEvent event, Emitter<TaskState> emit) async {
    final _state = state;
    DBService.insertTask(event.task);
    RemovedDBService.deleteTask(event.task.id);
    emit(TaskState(
        pendingList: List.from(_state.pendingList)..add(event.task),
        removedList: state.removedList..remove(event.task)));
  }

  void _deleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) {
    final _state = state;
    final taskId = event.task.id;

    // Delete the task from the database
    DBService.deleteTask(taskId);
    RemovedDBService.insertTask(event.task);

    // Filter out the deleted task from the task list

    if (state.completed.contains(event.task)) {
      List<Task> completed =
          _state.completed.where((task) => task.id != taskId).toList();
      emit(TaskState(
          pendingList: List.from([...state.pendingList]),
          completed: List.from([...completed]),
          removedList: List.from([...state.removedList, event.task])));
    } else {
      List<Task> pendingList =
          _state.pendingList.where((task) => task.id != taskId).toList();
      emit(TaskState(
          pendingList: List.from([...pendingList]),
          completed: List.from([...state.completed]),
          removedList: List.from([...state.removedList, event.task])));
    }
    // Update the TaskState with the filtered task list

    // (completed);
  }

  void _updateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    final _state = state;
    final task = event.task;
    await DBService.updateTask(task);

    // if(event.){}
    if (event.task.isDone!) {
      //  ('inisdie if');
      List<Task> pendingTask = _state.pendingList.map((t) {
        if (t.id == task.id) {
          return task;
        } else {
          return t;
        }
      }).toList();
      emit(TaskState(
        pendingList: pendingTask
          ..removeWhere((element) => element.id == task.id),
        removedList: state.removedList,
        completed: List.from([..._state.completed, event.task]),
      ));
    } else {
      //  ('inisdie else');
      List<Task> completedTasks = _state.completed.map((t) {
        if (t.id == task.id) {
          return task;
        } else {
          return t;
        }
      }).toList();

      emit(TaskState(
        pendingList: List.from([..._state.pendingList, event.task]),
        removedList: state.removedList,
        completed: completedTasks
          ..removeWhere((element) => element.id == task.id),
      ));
    }
  }

  void fetchTasks(
      FetchTasksEvent FetchTasksEvent, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    await DBService.database;
    final tasks = await DBService.tasks();
    final removedTasks = await RemovedDBService.tasks();
    emit(TaskState(
        completed: (tasks.where((element) => (element.isDone!)).toList()),
        pendingList: (tasks.where((element) => !(element.isDone!)).toList()),
        removedList: removedTasks));
  }

  void _deletePermanently(
      DeletePermanentlyTaskEvent event, Emitter<TaskState> emit) {
    final _state = state;
    final taskId = event.task.id;

    // Delete the task from the database
    RemovedDBService.deleteTask(taskId);

    // Filter out the deleted task from the task list
    List<Task> updatedTasks =
        _state.removedList.where((task) => task.id != taskId).toList();

    // Update the TaskState with the filtered task list
    emit(TaskState(pendingList: state.pendingList, removedList: updatedTasks));
  }
}
