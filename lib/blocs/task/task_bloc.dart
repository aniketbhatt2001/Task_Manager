import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tasks_app/models/task_model.dart';
import 'package:flutter_tasks_app/services/db_service.dart';
import 'package:flutter_tasks_app/services/removed_task_db.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState(removedList: [], favList: [])) {
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
        favList: _state.favList,
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
        favList: _state.favList,
        completed: _state.completed,
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
          favList: List.from([...state.favList]),
          removedList: List.from([...state.removedList, event.task])));
    } else if (state.favList.contains(event.task)) {
      List<Task> favlist =
          _state.favList.where((task) => task.id != taskId).toList();
      emit(TaskState(
          pendingList: List.from([...state.pendingList]),
          completed: List.from([...state.favList]),
          favList: List.from([...favlist]),
          removedList: List.from([...state.removedList, event.task])));
    } else {
      List<Task> pendingList =
          _state.pendingList.where((task) => task.id != taskId).toList();
      emit(TaskState(
          favList: List.from([...state.favList]),
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

    List<Task> updatedPendingList = _state.pendingList;
    List<Task> updatedCompletedList = _state.completed;
    List<Task> updatedFavList = _state.favList;

    // Remove the task from other lists
    updatedCompletedList =
        updatedCompletedList.where((t) => t.id != task.id).toList();
    updatedPendingList =
        updatedPendingList.where((t) => t.id != task.id).toList();
    updatedFavList = updatedFavList.where((t) => t.id != task.id).toList();

    if (event.task.isDone!) {
      // Add the task to the completed list
      updatedCompletedList = List.from([...updatedCompletedList, event.task]);

      // Check if the task is marked as fav and add it to the fav list
      if (event.task.fav!) {
        updatedFavList = List.from([...updatedFavList, event.task]);
      }
    } else {
      // Add the task to the pending list
      updatedPendingList = List.from([...updatedPendingList, event.task]);

      // Check if the task is marked as fav and add it to the fav list
      if (event.task.fav!) {
        updatedFavList = List.from([...updatedFavList, event.task]);
      }
    }
    updatedPendingList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    updatedCompletedList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    updatedFavList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    emit(TaskState(
      pendingList: List.from([...updatedPendingList]),
      removedList: List.from([...state.removedList]),
      favList: List.from([...updatedFavList]),
      completed: List.from([...updatedCompletedList]),
    ));
  }

  void fetchTasks(
      FetchTasksEvent FetchTasksEvent, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    await DBService.database;
    final tasks = await DBService.tasks();
    final removedTasks = await RemovedDBService.tasks();
    emit(TaskState(
        favList: (tasks.where((element) => (element.fav!)).toList()),
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
    emit(TaskState(
        pendingList: state.pendingList,
        removedList: updatedTasks,
        favList: state.favList,
        completed: state.completed));
  }
}
