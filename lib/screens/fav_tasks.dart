// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/screens/my_drawer.dart';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_tasks_app/models/task_model.dart';

import '../blocs/task/task_bloc.dart';
import '../widgets/add_task.dart';

import '../widgets/task_widget.dart';

class FavTaskScreen extends StatefulWidget {
  static const name = 'fav_tasks';
  const FavTaskScreen({Key? key}) : super(key: key);

  @override
  State<FavTaskScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<FavTaskScreen> {
  final uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent());
  }

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
                  '${state.favList.length} Favourite Tasks ',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.favList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: MyTask(
                      taskType: TaskType.favs,
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
