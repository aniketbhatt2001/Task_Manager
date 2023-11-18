// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/screens/my_drawer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_tasks_app/models/task_model.dart';

import '../blocs/task/task_bloc.dart';
import '../widgets/add_task.dart';
import '../widgets/pending_task.dart';
import '../widgets/task_widget.dart';

class PendingTasksScreen extends StatefulWidget {
  static const name = 'task_screen';
  const PendingTasksScreen({Key? key}) : super(key: key);

  @override
  State<PendingTasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<PendingTasksScreen> {
  final uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent());
  }

  // void _addTask() {
  //   showModalBottomSheet(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12), topRight: Radius.circular(12))),
  //     context: context,
  //     builder: (ctx) {
  //       return BlocProvider.value(
  //           value: context.read<TaskBloc>(), child: AddTask());
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                label: Text(
                  '${state.pendingList.length} Pending Tasks ',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.pendingList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: MyTask(
                      taskType: TaskType.pending,
                      index: index,
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
